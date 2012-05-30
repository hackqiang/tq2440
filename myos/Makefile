
CROSS_COMPILE = arm-none-eabi-

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy

CC_FLAGS = -g -DTEXT_BASE=0x33D00000 -march=armv4 -nostdlib -I.
LD_FLAGS = -Bstatic -Ttext 0x33D00000 -T link.lds 

all: main

main: main.c start.S
	$(CC) $(CC_FLAGS) -c -o start.o start.S
	$(CC) $(CC_FLAGS) -c -o main.o main.c
	$(LD) $(LD_FLAGS) -o main start.o main.o
	$(OBJCOPY) -O binary -S main main.bin
	
clean:
	rm -rf *.o main main.bin
