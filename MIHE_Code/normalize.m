function [X]=normalize(inputdata,flag)

% This function performs normalization of input data

% Inputs:
%   Inputdata - Inputdata, reshaped hyperspectral image treats each pixel as column vector, d by N
%   flag - method to normalize data, 1, normalize data globally between 0
%   and 1; 2, normalize data individually to norm 1;3, normalize data
%   globally with in unit ball; 4 normalize data by the mean data energy

%
% Outputs:
%   X - normalized data

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

D=double(inputdata);
d=size(D,1);

if d==1
    X=D;
    return
elseif flag==0
    X=D;
elseif flag==1
    M=max(D);
    m=min(D);
    index_1=(M==m)&(M==0);
    index_2=(M==m)&(M~=0);
    locs_2=find(index_2);
    index_3=~(index_1|index_2);
    X(:,index_1)=D(:,index_1);
    for i=1:length(locs_2)
        X(:,locs_2(i))=D(:,locs_2(i))/M(locs_2(i));
    end
    X(:,index_3)=(D(:,index_3)-repmat(m(index_3),d,1))./repmat((M(index_3)-m(index_3)),d,1);
elseif flag==2
    L=sqrt(sum(D.^2,1));
    index=(L~=0);
    X=D;
    X(:,index)=D(:,index)./repmat(L(index),d,1);
elseif flag==3
    X=D/max(sqrt(sum(D.^2,1)));
    
elseif flag==4
    X=D/mean(sqrt(sum(D.^2,1)));
else
    X=D/flag;
end

end


