import init, { create_cells } from './pkg/gol.js';

async function run() {
    // Initialize the WebAssembly module
    await init();

    // Now it's safe to call exported functions
    const cellsArray = create_cells(800.0, 600.0, 1000);
    console.log(cellsArray); // This will be a Float64Array
}

run();
