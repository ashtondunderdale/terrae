use core::panic;
use std::arch::x86_64;

use crate::{ast::{Ast, AstNode, BinaryExpression, BooleanLiteral, FloatLiteral, IntegerLiteral, StringLiteral}, token::{Symbol, Token}};

pub struct Parser {
    ast: Ast,
    position: usize,
    tokens: Vec<Token>
}

impl Parser {
    pub fn new(tokens: Vec<Token>) -> Self {
        Self {
            ast: Ast::new(),
            position: 0,
            tokens
        }
    }

    fn current_token(&self) -> Option<&Token> {
        return self.tokens.get(self.position)
    }

    pub fn parse_ast(&mut self) {
        while self.position < self.tokens.len() {
            if let Some(expr) = self.parse_binary() {
                self.ast.body.push(expr);
            } 
            else {
                panic!("Unexpected token or failed to parse expression");
            }

            self.position += 1;
        }

        self.print();
    }

    fn parse_binary(&mut self) -> Option<AstNode> {
        let mut left = self.parse_primary();
        self.position += 1;

        while let Some(token) = self.current_token() {
            match token.symbol {
                Symbol::Plus | Symbol::Minus => {
                    let operator = token.clone();
                    self.position += 1;

                    if let Some(right) = self.parse_primary() {
                        self.position += 1;
                        
                        left = Some(AstNode::BinaryExpressionNode({
                            BinaryExpression {
                                left: Box::new(left.unwrap()),
                                operator,
                                right: Box::new(right)
                            }
                        }))
                    }
                }
                _ => {
                    break;
                }
            }
        }

        return left
    }

    fn parse_primary(&mut self) -> Option<AstNode> {
        match self.current_token() {
            Some(token) => {
                match token.symbol {
                    Symbol::String => {
                        Some(AstNode::StringLiteralExpression(StringLiteral { 
                            value: token.lexeme.to_string() 
                        }))
                    },
                    Symbol::Integer => {
                        Some(AstNode::IntegerLiteralExpression(IntegerLiteral { 
                            value: str::parse(&token.lexeme).expect("") 
                        }))
                    },
                    Symbol::Float => {
                        Some(AstNode::FloatLiteralExpression(FloatLiteral { 
                            value: str::parse(&token.lexeme).expect("") 
                        }))
                    },
                    Symbol::False | Symbol::True => {
                        Some(AstNode::BooleanLiteralExpression(BooleanLiteral { 
                            value: if token.lexeme == "true" { true } else { false }
                        }))
                    },
                    _ => {
                        panic!("Error parsing {} as primary expression", token.lexeme)
                    }
                }

            }
            None => None
        }
    }

    fn print(&self) {
        for expr in &self.ast.body {
            println!("{:?}", expr)
        }
    }
}