use core::panic;
use std::fs;

use lexer::Lexer;
use parser::Parser;

mod lexer;
mod token;
mod parser;
mod ast;

fn main() {
    let source = fs::read_to_string("example/source.clv")
        .expect("Error reading source file.");

    let lexer = Lexer::new(source);
    let tokens = match lexer.tokenize() {
        Ok(tokens) => tokens,
        Err(_) => {
            panic!("Error during tokenization.");
        }
    };

    let mut parser = Parser::new(tokens);
    let ast = parser.parse_ast();


}
