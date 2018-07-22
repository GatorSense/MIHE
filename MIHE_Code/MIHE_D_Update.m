function [D,A,A_neg] = MIHE_D_Update(Data,D_current,labels,parameters)

% This function executes the D update equation

% SYNTAX : [D,A,A_neg] = MIHE_D_Update(Data,D_current,labels,parameters)

% Inputs:
%   Data - input data in dxN matrix, where d is the dimension and N is the total number of data
%   labels - binary labels for the input data. 1 for instances from positive bags and 0 for nagative
%   D_current - concept set estimated from last iteration
%   parameters - struct - parameter structure which can be set using the MI_HE() function
%
% Outputs:
%   D - estimated concept set, d by T+M, d is the dimension of the input data, T and M account for the number of target and background concepts, respectively
%   A - Data representation using the the entire concept set D
%   A_neg - Data representation using the nagative concept set, which is the last M atoms in D

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

step_length=parameters.step_length;
rho=0.3;% coefficient for Armijo's Rule

for t=1:parameters.T
    D_neg=D_current(:,(parameters.T+1):end);% negative concept
    if strcmp(parameters.coding_method, 'sparse')% using sparse coding
        A=SP_coding(Data,D_current,parameters.lambda);
        A_neg=SP_coding(Data,D_neg,parameters.lambda);
    elseif strcmp(parameters.coding_method, 'convex')% using hyperspectral unmixing
        A=HS_unmixing(Data,D_current,1);
        A_neg=HS_unmixing(Data,D_neg,1);
    end

    d_t=D_current(:,t);% current concept atom to be udated
    J_func_value_old=MIHE_func_logJ(Data,D_current,A,A_neg,labels,parameters);% current objective functional value
    delta_Jdt=MIHE_gradient_Jdt(Data,D_current,A,A_neg,labels,parameters,t);% gradient for current d_t
    if all(delta_Jdt==0)% check if gradient is all zero
        break
    else
        delta_Jdt=normalize(delta_Jdt,2);
    end
    %%%%%%%%%%%%%%%%%%% solve optimal length lambda
    lambda_old=0;
    lambda_temp=step_length;
    D_current_temp=D_current;
    D_current_temp(:,t)=d_t-lambda_temp*delta_Jdt;% more d_t to the gradient's negative direction at lambda_temp length
    J_func_value_new=MIHE_func_logJ(Data,D_current_temp,A,A_neg,labels,parameters);% compute the new objective value
    step_count=1;
    while (J_func_value_new<=J_func_value_old-lambda_temp*rho*norm(delta_Jdt)^2)% Armijo's first rule
        armijo_2nd=(J_func_value_new>=(J_func_value_old-lambda_temp*(1-rho)*norm(delta_Jdt)^2));% Armijo's second rule
        if armijo_2nd||(step_count>=20)            
            break
        end
        lambda_old=lambda_temp;
        lambda_temp=lambda_temp+step_length;
        D_current_temp(:,t)=d_t-lambda_temp*delta_Jdt;
        J_func_value_new=MIHE_func_logJ(Data,D_current_temp,A,A_neg,labels,parameters);
        step_count=step_count+1;
    end
    lambda_optimal=lambda_old;
    
    %%%%%%%%%%%%%%%%%%% update kth atom in D
    dt_new=d_t-lambda_optimal*delta_Jdt;
    if strcmp(parameters.coding_method, 'sparse')
        dt_new=normalize(dt_new,2);
    end
    D_current(:,t)=dt_new;
end


%%update background dictionary

T=parameters.T;

for k=1:parameters.M
    D_neg=D_current(:,(parameters.T+1):end);
    if strcmp(parameters.coding_method, 'sparse')
        A=SP_coding(Data,D_current,parameters.lambda);
        A_neg=SP_coding(Data,D_neg,parameters.lambda);
    elseif strcmp(parameters.coding_method, 'convex')
        A=HS_unmixing(Data,D_current,1);
        A_neg=HS_unmixing(Data,D_neg,1);
    end
    d_k=D_current(:,k+T);
    J_func_value_old=MIHE_func_logJ(Data,D_current,A,A_neg,labels,parameters);
    delta_Jdk=MIHE_gradient_Jdk(Data,D_current,A,A_neg,labels,parameters,k);
    if all(delta_Jdk==0)
        break
    else
        delta_Jdk=normalize(delta_Jdk,2);
    end
    %%%%%%%%%%%%%%%%%%% solve optimal length lambda
    lambda_old=0;
    lambda_temp=step_length;
    D_current_temp=D_current;
    D_current_temp(:,T+k)=d_k-lambda_temp*delta_Jdk;
    J_func_value_new=MIHE_func_logJ(Data,D_current_temp,A,A_neg,labels,parameters);
    step_count=1;
    while (J_func_value_new<=J_func_value_old-lambda_temp*rho*norm(delta_Jdt)^2)
        armijo_2nd=(J_func_value_new>=(J_func_value_old-lambda_temp*(1-rho)*norm(delta_Jdt)^2));
        if armijo_2nd||(step_count>=20)            
            break
        end
        lambda_old=lambda_temp;
        lambda_temp=lambda_temp+step_length;
        D_current_temp(:,k+T)=d_k-lambda_temp*delta_Jdk;
        J_func_value_new=MIHE_func_logJ(Data,D_current_temp,A,A_neg,labels,parameters);
        step_count=step_count+1;
    end
    lambda_optimal=lambda_old;
    
    %%%%%%%%%%%%%%%%%%% update kth atom in D
    dk_new=d_k-lambda_optimal*delta_Jdk;
    if strcmp(parameters.coding_method, 'sparse')
        dk_new=normalize(dk_new,2);
    end
    D_current(:,k+T)=dk_new;
end

D=D_current;
D_neg=D_current(:,(parameters.T+1):end);
if strcmp(parameters.coding_method, 'sparse')
    A=SP_coding(Data,D_current,parameters.lambda);
    A_neg=SP_coding(Data,D_neg,parameters.lambda);
elseif strcmp(parameters.coding_method, 'convex')
    A=HS_unmixing(Data,D_current,1);
    A_neg=HS_unmixing(Data,D_neg,1);
end


end

