load('ThreeNodeSystemMatrix')
[m,Timestep] = size(Amatrix);
noneFullRank = [];
largestEig = [];
for tt = 1:Timestep
    A = full(Amatrix{tt});
    A(find(A == 1)) = 0.999;
    largestEig = [largestEig max(eig(A))];
    [row, column] = size(A);
    rankA = rank(A);
    if(rankA < row || rankA < column)
        noneFullRank = [noneFullRank rankA];
    end
end


A = [0.4 0.9 0.8 0.9 1.1;
0.2 0.1 -0.4 0.4 -0.5;
-0.1 2.1 0.7 1.7 1.3;
-0.9 -0.8 -0.8 -1.3 -1;
0.4 -1.7 0.2 -1.3 -0.3;]
