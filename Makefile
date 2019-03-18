# Makefile
all: Project1_1
 
first: Project1_1.o
	gcc -o $@ $+
 
first.o : Project1_1.s
	as -o $@ $<
 
clean:
	rm -vf Project1_1 *.o
