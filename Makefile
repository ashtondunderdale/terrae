CC = gcc
CFLAGS = -Wall -g

SRCS = src/lex.c src/main.c
HDRS = src/interpreter.h

OBJS = $(SRCS:.c=.o)
TARGET = interpreter

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

%.o: %.c $(HDRS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run
