function MIHE_para= MIHE_parameters()


% This function generates the parameters structure for MIHE

% REFERENCE :
% C. Jiao, C. Chen, R. McGarvey, S. Bohlman, A. Zare 
% Multiple Instance Hybrid Estimator for Hyperspectral Target Characterization and Sub-pixel Target Detection
% submited to ISPRS Jounal of Photogrammetry and Remote Sensing, vol. .., no. .., pp. .-., 2018
%
% SYNTAX : MIHE_para= MIHE_parameters()

% Inputs:
%    None
%
% Outputs:
% iterationCap: Iteration cap, used to stop the algorithm
% eps: minimum in MIHE 
% initial_mthd: initialization for background concepts, 'vca' or 'kmeans' 
% coding_method: unmixing method, 'sparse' unsing sparse unmixing, 'convex' using convex unmixing
% changeThresh: stop when change between iterations smaller than this value
% step_length: preset step length for gradient of d
% beta: scale value for probability
% T: number of target atoms
% M: number of background atoms
% rho: coefficient of weight for points for negative part of objective function
% b: exponential value for gen mean model
% lambda: sparsity level for soft shrinkage
% alpha: scaling factor for discriminative term


% Contact: Alina Zare
% University of Florida, Department of Electrical and Computer Engineering
% Email Address: azare@ece.ufl.edu

% MIT License
% 
% Copyright (c) [2018]
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
    
MIHE_para.iterationCap = 200;
MIHE_para.eps=eps;  
MIHE_para.initial_mthd = 'vca';
MIHE_para.coding_method='sparse';
MIHE_para.changeThresh=1e-5;
MIHE_para.step_length=1e-3; 
MIHE_para.beta=5; 
MIHE_para.T =1;  
MIHE_para.M=9;  
MIHE_para.rho=0.8; 
MIHE_para.b=5; 
MIHE_para.lambda=1e-3;
MIHE_para.alpha=1e-2; 
    
end
