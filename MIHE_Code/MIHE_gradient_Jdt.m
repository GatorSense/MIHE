function delta_Jdt=MIHE_gradient_Jdt(Data,D,A,A_neg,labels,parameters,t)

% This function computes the gradient of the tth target concept

% SYNTAX : delta_Jdt=MIHE_gradient_Jdt(Data,D,A,A_neg,labels,parameters,t)

% Inputs:
%   Data - input data in dxN matrix, where d is the dimension and N is the total number of data
%   D - estimated concept set, d by T+M, d is the dimension of the input data, T and M account for the number of target and background concepts, respectively
%   A - Data representation using the the entire concept set D
%   A_neg - Data representation using the nagative concept set, which is the last M atoms in D
%   labels - binary labels for the input data. 1 for instances from positive bags and 0 for nagative
%   parameters - struct - parameter structure which can be set using the MI_HE() function
%   t  -  the index of the target concept
%
% Outputs:
%   delta_Jdt - the gradient of the tth target concept

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

d_dim=size(Data,1);
% compute probability of each instance from positive bags to be positive or negative bags to be negative 
Prob=MIHE_Prob_update(Data,labels, D, A, A_neg,parameters);

index_neg=(labels<0);
labels_pos=labels(~index_neg);

numb_posi_bag=max(labels_pos);
pos_bag_gradient=zeros(d_dim,numb_posi_bag);
at=A(t,:);

D_pos=D(:,1:parameters.T);
A_minus_tar=A(1:parameters.T,index_neg);
Data_neg=Data(:,index_neg);
at_minus=at(index_neg);

D_neg=D(:,(parameters.T+1):end);
% compute reconstruction residual
r_plus=(Data-D*A);
r_minus=(Data-D_neg*A_neg);
r_minus_sqr_norm=sum(r_minus.^2);

% compute the gradient components from each positive bag 
for j=1:numb_posi_bag
    temp_posi_bag_index=(labels==j);
    temp_prob_plus=Prob(temp_posi_bag_index);
    temp_at=at(temp_posi_bag_index);
    temp_r_plus=r_plus(:,temp_posi_bag_index);
    temp_r_minus_sqr_norm=r_minus_sqr_norm(temp_posi_bag_index);
    pos_bag_gradient(:,j)=(1/(sum(temp_prob_plus.^parameters.b)))*(sum(repmat((2*parameters.beta*(temp_prob_plus.^(parameters.b)).*temp_at)./temp_r_minus_sqr_norm,d_dim,1).*(temp_r_plus),2));
end


% sum gradient components from positive bags together
gradient_Jdt_pos=-1*(sum(pos_bag_gradient,2));

% compute the gradient from the discriminative part
gradient_Jdt_discrim=parameters.alpha*sum(repmat(sum((D_pos*A_minus_tar).*Data_neg,1).*at_minus,d_dim,1).*Data_neg,2);

delta_Jdt=gradient_Jdt_pos+gradient_Jdt_discrim;

end

