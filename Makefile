CFLAGS = -Wall -g

SRCS = src/lexer.c src/main.c
HDRS = src/interpreter.h src/token.h

OBJS = $(SRCS:.c=.o)

all: main

main: $(OBJS)
	gcc $(CFLAGS) -o main $(OBJS)

%.o: %.c $(HDRS)
	gcc $(CFLAGS) -c $< -o $@