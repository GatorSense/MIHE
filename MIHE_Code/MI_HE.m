function [ D, D_initial ,obj_func,obj_pos,obj_neg,obj_discrim] = MI_HE( pos_bags,neg_bags,parameters )


% MI-HE (Multiple Instance Hybrid Estimator): a multiple instance target concept learning algorithm

% REFERENCE :
% C. Jiao, C. Chen, R. McGarvey, S. Bohlman, A. Zare 
% Multiple Instance Hybrid Estimator for Hyperspectral Target Characterization and Sub-pixel Target Detection
% submited to ISPRS Jounal of Photogrammetry and Remote Sensing, vol. .., no. .., pp. .-., 2018
%
% SYNTAX : [ D, D_initial ,obj_func,obj_pos,obj_neg,obj_discrim] = MI_HE( pos_bags,neg_bags,parameters )

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

% Initialization
[Data, labels, D_initial]=MIHE_initialize(pos_bags,neg_bags,parameters);

%%% update D, A alternatively
 [D,obj_func,obj_pos,obj_neg,obj_discrim]=MIHE_iterations(Data,D_initial,labels,parameters);
 

end

