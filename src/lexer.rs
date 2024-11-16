use std::collections::HashMap;

use crate::token::{Symbol, Token};

pub struct Lexer {
    source: String,
    tokens: Vec<Token>,
    position: usize,
    line: usize,
    column: usize,
    errors: Vec<LexerError>,
    warning: Vec<LexerWarning>,
    keywords: HashMap<String, Symbol>
}

impl Lexer {
    pub fn new(source: String) -> Self {
        let mut keywords = HashMap::new();

        keywords.insert("and".to_string(), Symbol::And);
        keywords.insert("or".to_string(), Symbol::Or);
        keywords.insert("not".to_string(), Symbol::Not);
        keywords.insert("return".to_string(), Symbol::Return);
        keywords.insert("if".to_string(), Symbol::If);
        keywords.insert("elif".to_string(), Symbol::Elif);
        keywords.insert("else".to_string(), Symbol::Else);
        keywords.insert("while".to_string(), Symbol::While);
        keywords.insert("true".to_string(), Symbol::True);
        keywords.insert("false".to_string(), Symbol::False);
        keywords.insert("let".to_string(), Symbol::Let);

        Self {
            source,
            tokens: Vec::new(),
            position: 0,
            line: 1,
            column: 1,
            errors: Vec::new(),
            warning: Vec::new(),
            keywords
        } 
    }

    fn peek(&self, offset: usize) -> char {
        return self.source.chars().nth(self.position + offset).unwrap_or('\0');
    }

    fn current_char(&self) -> char {
        return self.source.chars().nth(self.position).unwrap_or('\0');
    }

    fn advance(&mut self) {
        self.position += 1;
        self.column += 1;
    }

    fn new_token(&mut self, symbol: Symbol, lexeme: String) {
        let token = Token::new(symbol, lexeme.to_string(), self.line, self.column);
        self.tokens.push(token);
    }

    fn raise_error(&mut self, error: LexerError) {
        self.errors.push(error);
    }

    pub fn tokenize(mut self) -> Result<Vec<Token>, bool> {
        while self.position < self.source.len() {
            let current = self.current_char();

            match current {
                '+' => self.on_plus(),
                '-' => self.on_minus(),
                '*' => self.on_star(),
                '/' => self.on_slash(),
                '%' => self.on_modulo(),
                '(' => self.new_token(Symbol::LeftParen, current.to_string()),
                ')' => self.new_token(Symbol::RightParen, current.to_string()),
                '{' => self.new_token(Symbol::LeftBrace, current.to_string()),
                '}' => self.new_token(Symbol::RightBrace, current.to_string()),
                '.' => self.new_token(Symbol::Dot, current.to_string()),
                ',' => self.new_token(Symbol::Comma, current.to_string()),
                '@' => self.new_token(Symbol::AtSign, current.to_string()),
                ';' => self.new_token(Symbol::SemiColon, current.to_string()),
                ':' => self.new_token(Symbol::Colon, current.to_string()),
                '>' => self.on_greater_than(),
                '<' => self.on_less_than(),
                '=' => self.on_equal(),
                '!' => self.on_exclamation(),
                _ if current.is_alphabetic() => {
                    self.on_identifier();
                }
                _ if current.is_numeric() => self.on_numeric_literal(),
                '\"' => self.on_string_literal(),
                '\'' => self.on_char_literal(),
                ' ' | '\t' | '\r' => {},
                '\n' => {
                    self.line += 1;
                    self.column = 0;
                },
                _   => {
                    self.raise_error(LexerError::UnexpectedCharacter 
                        { character: current, line: self.line, column: self.column
                    });
                }
            };
            
            self.advance();
        }
        
        self.print();

        return Ok(self.tokens);
    }

    fn on_char_literal(&mut self) {
        let mut lexeme = String::new();
        self.advance();
        
        while self.current_char() != '\'' && self.position < self.source.len() {
            lexeme.push(self.current_char());
            self.advance();
        }
    
        if self.current_char() != '\'' {
            self.raise_error(LexerError::UnterminatedString { line: self.line, column: self.column });
            return;
        }
    
        self.new_token(Symbol::Char, lexeme);
    }
    

