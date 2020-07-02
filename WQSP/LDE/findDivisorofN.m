function D = findDivisorofN(N)
K=1:N;
D = K(rem(N,K)==0);
end