
#[derive(Clone, Debug)]
pub enum Symbol {
    Plus,
    Minus,
    Star,
    Slash,
    Modulo,
    PlusEqual,
    MinusEqual,
    StarEqual,
    DoubleStar,
    DoubleStarEqual,
    SlashEqual,
    ModuloEqual,
    Equal,
    DoubleEqual,
    Exclamation,
    NotEqual,
    GreatherThan,
    LessThan,
    AtSign,
    GreaterThanEqual,
    LessThanEqual,
    LeftParen,
    RightParen,
    LeftBrace,
    RightBrace,
    Dot,
    SemiColon,
    Colon,
    Comma,
    Identifier,
    And,
    Or,
    Not,
    True,
    False,
    Return,
    Let,
    If,
    Elif,
    Else,
    While,
    String,
    Integer,
    Float,
    Char
}

// #[derive(Debug)]
// pub enum Literal {
//     Integer(i64),
//     Float(f64),
//     String(String),
//     Boolean(bool),
//     Char(char),
// }

#[derive(Debug, Clone)]
pub struct Token {
    pub symbol: Symbol,
    pub lexeme: String,
    line: usize,
    column: usize
}

impl Token {
    pub fn new(symbol: Symbol, lexeme: String, line: usize, column: usize) -> Self {
        Self {
            symbol,
            lexeme,
            line,
            column
        }
    }
}

