NAME ?= 
SOURCE := $(NAME).raylib.macos.c
TARGET := $(NAME).raylib.macos

CC := cc
LIB := --shared -fPIC

all: build

build:
	$(CC) $(SOURCE) -o $(TARGET) $(shell pkg-config --cflags --libs raylib)

clean:
	@rm $(TARGET)
