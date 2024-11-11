typedef enum {
    TokenPlus,
    TokenMinus,
    TokenStar,
    TokenSlash,
    TokenModulo,

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

typedef enum {
    LexerDefectNone,
    LexerDefectInvalidToken,
} LexerDefect;

typedef struct {
    char *source;
    TokenList tokenList;
    int current_idx;
    int current_line;
} LexerState;

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
