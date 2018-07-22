function  [features, labels]= MIL_format_bag2inst( pos_bag, neg_bag )

% This function transforms MIL data from cells to matrix

% SYNTAX : [features, labels]= MIL_format_bag2inst( pos_bag, neg_bag )

%input: pos_bag, positive bags in cell form, bag separated by cell
%       neg_bag, negative bags in cell form, bag separated by cell       

%output: features ,dxN, MIL dataset in matrix form 
%        labels, bag level labels, 1xN, +n for positive -n for negative, with bag number n


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

num_Pbag=length(pos_bag);
num_Nbag=length(neg_bag);
pos_inst=cell2mat(pos_bag);
neg_inst=cell2mat(neg_bag);

features=[pos_inst neg_inst];

labels=[];

for i=1:num_Pbag
    labels=[labels i*ones(1, size(pos_bag{i},2))];
end

for i=1:num_Nbag
    labels=[labels -i*ones(1, size(neg_bag{i},2))];
end
end