function zeroRate(A)
% this function return the zerosRate of A matrix
noneZeroCount = nnz(A);
[m,n] = size(A);

% note that zeroRate is in percent
zeroRatePercent = (1 - noneZeroCount/m/n)*100

end