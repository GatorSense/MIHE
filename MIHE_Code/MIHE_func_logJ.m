function [obj_value,obj_pos,obj_neg,obj_discrim]=MIHE_func_logJ(Data,D,A,A_neg,labels,parameters)

% This function computes the objective functional value

% SYNTAX : [obj_value,obj_pos,obj_neg,obj_discrim]=MIHE_func_logJ(Data,D,A,A_neg,labels,parameters)

% Inputs:
%   Data - input data in dxN matrix, where d is the dimension and N is the total number of data
%   D - estimated concept set, d by T+M, d is the dimension of the input data, T and M account for the number of target and background concepts, respectively
%   A - Data representation using the the entire concept set D
%   A_neg - Data representation using the nagative concept set, which is the last M atoms in D
%   labels - binary labels for the input data. 1 for instances from positive bags and 0 for nagative
%   parameters - struct - parameter structure which can be set using the MI_HE() function
%
% Outputs:
%   obj_value  - total objective function value
%   obj_pos  - objective function value for the generalized mean part
%   obj_neg - objective function value for the fidelity part
%   obj_discrim - objective function value for the discriminative part

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

Prob=MIHE_Prob_update(Data,labels, D, A, A_neg,parameters);% compute the proablity of each instance from positive bags to be positive or negative bags to be negative 

index_neg=(labels<0);
labels_pos=labels(~index_neg);
Prob_pos=Prob(:,~index_neg);

D_pos=D(:,1:parameters.T);
A_minus_tar=A(1:parameters.T,index_neg);
Data_neg=Data(:,index_neg);

D_neg=D(:,(parameters.T+1):end);
r_minus=(Data-D_neg*A_neg);% compute the reconstruction residual
r_minus_sqr_norm=sum(r_minus.^2);
r_minus_sqr_norm_neg=r_minus_sqr_norm(index_neg);

temp_log_lkl_neg=sum(r_minus_sqr_norm_neg);%%neg log version
numb_posi_bag=max(labels_pos);
temp_log_lkl_plus=zeros(1,numb_posi_bag);

for j=1:numb_posi_bag
    temp_posi_bag_index=(labels_pos==j);
    temp_prob_plus=Prob_pos(temp_posi_bag_index);
    temp_n_plus=length(temp_prob_plus);
    temp_log_lkl_plus(j)=log(((1/temp_n_plus)*sum((temp_prob_plus.^parameters.b)))^(1/parameters.b));%%with 1/N that following generalized mean
end

obj_pos=-1*sum(temp_log_lkl_plus);%%neg log version
obj_neg=parameters.rho*temp_log_lkl_neg;% objective fidelity part 
obj_discrim=0.5*parameters.alpha*sum(sum((D_pos*A_minus_tar).*Data_neg,1).^2);% objective discriminative part
obj_value= obj_pos+ obj_neg+obj_discrim;

end


