#include "stdio.h"
#include "math.h"
#include "mex.h"

double VecNorm1(double *x, int m, int n);

/* Compute far distribution function */
void solven(double *x, double *z, mwSize m, mwSize n,
        double deltax, double deltay, double vx, double vy, double tao)
{
    mwSize i;
    mwSize j;
    
    double norm1, norm2;
    double errorMax = 1;
    double aW, aE, aS, aN, aP;
    double nW, nE, nS, nN;
    if (vx >= 0)
    {
        aW = vx / deltax;
        aE = 0;
    }
    else
    {
        aW = 0;
        aE = -1 * vx / deltax;
    }
    if (vy >= 0)
    {
        aS = vy / deltay;
        aN = 0;
    }
    else
    {
        aS = 0;
        aN = -1 * vy / deltay;
    }
    aP = aW + aE + aS + aN + 1/tao;
    norm1 = VecNorm1(z, m, n);
    while (errorMax > 1e-7)
    {
        for (i=1; i<n-1; i++)
        {
            for (j=1; j<m-1; j++)
            {
                nW = *(z+i*m+j-1);
                nE = *(z+i*m+j+1);
                nS = *(z+(i-1)*m+j);
                nN = *(z+(i+1)*m+j);
                *(z+i*m+j) = (aW*nW+aE*nE+aS*nS+aN*nN+*(x+i*m+j))/aP;
            }
        }
        norm2 = norm1;
        norm1 = VecNorm1(z, m, n);
        errorMax = fabs((norm2 - norm1)/norm1);
    }
}
/* Compute norm of matrix */
double VecNorm1(double *z, int m, int n)
{
    double sm = 0;
    int i, j;
    for (j=0; j<m; j++)
    {
        for (i=0; i<n; i++)
        {
            sm += fabs(*(z+i*m+j));
        }
    }
    return sm;
}
/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    double *inMatrix = mxGetPr(prhs[0]);
    double deltax = mxGetScalar(prhs[1]);
    double deltay = mxGetScalar(prhs[2]);
    double vx = mxGetScalar(prhs[3]);
    double vy = mxGetScalar(prhs[4]);
    double tao = mxGetScalar(prhs[5]);

    size_t nrows = mxGetM(prhs[0]);
    size_t ncols = mxGetN(prhs[0]);
    
    plhs[0] = mxCreateDoubleMatrix((mwSize)nrows,(mwSize)ncols,mxREAL);
    double *outMatrix = mxGetPr(plhs[0]);

    solven(inMatrix,outMatrix,(mwSize)nrows,(mwSize)ncols,
            deltax, deltay, vx, vy, tao);
    return;
}
