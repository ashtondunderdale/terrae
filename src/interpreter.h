typedef enum {
    TokenPlus,
    TokenMinus,
    TokenStar,
    TokenSlash,
    TokenModulo,
    TokenLParen,
    TokenRParen,
    TokenLBrace,
    TokenRBrace,
    TokenDot,
    TokenExclamation,
    TokenNotEquals,
    TokenSingleEquals,
    TokenDoubleEquals,
    TokenNewLine,
    TokenWhiteSpace,
    
    TokenIf,
    TokenWhile,
    TokenFor,
    TokenProc,
    TokenLet,
} TokenType;

typedef struct {
    TokenType tokenType;
    char* value;
    int line;
} Token;

typedef struct {
    Token *tokens;
    long size;
    long capacity;
} TokenList;

typedef struct {
    char *source;
    TokenList tokenList;
    int current_idx;
    int current_line;
    int defect_flag;
} LexerState;

typedef enum {
    LexerDefectNone,
    LexerDefectInvalidToken,
} LexerDefect;

extern Token* tokenize(char *buff);

// struct ReservedWord {
//     TokenType type;
//     char* word;
// };

// static struct ReservedWord ReservedWords[] = {
//     {TokenIf, "if"},
//     {TokenWhile, "while"},
//     {TokenFor, "for"},
//     {TokenProc, "proc"},
//     {TokenLet, "let"},
// };
