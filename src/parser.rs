use core::panic;

use crate::{ast::{Ast, AstNode, BinaryExpression, BooleanLiteral, FloatLiteral, Identifier, IntegerLiteral, StringLiteral}, token::{Symbol, Token}};

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
            if let Some(expr) = self.parse_expression() {
                self.ast.body.push(expr);
            } 
            else {
                panic!("Unexpected token or failed to parse expression");
            }

            self.position += 1;
        }

        self.print();
    }

    fn parse_expression(&mut self) -> Option<AstNode> {
        return self.parse_term();
    }

    fn parse_term(&mut self) -> Option<AstNode> {
        let mut left = self.parse_factor();

        while let Some(token) = self.current_token() {
            match token.symbol {
                Symbol::Plus | Symbol::Minus => {
                    let operator = token.clone();
                    self.position += 1;

                    if let Some(right) = self.parse_factor() {
                        left = Some(AstNode::BinaryExpressionNode({
                            BinaryExpression {
                                left: Box::new(left.unwrap()),
                                operator,
                                right: Box::new(right)
                            }
                        }))
                    }
                }
                _ => break
            }
        }

        return left
    }

    fn parse_factor(&mut self) -> Option<AstNode> {
        let mut left = self.parse_primary();

        while let Some(token) = self.current_token() {
            match token.symbol {
                Symbol::Star | Symbol::Slash | Symbol::Modulo => {
                    let operator = token.clone();
                    self.position += 1;

                    if let Some(right) = self.parse_factor() {
                        left = Some(AstNode::BinaryExpressionNode({
                            BinaryExpression {
                                left: Box::new(left.unwrap()),
                                operator,
                                right: Box::new(right)
                            }
                        }))
                    }
                }
                _ => break
            }
        }

        return left
    }

    fn parse_primary(&mut self) -> Option<AstNode> {
        if let Some(token) = self.current_token().cloned() {
            self.position += 1;
    
            match token.symbol {
                Symbol::String => {
                    Some(AstNode::StringLiteralExpression(StringLiteral {
                        value: token.lexeme.to_string()
                    }))
                },
                Symbol::Integer => {
                    Some(AstNode::IntegerLiteralExpression(IntegerLiteral {
                        value: str::parse(&token.lexeme).expect("Invalid integer format")
                    }))
                },
                Symbol::Float => {
                    Some(AstNode::FloatLiteralExpression(FloatLiteral {
                        value: str::parse(&token.lexeme).expect("Invalid float format")
                    }))
                },
                Symbol::False | Symbol::True => {
                    Some(AstNode::BooleanLiteralExpression(BooleanLiteral {
                        value: token.lexeme == "true" 
                    }))
                },
                Symbol::Identifier => {
                    Some(AstNode::IdentifierExpression(Identifier {
                        value: token.lexeme
                    }))
                },
                _ => {
                    panic!("Error parsing {} as primary expression", token.lexeme)
                }
            }
        } else {
            None
        }
    }
    

    fn print(&self) {
        for expr in &self.ast.body {
            println!("{:?}", expr.to_string())
        }
    }
}