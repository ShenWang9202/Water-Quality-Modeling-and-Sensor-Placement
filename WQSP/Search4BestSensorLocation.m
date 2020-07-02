function S = Search4BestSensorLocation(n,O,r,sigma)

S = zeros(1,n);
l=0;
while l<r
    difference = (-1)*ones(1,n);
    MAX_INDEX = 0;
    S_i = zeros(1,n);
    for i = 1:n
        if S(i) == 0
           S_i = S; 
           S_i(i) = 1;
           difference(i) = Objective_logdet(O,S,sigma) - Objective_logdet(O,S_i,sigma);       
        end
    end
    [MAX,MAX_INDEX] = max(difference);
    if MAX ~= -1
        S(MAX_INDEX(1)) = 1;
    end
    l=l+1;
end