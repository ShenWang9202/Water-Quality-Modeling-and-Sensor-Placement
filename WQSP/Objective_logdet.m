function obj = Objective_logdet(O,S,sigma)
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

eigval = zeros(len,1);
log_eigval = zeros(len,1);
% log eigval
eigval = eig(O_S + eye(len,len));
for i=1:len
    log_eigval(i)=log(eigval(i));
end
% This is Equation 15. The log determinant is implemented by sum(log_eigval). But this only can be done when O_S is diagonal. Why O_S ( O(:,:,i) ) is always diagonal?
obj = 2*len*log(sigma)-sum(log_eigval);
