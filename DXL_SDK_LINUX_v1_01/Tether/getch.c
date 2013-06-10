#include <stdio.h>
#include <ncurses.h>
#include "mex.h"


void mexFunction(int nhls, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
	if (nrhs != 0)
		mexErrMsgTxt("This function does not take any arguments.");
	char c;
	c=getch();
	int temp[]={1, 1};
	plhs[0]=mxCreateNumericArray(2,temp,mxUINT8_CLASS, mxREAL);
	((char*)mxGetData(plhs[0]))[0] = c;
	return;
}

/*
void main(void) {
	char c;
	while(1) {
		c=getch();
		if (c != EOF)
			printf("%c",c);
	}
}
*/
