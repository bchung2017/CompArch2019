# Makefile
all: CompArchProject2_cleaned

first: CompArchProject2_cleaned.o
	gcc -o $@ $+

first.o : CompArchProject2_cleaned.s
	as -o $@ $<

clean:
	rm -vf CompArchProject2_cleaned *.o
