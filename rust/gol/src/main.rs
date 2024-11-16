use actix_web::{web, App, HttpServer};
mod cust_routes;
use cust_routes::echo;
use cust_routes::hello;
use cust_routes::manual_hello;
// use actix_web::middleware::Logger;
// use env_logger::Env;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("Starting server at http://127.0.0.1:8080");

    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(hello))
            .route("/echo", web::post().to(echo))
            .route("/hey", web::get().to(manual_hello))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
