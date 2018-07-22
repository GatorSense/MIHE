function delta_Jdk=MIHE_gradient_Jdk(Data,D,A,A_neg,labels,parameters,k)

% This function computes the gradient of the kth non-target concept

% SYNTAX : delta_Jdk=MIHE_gradient_Jdk(Data,D,A,A_neg,labels,parameters,k)

% Inputs:
%   Data - input data in dxN matrix, where d is the dimension and N is the total number of data
%   D - estimated concept set, d by T+M, d is the dimension of the input data, T and M account for the number of target and background concepts, respectively
%   A - Data representation using the the entire concept set D
%   A_neg - Data representation using the nagative concept set, which is the last M atoms in D
%   labels - binary labels for the input data. 1 for instances from positive bags and 0 for nagative
%   parameters - struct - parameter structure which can be set using the MI_HE() function
%   k  -  the index of the non-target concept
%
% Outputs:
%   delta_Jdk - the gradient of the kth non-target concept

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

Prob=MIHE_Prob_update(Data, labels,D, A, A_neg,parameters);% compute probability of each instance from positive bags to be positive or negative bags to be negative 
d_dim=size(Data,1);
T=parameters.T;
K=T+k;

index_neg=(labels<0);
labels_pos=labels(~index_neg);

numb_posi_bag=max(labels_pos);
pos_bag_gradient=zeros(d_dim,numb_posi_bag);
ak=A(K,:);
ak_minus=A_neg(k,:);

D_neg=D(:,(parameters.T+1):end);
% compute reconstruction residual
r_plus=(Data-D*A);
r_minus=(Data-D_neg*A_neg);
r_plus_sqr_norm=sum(r_plus.^2);
r_minus_sqr_norm=sum(r_minus.^2);

% compute the gradient from each positive bag 
for j=1:numb_posi_bag
    temp_posi_bag_index=(labels==j);
    temp_prob_plus=Prob(temp_posi_bag_index);
    temp_ak=ak(temp_posi_bag_index);
    temp_ak_minus=ak_minus(temp_posi_bag_index);
    temp_r_plus=r_plus(:,temp_posi_bag_index);
    temp_r_minus=r_minus(:,temp_posi_bag_index);
    temp_r_plus_sqr_norm=r_plus_sqr_norm(temp_posi_bag_index);
    temp_r_minus_sqr_norm=r_minus_sqr_norm(temp_posi_bag_index);
    pos_bag_gradient(:,j)=(1/(sum(temp_prob_plus.^parameters.b)))*(sum(repmat((2*parameters.beta*(temp_prob_plus.^(parameters.b)))./(temp_r_minus_sqr_norm.^2),d_dim,1).*(repmat(temp_ak.*temp_r_minus_sqr_norm,d_dim,1).*temp_r_plus-repmat(temp_ak_minus.*temp_r_plus_sqr_norm,d_dim,1).*temp_r_minus),2));
end

% sum gradient components from positive bags together
gradient_Jdk_pos=-1*(sum(pos_bag_gradient,2));



%%%compute gdt for negative part
r_minus_neg=r_minus(:,index_neg);
ak_minus_neg=ak_minus(index_neg);


gradient_Jdk_neg=sum(repmat(-2*ak_minus_neg,d_dim,1).*r_minus_neg,2);  

% keyboard

delta_Jdk=gradient_Jdk_pos+parameters.rho*gradient_Jdk_neg;

end

