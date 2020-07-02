function obj = Objective_logdetSpeedUp(O,S,sigma,x_inital)
% We don't use k here. It is becuase k has been considered during
% generating O(:,:,i)

len = size(O{1},1);
O_S = sparse(len,len);
% Construct the O_S
for i = 1:length(S)
    if S(i) == 1
        O_S = O_S + O{i};
    end
end
covX = cov(x_inital)\1;

A = O_S + sigma* sigma * covX * speye(len,len);

% ispositivDef = all(eig(A) > 0)
% logDetValue1 = logdetA(A); %since it is always Positive Definite, we can
% use Chol decomposition instead of LU decomposition

logDetValue = logdetA(A,'chol');
% logDetValue1 - logDetValue

obj = 2*len*log(sigma)-logDetValue;
