#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "interpreter.h"

static LexerState *initLexer(char *buff);
static void addToken(LexerState *lexer, Token *token);
static void print_tokens(LexerState *lexer);
static void raise_lexer_defect(LexerState *lexer, LexerDefect defect);

char current_char(LexerState *lexer) {
    return lexer->source[lexer->current_idx];
}

Token* tokenize(char* buff) {
    LexerState *lexer = initLexer(buff);

    while (current_char(lexer) != '\0') {
        char* tok = (char *)malloc(2);
        tok[0] = current_char(lexer);
        tok[1] = '\0';

        if (strcmp(tok, "\n") == 0) {
            lexer->current_line++;
        }

        if (strcmp(tok, "+") == 0) {
            Token *token = (Token *)malloc(sizeof(Token));
            token->line = lexer->current_line;
            token->tokenType = TokenPlus;
            token->value = tok;

            addToken(lexer, token);
        } 
        else {
            raise_lexer_defect(lexer, LexerDefectInvalidToken);
            return lexer->tokenList.tokens;
        }

        lexer->current_idx++;
    }


    print_tokens(lexer);

    return lexer->tokenList.tokens;
}

void raise_lexer_defect(LexerState *lexer, LexerDefect defect) {
    if (defect == LexerDefectInvalidToken) {
        printf("\nInvalid Token: '%c' on line %d, at position %d.", current_char(lexer), lexer->current_line, lexer->current_idx);
    }
}

void print_tokens(LexerState *lexer) {
    printf("Tokens:\n");
    for (int i = 0; i < lexer->current_idx; i++) {
        Token token = lexer->tokenList.tokens[i];
        printf("Line %d: %s (%s)\n", token.line, "", token.value);
    }
}

void addToken(LexerState *lexer, Token *token) {
    if (lexer->tokenList.size >= lexer->tokenList.capacity) {
        lexer->tokenList.capacity *= 2;
        lexer->tokenList.tokens = realloc(lexer->tokenList.tokens, lexer->tokenList.capacity * sizeof(Token)); 
    }

    lexer->tokenList.tokens[lexer->tokenList.size++] = *token;
}

LexerState *initLexer(char *buff) {
    LexerState *lexer = (LexerState *)malloc(sizeof(LexerState));
    lexer->current_idx = 0;
    lexer->current_line = 1;
    lexer->source = buff;

    lexer->tokenList = *(TokenList *)malloc(sizeof(TokenList));
    lexer->tokenList.capacity = 1;
    lexer->tokenList.size = 0;
    lexer->tokenList.tokens = (Token *)malloc(lexer->tokenList.capacity * sizeof(Token));

    return lexer;
}