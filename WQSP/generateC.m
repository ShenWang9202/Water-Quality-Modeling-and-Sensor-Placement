function C = generateC(nx,nodeCount)
% Selection all elements except tanks and reserviors
% select all first to give it a try
C = sparse(nodeCount,nx);
for i = 1:nodeCount
    C(i,i) = 1;
end
end