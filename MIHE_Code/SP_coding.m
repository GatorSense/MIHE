function [A_soft_th,rec_error]=SP_coding(X,D,lambda)

% This function implements the iterative soft thresholding algorithm (ISTA)
% reference:  
% I. Daubechies, M. Defrise, C. De Mol, An iterative thresholding algorithm for linear inverse problems with a sparsity constraint, 
%Commun. Pure Applied Math. 57 (2004) 1413¨C1457


% Inputs:
%   X - Inputdata, reshaped hyperspectral image treats each pixel as column vector, d by N
%   D - Dictionary matrix d by M;
%   lambda - l1 regulizer coefficient


% Outputs:

%   A_soft_th - sparse representation value
%   rec_error - reconstruct error bewteen X, D*A_soft_th

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

ita=(1/norm(D'*D))*0.99;% learning rate, norm(D'*D)=norm(D)^2=lambda_max(D'*D)
A_old=(D'*D)\(D'*X);%initial value

for i=1:100
    A=A_old+ita*(D'*(X-D*A_old));%gradient descent
    A_soft_th=sign(A).*max((abs(A)-lambda),0);% soft thresholding
    A_old=A_soft_th;
end

rec_error=sqrt(sum((X-D*A_soft_th).^2));

    
    

