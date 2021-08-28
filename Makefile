VERSION=0.2
all: _fourier
	cd lib; echo  'auto_mkindex . *.tcl' | tclsh

_fourier: _fourier.c
	$(CC) -O -o _fourier _fourier.c -lm

clean:
	rm -f _fourier *~ tiling.ps */*~ */\#* */core

shar: clean
	cd ..;	shar subtile subtile/* subtile/*/* > /tmp/subtile-$(VERSION).shar

