MI-HE (Multiple Instance Hybrid Estimator): multiple instance target concept learning algorithm

****************************************************************

NOTE: If the MI-HE Algorithm is used in any publication or presentation, the following reference must be cited:
C. Jiao, C. Chen, R. McGarvey, S. Bohlman, A. Zare 
Multiple Instance Hybrid Estimator for Hyperspectral Target Characterization and Sub-pixel Target Detection
submited to ISPRS Jounal of Photogrammetry and Remote Sensing, vol. .., no. .., pp. .-., 2018

****************************************************************

The command to run the MI-HE algorithm: 

[ D, D_initial ,obj_func,obj_pos,obj_neg,obj_discrim] = MI_HE( pos_bags,neg_bags,parameters )

% Inputs:
%   pos_bags - positive data, in Maltab cell format, each cell is a positive bag
%   neg_bags - negative data, in Matlab cell format, each cell is a negative bag
%   parameters - struct - parameter structure which can be set using the MI_HE() function
%
% Outputs:
%   D - estimated concept set, d by T+M, d is the dimension of the input data, T and M account for the number of target and background concepts, respectively
%   D_initial - Initialization for D
%   obj_func  - total objective function value
%   obj_pos  - objective function value for the generalized mean part
%   obj_neg - objective function value for the fidelity part
%   obj_discrim - objective function value for the discriminative part


**********

Files explanation:

'...\MIHE_Demo':
README.txt                                            -  this file
demo_MIHE_overlap_bags                                -  repeats the synthetic experiment of MI-HE on incomplete background knowledge with SNR 20dB, corresponds to part of the results shown in Fig. 3(a) of the refered paper
incomplete_backgr_knowledge_train.mat                 -  the synthetic data using for incomplete background knowledge experiment

************

'...\MIHE_Demo\MIHE_Code':
MI_HE.m                                                             -  MI-HE (Multiple Instance Hybrid Estimator): multiple instance target concept learning algorithm
HS_unmixing.m                                                       -  given concepts and solve representations with or without sum to one constraint
MIHE_D_Update.m                                                     -  the D update equation
MIHE_func_logJ.m                                                    -  computes the objective functional value
MIHE_gradient_Jdk.m                                                 -  computes the gradient of the kth non-target concept
MIHE_gradient_Jdt.m                                                 -  computes the gradient of the tth target concept
MIHE_initialize.m                                                   -  initializes MI-HE concepts using VCA or kmeans
MIHE_iterations.m                                                   -  interatively computes the concepts D and the data representation A
MIHE_parameters.m                                                   -  generates the parameters structure for MIHE
MIHE_Prob_update.m                                                  -  computes the proablity of each instance from positive bags to be positive or negative bags to be negative 
MIL_format_bag2inst.m                                               -  transforms MIL data from cells to matrix
MIL_format_inst2bag_no_GT.m                                         -  transforms MIL data from  matrix to cells
SP_coding.m                                                         -  implements the iterative soft thresholding algorithm (ISTA)
normalize.m                                                         -  normalization function
VCA.m                                                               -  Vertex Component Analysis algorithm, see reference of the referred paper for more details

******************************************************

Latest Revision: July, 2018

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