    fn on_numeric_literal(&mut self) {
        let mut lexeme = String::new();

        let mut has_decimal = false;
        while self.current_char().is_numeric() || self.current_char() == '.' {
            lexeme.push(self.current_char());
            self.advance();

            if self.current_char() == '.' {
                if !has_decimal {
                    has_decimal = true;
                } else {
                    self.raise_error(LexerError::InvalidNumericFormat { line: self.line, column: self.column });
                    return;
                }
            } 
        }
        
        if has_decimal {
            self.new_token(Symbol::Float, lexeme);
        } else {
            self.new_token(Symbol::Integer, lexeme);
        }

        self.position -= 1;
    }

    fn on_string_literal(&mut self) {
        let mut lexeme = String::new();
        
        self.advance();
        while self.current_char() != '\"' && self.position < self.source.len() {
            lexeme.push(self.current_char());
            self.advance();
        }
        
        if self.current_char() != '\"' {
            self.raise_error(LexerError::UnterminatedString { line: self.line, column: self.column });
            return;
        }

        self.new_token(Symbol::String, lexeme);
    }

    fn on_identifier(&mut self) {
        let mut lexeme = String::new();
        while self.current_char().is_alphabetic() {
            lexeme.push(self.current_char());
            self.advance();
        }

        if self.keywords.contains_key(&lexeme) {
            let symbol = self.keywords.get(&lexeme).unwrap();
            self.new_token(symbol.clone(), lexeme);
        } else {
            self.new_token(Symbol::Identifier, lexeme);
        }
    }

    fn handle_operator(&mut self, operator: char, symbol: Symbol, assign_symbol: Symbol) {
        let lexeme = operator.to_string();
        
        if self.peek(1) == '=' {
            let lexeme = format!("{}=", lexeme);
            self.new_token(assign_symbol, lexeme);
            self.advance();
        } else {
            self.new_token(symbol, lexeme);
        }
    }
    
    fn on_plus(&mut self) {
        self.handle_operator('+', Symbol::Plus, Symbol::PlusEqual);
    }
    
    fn on_minus(&mut self) {
        self.handle_operator('-', Symbol::Minus, Symbol::MinusEqual);
    }
    
    fn on_star(&mut self) {
        if self.peek(1) == '*' {
            if self.peek(2) == '=' {
                let lexeme = format!("{}{}{}", self.current_char(), self.peek(1), self.peek(2));
                self.new_token(Symbol::DoubleStarEqual, lexeme);
                self.advance();
            } else {
                let lexeme = format!("{}{}", self.current_char(), self.peek(1));
                self.new_token(Symbol::DoubleStar, lexeme);
            }
            self.advance();
        } else {
            self.handle_operator('*', Symbol::Star, Symbol::StarEqual);
        }
    }
    
    fn on_slash(&mut self) {
        self.handle_operator('/', Symbol::Slash, Symbol::SlashEqual);
    }
    
    fn on_modulo(&mut self) {
        self.handle_operator('%', Symbol::Modulo, Symbol::ModuloEqual);
    }

    fn on_greater_than(&mut self) {
        self.handle_operator('>', Symbol::GreatherThan, Symbol::GreaterThanEqual);
    }

    fn on_less_than(&mut self) {
        self.handle_operator('<', Symbol::LessThan, Symbol::LessThanEqual);
    }

    fn on_exclamation(&mut self) {
        self.handle_operator('!', Symbol::Exclamation, Symbol::NotEqual);
    }

    fn on_equal(&mut self) {
        self.handle_operator('=', Symbol::Equal, Symbol::DoubleEqual);
    }

    fn print(&self) {
        for token in &self.tokens {
            println!("{:?}", token)
        }

        println!();
        for error in &self.errors {
            println!("{:?}", error);
        }

    }
}

enum LexerError {
    UnexpectedCharacter { character: char, line: usize, column: usize },
    UnterminatedString { line: usize, column: usize },
    InvalidNumericFormat { line: usize, column: usize }
}

impl std::fmt::Debug for LexerError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match *self {
            LexerError::UnterminatedString { line, column } 
                => write!(f, "Error: Unterminated string literal at: line: {}, column: {}", line, column),

            LexerError::UnexpectedCharacter { character, line, column } 
                => write!(f, "Error: Unexpected character: '{}', at: line: {}, column: {}", character, line, column),
        
            LexerError::InvalidNumericFormat { line, column } 
                => write!(f, "Error: Invalid numeric format at: line: {}, column: {}", line, column),
        
        }
    }
}

enum LexerWarning {

}