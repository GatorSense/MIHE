function Prob = MIHE_Prob_update(Data, labels,D, A, A_neg,parameters)
% This function computes the proablity of each instance from positive bags to be positive or negative bags to be negative 

% SYNTAX : Prob = MIHE_Prob_update(Data, labels,D, A, A_neg,parameters)

% Inputs:
%   Data - input data in dxN matrix, where d is the dimension and N is the total number of data
%   labels - binary labels for the input data. 1 for instances from positive bags and 0 for nagative
%   D - estimated concept set, d by T+M, d is the dimension of the input data, T and M account for the number of target and background concepts, respectively
%   A - Data representation using the the entire concept set D
%   A_neg - Data representation using the nagative concept set, which is the last M atoms in D
%   parameters - struct - parameter structure which can be set using the MI_HE() function
%
% Outputs:
%   Prob - proablity of each instance from positive bags to be positive or negative bags to be negative 

% REFERENCE :
% C. Jiao, C. Chen, R. McGarvey, S. Bohlman, A. Zare 
% Multiple Instance Hybrid Estimator for Hyperspectral Target Characterization and Sub-pixel Target Detection
% submited to ISPRS Jounal of Photogrammetry and Remote Sensing, vol. .., no. .., pp. .-., 2018

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

Prob=zeros(1,length(labels));
index_pos=(labels>0);
index_neg=~index_pos;


D_neg=D(:,(parameters.T+1):end);
r_plus=sum((Data-D*A).^2)+parameters.eps;% reconstructin error of data using entire concepts
r_minus=sum((Data-D_neg*A_neg).^2)+parameters.eps;%reconstructin error of data using negative concepts


ratio_plus_minus_pos=r_plus(index_pos)./r_minus(index_pos);% compute the ratio of two reconstruction errors
Prob(index_pos)=exp(-parameters.beta*ratio_plus_minus_pos);
Prob(index_neg)=exp(-1*r_minus(index_neg));%diverse density


end

