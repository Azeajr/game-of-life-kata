# Game of Life

This project is an implementation of Conway's Game of Life using Rust and the Macroquad game framework.

## Project Structure

## Dependencies

This project uses the following dependencies:

- `macroquad` for rendering and game loop management
- `rand` for random number generation
- `itertools` for various iterator-related utilities
- `ndarray` for numerical operations

## Getting Started

### Prerequisites

- Rust and Cargo installed. You can install Rust and Cargo from [rustup.rs](https://rustup.rs/).

### Building and Running

1. Clone the repository:

```sh
git clone <repository-url>
cd <repository-directory>

```

2. Build and run the project:

```sh
cargo run
```

## Usage
The game starts with a predefined pattern (Pulsar and Gosper Glider Gun) on the canvas. The cells will update every 0.1 seconds. You can modify the patterns and their positions in the main function in src/main.rs.

## Code Overview
### World Struct
The World struct represents the game world and contains the following methods:

new: Initializes a new game world.
add_cell: Adds a cell to the world.
draw: Draws the cells on the canvas.
update: Updates the state of the world based on the Game of Life rules.
add_pattern: Adds a predefined pattern to the world at a specified offset.
### Main Function
The main function initializes the game world, adds predefined patterns, and starts the game loop.