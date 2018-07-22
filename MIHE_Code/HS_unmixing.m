function [P]=HS_unmixing(Inputdata,E,flag)

% given concepts and solve representations with or without sum to one constraint
%
%
% Inputs:
%   InputData: double,Nxd or NxMxd matrix, dimensionality d for each feature vector
%   E: given endmembers
%   flag: 0 without sum to one constraint, 1 with sum to one constraint
%
% Outputs:
%   P: proportion values
%   
%   
%
%
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

%%

X=double(Inputdata);
flag_Data=0;

if length(size(X))==3
    flag_Data=1;
    X=EF_reshape(X);
end


P=P_Update_KE(X,E,flag);


if flag_Data==1
    EF_viewresults(Inputdata,P);
end

end
%%

function [P]=P_Update_KE(X,E,flag)

M=size(E,2);
N=size(X,2);

if M>1
    U=(E'*E);
    V=E'*X;
    if flag==0
        P=(E'*E)\V;
    elseif flag==1
        P=U\(V+ones(M,1)*((1-ones(1,M)*(U\V))/(ones(1,M)*(U\ones(M,1)))));
    end
    Z=P<0;
    while (sum(sum(Z))>0)
        ZZ = unique(Z', 'rows', 'first')';
        for i=1:size(ZZ,2)
            if(sum(ZZ(:,i)))>0
                eLocs=find(1-ZZ(:,i));
                rZZi=repmat(ZZ(:,i),1,N);
                inds=all(Z==rZZi, 1);
                P_temp=P_Update_KE(X(:,inds),E(:,eLocs),flag);
                P_temp2=zeros(size(ZZ,1),sum(inds));
                P_temp2(eLocs,:)=P_temp;
                P(:,inds)=P_temp2;
            end
        end
    Z=P<0;
    end
else

    P=ones(M,N);

end

end



            

