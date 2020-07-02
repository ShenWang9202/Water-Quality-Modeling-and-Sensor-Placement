function S = EnhancedSearch4BestSensorLocation1(n,O,r,sigma,previousS)
S = previousS;
l=sum(S);
while  Objective_logdetSpeedUp(O,S,sigma) > r
    difference = (-1)*ones(1,n);
    MAX_INDEX = 0;
    S_i = zeros(1,n);
    for i = 1:n
        if S(i) == 0
           S_i = S; 
           S_i(i) = 1;
           difference(i) = Objective_logdetSpeedUp(O,S,sigma) - Objective_logdetSpeedUp(O,S_i,sigma);       
        end
    end
    [MAX,MAX_INDEX] = max(difference);
    if MAX ~= -1
        S(MAX_INDEX(1)) = 1;
    end
end