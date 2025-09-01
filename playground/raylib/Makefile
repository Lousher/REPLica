
SOURCE := chinese.raylib.macos.c
TARGET := chinese.raylib.macos

CC := cc

all: build

build:
	@echo "Building target exe on macos with raylib lib"
	$(CC) $(SOURCE) -o $(TARGET) $(shell pkg-config --cflags --libs raylib)

clean:
	@rm $(TARGET)
