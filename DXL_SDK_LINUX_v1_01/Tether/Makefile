#CFLAGS		= -Wall -O2 -lncurses

#CC			= gcc

#getch: getch.c
#	$(CC) -o $@ $^ $(CFLAGS)

##################################
# FOR COMPILING MEX
##################################

CFLAGS	= -lncurses
MEXEXT	= $(shell mexext)

getch: getch.c
	mex -O $^ $(CFLAGS)
