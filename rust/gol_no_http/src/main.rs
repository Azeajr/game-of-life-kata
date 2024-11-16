use macroquad::prelude::*;
use std::collections::{HashMap, HashSet};

const CELL_SIZE: f32 = 10.0;

pub struct World {
    pub living_cells: HashSet<(i32, i32)>,
    pub canvas_width: f32,
    pub canvas_height: f32,
}

impl World {
    pub fn new(canvas_width: f32, canvas_height: f32) -> World {
        let living_cells: HashSet<(i32, i32)> = HashSet::new();

        World {
            living_cells,
            canvas_width,
            canvas_height,
        }
    }

    pub fn add_cell(&mut self, x: i32, y: i32) {
        self.living_cells.insert((x, y));
    }

    pub fn draw(&self) {
        for cell in &self.living_cells {
            draw_rectangle(
                cell.0 as f32 * CELL_SIZE,
                cell.1 as f32 * CELL_SIZE,
                CELL_SIZE,
                CELL_SIZE,
                BLUE,
            );
        }
    }

    pub fn update(&mut self) {
        let mut new_living_cells: HashSet<(i32, i32)> = HashSet::new();
        let mut neighbor_counts: HashMap<(i32, i32), i8> = HashMap::new();

        // Count neighbors for each cell
        for cell in &self.living_cells {
            for dx in -1..=1 {
                for dy in -1..=1 {
                    if dx == 0 && dy == 0 {
                        continue;
                    }
                    let neighbor_pos = (cell.0 + dx, cell.1 + dy);
                    *neighbor_counts.entry(neighbor_pos).or_insert(0) += 1;
                }
            }
        }

        // Determine which cells survive or are born
        for (&(x, y), &count) in &neighbor_counts {
            if count == 3 || (count == 2 && self.living_cells.contains(&(x, y))) {
                new_living_cells.insert((x, y));
            }
        }

        self.living_cells = new_living_cells;
    }

    pub fn add_pattern(&mut self, pattern: &[(i32, i32)], offset_x: i32, offset_y: i32) {
        for &(x, y) in pattern {
            self.add_cell(x + offset_x, y + offset_y);
        }
    }
}

#[macroquad::main("Game of Life")]
async fn main() {
    let mut world = World::new(screen_width(), screen_height());


    let pulsar_pattern = [
        // Top arm
        (2, 0), (3, 0), (4, 0), (8, 0), (9, 0), (10, 0),
        // Upper middle arm
        (0, 2), (5, 2), (7, 2), (12, 2),
        (0, 3), (5, 3), (7, 3), (12, 3),
        (0, 4), (5, 4), (7, 4), (12, 4),
        // Center belt
        (2, 5), (3, 5), (4, 5), (8, 5), (9, 5), (10, 5),
        (2, 7), (3, 7), (4, 7), (8, 7), (9, 7), (10, 7),
        // Lower middle arm
        (0, 8), (5, 8), (7, 8), (12, 8),
        (0, 9), (5, 9), (7, 9), (12, 9),
        (0, 10), (5, 10), (7, 10), (12, 10),
        // Bottom arm
        (2, 12), (3, 12), (4, 12), (8, 12), (9, 12), (10, 12),
    ];

    world.add_pattern(&pulsar_pattern, 10, 10);


    let gosper_glider_gun = [
        (24, 0),
        (22, 1), (24, 1),
        (12, 2), (13, 2), (20, 2), (21, 2), (34, 2), (35, 2),
        (11, 3), (15, 3), (20, 3), (21, 3), (34, 3), (35, 3),
        (0, 4), (1, 4), (10, 4), (16, 4), (20, 4), (21, 4),
        (0, 5), (1, 5), (10, 5), (14, 5), (16, 5), (17, 5), (22, 5), (24, 5),
        (10, 6), (16, 6), (24, 6),
        (11, 7), (15, 7),
        (12, 8), (13, 8),
    ];

    // Add the Gosper Glider Gun to the world with an offset
    world.add_pattern( &gosper_glider_gun, 30, 30);

    let mut last_update = get_time();
    let update_interval = 0.1; // Update every 0.5 seconds

    loop {
        clear_background(RED);

        let current_time = get_time();
        if current_time - last_update >= update_interval {
            world.update();
            last_update = current_time;
        }

        world.draw();

        next_frame().await;
    }
}
