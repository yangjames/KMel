#CFLAGS		= -Wall -O2 -lncurses

#CC			= gcc

#getch: getch.c
#	$(CC) -o $@ $^ $(CFLAGS)

##################################
# FOR COMPILING MEX
##################################

CFLAGS	= -lncurses
MEXEXT	= $(shell mexext)

all: getch setCheckSum
getch: getch.c
	mex -O $^ $(CFLAGS)

setCheckSum: setCheckSum.cc
	mex -O $^


