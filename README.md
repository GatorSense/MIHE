


MI-HE (Multiple Instance Hybrid Estimator): multiple instance target concept learning algorithm<br />
<br />
****************************************************************<br />
<br />
NOTE: If the MI-HE Algorithm is used in any publication or presentation, the following reference must be cited:
C. Jiao, C. Chen, R. McGarvey, S. Bohlman, A. Zare 
Multiple Instance Hybrid Estimator for Hyperspectral Target Characterization and Sub-pixel Target Detection
submited to ISPRS Jounal of Photogrammetry and Remote Sensing, In Press, 2018<br />
<br />
NOTE: If the code in this repository is used to prepare any publication or presentation, the following reference must be cited:<br />
Changzhe Jiao and Alina Zare, “GatorSense/MIHE: Initial Release”. Zenodo, 24-Jul-2018.
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1320109.svg)](https://doi.org/10.5281/zenodo.1320109)
<br />
<br />
****************************************************************<br />
<br />
The command to run the MI-HE algorithm: <br />
<br />
[ D, D_initial ,obj_func,obj_pos,obj_neg,obj_discrim] = MI_HE( pos_bags,neg_bags,parameters )<br />
<br />
% Inputs:<br />
%   pos_bags - positive data, in Maltab cell format, each cell is a positive bag<br />
%   neg_bags - negative data, in Matlab cell format, each cell is a negative bag<br />
%   parameters - struct - parameter structure which can be set using the MI_HE() function<br />
%<br />
% Outputs:<br />
%   D - estimated concept set, d by T+M, d is the dimension of the input data, T and M account for the number of target and background concepts, respectively<br />
%   D_initial - Initialization for D<br />
%   obj_func  - total objective function value<br />
%   obj_pos  - objective function value for the generalized mean part<br />
%   obj_neg - objective function value for the fidelity part<br />
%   obj_discrim - objective function value for the discriminative part<br />
<br />
<br />
**********<br />
<br />
Files explanation:<br />
<br />
'...\MIHE_Demo':<br />
README.txt                                            -  this file <br />
demo_MIHE_overlap_bags                                -  repeats the synthetic experiment of MI-HE on incomplete background knowledge with SNR 20dB, corresponds to part of the results shown in Fig. 3(a) of the refered paper <br />
incomplete_backgr_knowledge_train.mat                 -  the synthetic data using for incomplete background knowledge experiment<br />
<br />
************<br />
<br />
'...\MIHE_Demo\MIHE_Code':<br />
MI_HE.m                                                             -  MI-HE (Multiple Instance Hybrid Estimator): multiple instance target concept learning algorithm<br />
HS_unmixing.m                                                       -  given concepts and solve representations with or without sum to one constraint<br />
MIHE_D_Update.m                                                     -  the D update equation<br />
MIHE_func_logJ.m                                                    -  computes the objective functional value<br />
MIHE_gradient_Jdk.m                                                 -  computes the gradient of the kth non-target concept<br />
MIHE_gradient_Jdt.m                                                 -  computes the gradient of the tth target concept<br />
MIHE_initialize.m                                                   -  initializes MI-HE concepts using VCA or kmeans<br />
MIHE_iterations.m                                                   -  interatively computes the concepts D and the data representation A<br />
MIHE_parameters.m                                                   -  generates the parameters structure for MIHE<br />
MIHE_Prob_update.m                                                  -  computes the proablity of each instance from positive bags to be positive or negative bags to be negative <br />
MIL_format_bag2inst.m                                               -  transforms MIL data from cells to matrix<br />
MIL_format_inst2bag_no_GT.m                                         -  transforms MIL data from  matrix to cells<br />
SP_coding.m                                                         -  implements the iterative soft thresholding algorithm (ISTA)<br />
normalize.m                                                         -  normalization function<br />
VCA.m                                                               -  Vertex Component Analysis algorithm, see reference of the referred paper for more details<br />
<br />
******************************************************<br />
<br />
Latest Revision: July, 2018<br />
<br />
% Contact: Alina Zare<br />
% University of Florida, Department of Electrical and Computer Engineering<br />
% Email Address: azare@ece.ufl.edu<br />
<br />
% MIT License<br />
% <br />
% Copyright (c) [2018]<br />
% <br />
% Permission is hereby granted, free of charge, to any person obtaining a copy<br />
% of this software and associated documentation files (the "Software"), to deal<br />
% in the Software without restriction, including without limitation the rights<br />
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell<br />
% copies of the Software, and to permit persons to whom the Software is<br />
% furnished to do so, subject to the following conditions:<br />
% <br />
% The above copyright notice and this permission notice shall be included in all<br />
% copies or substantial portions of the Software.<br />
% <br />
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR<br />
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,<br />
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE<br />
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER<br />
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,<br />
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE<br />
% SOFTWARE.<br />








