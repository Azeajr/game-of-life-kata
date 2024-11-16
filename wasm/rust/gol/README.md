## Description
This is a simple example of a web assembly project using Rust. The project is based on the tutorial from [Compiling from Rust to WebAssembly](https://developer.mozilla.org/en-US/docs/WebAssembly/Rust_to_Wasm)

## Dependencies
```bash
cargo install wasm-pack
```
## Build
```bash
wasm-pack build --target web
```

## Run
```bash
python3 -m http.server
``` 