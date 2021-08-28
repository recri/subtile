VERSION=0.4
all: fourier
	cd lib; echo  'auto_mkindex . *.tcl' | tclsh

fourier: fourier.c
	$(CC) -O -o fourier fourier.c -lm

clean:
	rm -f fourier *~ */*~ */\#* */core

