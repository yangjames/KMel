#include <stdint.h>
#include "mex.h"

void mexFunction(int nhls, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
	if (nrhs == 0)
		mexErrMsgTxt("Not enough arguments.");
	if (nrhs > 1)
		mexErrMsgTxt("Too many arguments.");
	uint8_t* head = (uint8_t*)mxGetData(prhs[0]);
	uint8_t len = head[3];
	//mexPrintf("head[0] = %d\n", head[0]);

	//calculate checksum
	int i;
	uint8_t chk=0;
	for (i=0; i<len+1; i++) {
		//mexPrintf("chk = %d\n", chk);
		chk+=head[i+2];
	}
	chk=~chk;

	int temp[]={1, 1};
	plhs[0]=mxCreateNumericArray(2,temp,mxUINT8_CLASS, mxREAL);

//	mxSetData(plhs[0],&chk);
	((uint8_t*)mxGetData(plhs[0]))[0] = chk;
	return;
}
