NAME ?= 
SOURCE := $(NAME).raylib.macos.c
TARGET := $(NAME).raylib.macos.so

CC := cc
LIB := --shared -fPIC

all: build

build:
	$(CC) $(SOURCE) $(LIB) -o $(TARGET) $(shell pkg-config --cflags --libs raylib)

clean:
	@rm $(TARGET)
