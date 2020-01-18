# Makefile
all: calc

first: calc.o
	gcc -o $@ $+

first.o : calc.s
	as -mfpu=vfpv3 -o $@ $<

clean:
	rm -vf calc .s *.o

