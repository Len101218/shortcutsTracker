LDLIBS=-lX11 -lcrypt
CFLAGS=-Wall -Wextra

#SRC=kgrab.c
SRC=test2.c
TARGET_NAME=kgrab

.PHONY: all clean

all:
	$(CC) $(SRC) -o $(TARGET_NAME) $(LDLIBS) $(CFLAGS)

clean:
	rm -rf $(TARGET_NAME)
