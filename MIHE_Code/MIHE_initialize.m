function [Data, labels, D_init]=MIHE_initialize(pos_bags,neg_bags,parameters)

% This function initializes MI-HE concepts using VCA or kmeans

% SYNTAX : [Data, labels, D_init]=MIHE_initialize(pos_bags,neg_bags,parameters)

% Inputs:
%   pos_bags - positive data, in Maltab cell format, each cell is a positive bag
%   neg_bags - negative data, in Matlab cell format, each cell is a negative bag
%   parameters - struct - parameter structure which can be set using the MI_HE() function
%
% Outputs:
%   Data - input data in dxN matrix, where d is the dimension and N is the total number of data
%   labels - binary labels for the input data. 1 for instances from positive bags and 0 for nagative
%   D_init - initialization for D

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

[Data, labels]= MIL_format_bag2inst( pos_bags, neg_bags );% transform bag data into matrix
Data_plus=Data(:,labels>0);% extract positive bags data
Data_minus=Data(:,labels<0);% extract negative data
N_plus=size(Data_plus,2);% number of positive instances


%D initialization
D_pos=[];
if strcmp(parameters.initial_mthd, 'vca')
    [D_neg] = VCA(Data_minus,'Endmembers',parameters.M);%initialization negative concept using VCA
else
    [~,C]=kmeans(Data_minus',parameters.M);%initialization negative concept using kmeans
    D_neg=C';
end



n=floor(N_plus/parameters.T);
sq_target=randperm(N_plus);

%%%use random mean of Data_plus;
for i=1:parameters.T
    D_pos(:,i)=mean(Data_plus(:,sq_target(((i-1)*n+1):i*n)),2);%initialization positive concept
end


D_init=[D_pos, D_neg];

if strcmp(parameters.coding_method, 'sparse')
    D_init=normalize(D_init,2);
end

end
