#include <Eigen/Dense>
#include <mex.h>

using namespace Eigen;

template<class EigenMat, class Mat=MatrixXd>
void projBlockRotation(EigenMat &pA, int dim)
{
	int block_size = dim*dim;
	int num_blocks = pA.size() / block_size;

	// project
#pragma omp parallel for
	for (int ii = 0; ii < num_blocks; ii++)
	{
        Map<Mat> currA(pA.data()+block_size*ii, dim, dim);
    
		// sign of determinant 
		bool flipped = (currA.determinant() < 0);
        
		// svd
        JacobiSVD<Mat> svdA(dim, dim, (ComputeFullU | ComputeFullV));
		svdA.compute(currA);
        
		// compute frames;
		Mat U = svdA.matrixU();
		Mat V = svdA.matrixV();

		// ssvd
		if (flipped) {
			U.col(dim - 1) = -U.col(dim - 1);
		}
        
		// project block
		currA = U*V.transpose();
	}
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
	int m = mxGetM(prhs[0]); // # rows of A
	int n = mxGetN(prhs[0]); // # cols of A

    int dim = m;

    if (n/dim*dim != n) mexErrMsgTxt("incorrect matrix dimension, should be blocks of square matrices");
	
	// init output
    plhs[0] = mxDuplicateArray(prhs[0]);

	// project
    using MapMat = Map<MatrixXd>;
    if(m==3)
        projBlockRotation<MapMat, Matrix3d>(MapMat(mxGetPr(plhs[0]), m, n), dim);
    else if(m==4)
        projBlockRotation<MapMat, Matrix4d>(MapMat(mxGetPr(plhs[0]), m, n), dim);
    else
        projBlockRotation(MapMat(mxGetPr(plhs[0]), m, n), dim);
}