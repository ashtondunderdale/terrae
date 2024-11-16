use std::fs;

use lexer::Lexer;
use parser::Parser;

mod lexer;
mod token;
mod parser;

fn main() {
    let source = fs::read_to_string("example/source.clv")
        .expect("Error reading source file.");

    let mut lexer = Lexer::new(source);
    let tokens = lexer.tokenize();

    let mut parser = Parser::new();
    let ast = parser.parse_ast();

    
}
