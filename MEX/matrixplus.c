#include "stdio.h"
#include "math.h"
#include "mex.h"

/* Compute far distribution function */
void matrixplus(double *a, double *b, double *z, mwSize m, mwSize n,
                     double thetap, double thetaq)
{
    mwSize i;
    mwSize j;
    double xx, yy;
    
    for (i=1; i<n-1; i++)
    {
        for (j=1; j<m-1; j++)
        {
            xx = (*(a+i*m+j))*cos(thetap) + (*(b+i*m+j))*cos(thetaq);
            yy = (*(a+i*m+j))*sin(thetap) + (*(b+i*m+j))*sin(thetaq);
            *(z+i*m+j) = 
        }
    }
}
/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    double *matrixA = mxGetPr(prhs[0]);
    double *matrixB = mxGetPr(prhs[1]);
    double thetap = mxGetScalar(prhs[2]);
    double thetaq = mxGetScalar(prhs[3]);

    size_t nrows = mxGetM(prhs[0]);
    size_t ncols = mxGetN(prhs[0]);
    
    plhs[0] = mxCreateDoubleMatrix((mwSize)nrows,(mwSize)ncols,mxREAL);
    double *outMatrix = mxGetPr(plhs[0]);

    matrixplus(matrixA,matrixB,outMatrix,(mwSize)nrows,(mwSize)ncols,thetap,thetaq);
    return;
}
