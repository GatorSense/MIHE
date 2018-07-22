function [D,obj_func,obj_pos,obj_neg,obj_discrim]=MIHE_iterations(Data,D_initial,labels,parameters)

% This function interatively computes the concepts D and the data representation A

% SYNTAX : [D,obj_func,obj_pos,obj_neg,obj_discrim]=MIHE_iterations(Data,D_initial,labels,parameters)

% Inputs:
%   Data - input data in dxN matrix, where d is the dimension and N is the total number of data
%   labels - binary labels for the input data. 1 for instances from positive bags and 0 for nagative
%   parameters - struct - parameter structure which can be set using the MI_HE() function
%
% Outputs:
%   D - estimated concept set, d by T+M, d is the dimension of the input data, T and M account for the number of target and background concepts, respectively
%   obj_func  - total objective function value
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

obj_func=inf;
D=D_initial;

for iter=1:parameters.iterationCap
    
    
%D-update
    D_current=D;
    [D,A,A_neg]=MIHE_D_Update(Data,D_current,labels,parameters);% D update equation
    
%Condition Update        
    obj_func_old=obj_func;
    [obj_func,obj_pos,obj_neg,obj_discrim]=MIHE_func_logJ(Data,D,A,A_neg,labels,parameters);% compute objective functional value
    Cond=abs(obj_func_old-obj_func);

    fprintf(['Iteration ' num2str(iter) '\n']);
    fprintf(['Obj_Func=' num2str(obj_func) ', Obj_pos=' num2str(obj_pos) ', Obj_neg=' num2str(obj_neg) ', Obj_discrim=' num2str(obj_discrim) '\n']);
    fprintf(['Cond=' num2str(Cond) '\n']);
    
    if (Cond)<parameters.changeThresh %if the change in objective function is smaller than set threshold
        break;
    end
    

end