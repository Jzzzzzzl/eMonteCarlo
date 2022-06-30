#include "stdio.h"
#include "math.h"
#include "mex.h"

/* Compute far distribution function */
void rotateMatrix(double theta,  char *type, double *z)
{
    int i;
    switch(*type)
    {
        case 'x':
            *(z) = 1;
            *(z+1) = 0;
            *(z+2) = 0;
            *(z+3) = 0;
            *(z+4) = cos(theta);
            *(z+5) = sin(theta);
            *(z+6) = 0;
            *(z+7) = -1*sin(theta);
            *(z+8) = cos(theta);
            break;
        case 'y':
            *(z) = cos(theta);
            *(z+1) = 0;
            *(z+2) = -1*sin(theta);
            *(z+3) = 0;
            *(z+4) = 1;
            *(z+5) = 0;
            *(z+6) = sin(theta);
            *(z+7) = 0;
            *(z+8) = cos(theta);
            break;
        case 'z':
            *(z) = cos(theta);
            *(z+1) = sin(theta);
            *(z+2) = 0;
            *(z+3) = -1*sin(theta);
            *(z+4) = cos(theta);
            *(z+5) = 0;
            *(z+6) = 0;
            *(z+7) = 0;
            *(z+8) = 1;
            break;
    }
}
/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    double theta = mxGetScalar(prhs[0]);
    char *type = mxArrayToString(prhs[1]);
    
    plhs[0] = mxCreateDoubleMatrix(3, 3, mxREAL);
    double *outMatrix = mxGetPr(plhs[0]);

    rotateMatrix(theta,type,outMatrix);
    return;
}
