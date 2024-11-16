use js_sys::Math;
use wasm_bindgen::prelude::*;

#[derive(Clone, Debug)]
pub struct Cell {
    pub x: f64,
    pub y: f64,
}

impl Cell {
    pub fn new(x: f64, y: f64) -> Cell {
        Cell { x, y }
    }
}

pub struct World {
    pub cells: Vec<Cell>,
    pub canvas_width: f64,
    pub canvas_height: f64,
}

impl World {
    pub fn create(width: f64, height: f64, cells: Vec<Cell>) -> World {
        World {
            canvas_width: width,
            canvas_height: height,
            cells,
        }
    }
}

#[wasm_bindgen]
pub fn create_cells(w: f64, h: f64, n: i32) -> Box<[f64]> {
    let mut cells: Vec<f64> = Vec::with_capacity((n * 2) as usize);
    for _ in 0..n {
        let x = Math::random() * w;
        let y = Math::random() * h;
        cells.push(x);
        cells.push(y);
    }
    cells.into_boxed_slice()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_world_create() {
        let cells = vec![Cell::new(1.0, 2.0), Cell::new(3.0, 4.0)];
        let world = World::create(800.0, 600.0, cells.clone());
        assert_eq!(world.canvas_width, 800.0);
        assert_eq!(world.canvas_height, 600.0);
        assert_eq!(world.cells.len(), 2);
        assert_eq!(world.cells[0].x, 1.0);
        assert_eq!(world.cells[0].y, 2.0);
    }
}
