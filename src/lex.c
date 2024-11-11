#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "interpreter.h"

static LexerState *init_lexer(char *buff);
static Token *next_token(LexerState *lexer);
static void add_token(LexerState *lexer, Token *token);
static Token *create_token(LexerState* lexer, TokenType type, const char* value);
static char current_char(LexerState *lexer);
static void advance(LexerState *lexer);
static void raise_lexer_defect(LexerState *lexer, LexerDefect defect);
static void print_tokens(LexerState *lexer);

static char current_char(LexerState *lexer) {
    return lexer->source[lexer->current_idx];
}

static void advance(LexerState *lexer) {
    lexer->current_idx++;
}

Token *create_token(LexerState* lexer, TokenType type, const char* value) {
    Token *token = (Token *)malloc(sizeof(Token));
    token->line = lexer->current_line;
    token->tokenType = type;
    token->value = strdup(value);

    return token;
}

Token* tokenize(char *buff) {
    LexerState *lexer = init_lexer(buff);

    while (current_char(lexer) != '\0') {
        if (lexer->defect_flag) {
            return lexer->tokenList.tokens;
        }

        Token *token = next_token(lexer);
        
        if (token) {
            add_token(lexer, token);
        }

        advance(lexer);
    }

    print_tokens(lexer);
    return lexer->tokenList.tokens;
}

Token *next_token(LexerState *lexer) {
    char c = current_char(lexer);
    char tok_str[2] = {c, '\0'};

    switch (c) {
        case '+': return create_token(lexer, TokenPlus, tok_str);
        case '-': return create_token(lexer, TokenMinus, tok_str);
        case '*': return create_token(lexer, TokenStar, tok_str);
        case '/': return create_token(lexer, TokenSlash, tok_str);
        case '%': return create_token(lexer, TokenModulo, tok_str);

        case '\n':
            lexer->current_line++;
            return create_token(lexer, TokenNewLine, "\\n");
        
        case ' ': 
            return NULL;

        default:
            raise_lexer_defect(lexer, LexerDefectInvalidToken);
            return NULL;
    }
}

void raise_lexer_defect(LexerState *lexer, LexerDefect defect) {
    if (defect == LexerDefectInvalidToken) {
        printf("\nInvalid Token: '%c' on line %d", current_char(lexer), lexer->current_line);
    }

    lexer->defect_flag = 1;
}

void print_tokens(LexerState *lexer) {
    printf("\nTokens:\n");
    for (int i = 0; i < lexer->current_idx; i++) {
        Token token = lexer->tokenList.tokens[i];
        printf("Line %d: %s (%s)\n", token.line, "", token.value);
    }
}

void add_token(LexerState *lexer, Token *token) {
    if (lexer->tokenList.size >= lexer->tokenList.capacity) {
        lexer->tokenList.capacity *= 2;
        lexer->tokenList.tokens = realloc(lexer->tokenList.tokens, lexer->tokenList.capacity * sizeof(Token)); 
    }

    lexer->tokenList.tokens[lexer->tokenList.size++] = *token;
}

LexerState *init_lexer(char *buff) {
    LexerState *lexer = (LexerState *)malloc(sizeof(LexerState));
    lexer->current_idx = 0;
    lexer->current_line = 1;
    lexer->source = buff;
    lexer->defect_flag = 0;

    lexer->tokenList = *(TokenList *)malloc(sizeof(TokenList));
    lexer->tokenList.capacity = 10;
    lexer->tokenList.size = 0;
    lexer->tokenList.tokens = (Token *)malloc(lexer->tokenList.capacity * sizeof(Token));

    return lexer;
}