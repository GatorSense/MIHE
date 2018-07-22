function  [pos_bag, neg_bag]= MIL_format_inst2bag_no_GT( Data, labels)

% This function transforms MIL data from  matrix to cells

% SYNTAX : [pos_bag, neg_bag]= MIL_format_inst2bag_no_GT( Data, labels)

%input:  Data ,dxN, MIL dataset in matrix form 
%        labels, bag_level_labels, 1xN, +n for positive -n for negative with bag index n

%output: pos_bag, positive bags in cell form, bag separated by cell
%        neg_bag, negative bags in cell form, bag separated by cell     


% Contact: Changzhe Jiao
% cjr25@mail.missouri.edu

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

pos_bag_num=max(labels);
neg_bag_num=-1*min(labels);
pos_bag=cell(1,pos_bag_num);
neg_bag=cell(1,neg_bag_num);

for i=1:pos_bag_num
    temp_idx=(labels==i);
    temp_data=Data(:,temp_idx);
    pos_bag{i}=temp_data;
end

for i=1:neg_bag_num
    temp_idx=(labels==-1*i);
    temp_data=Data(:,temp_idx);
    neg_bag{i}=temp_data;
end