function S = EnhancedSearch4BestSensorLocation2(n,O,r,sigma,previousS,x_inital)
S = previousS;
l=sum(S);
while l < r
    difference = (-1)*ones(1,n);
    MAX_INDEX = 0;
    S_i = zeros(1,n);
    parfor i = 1:n
        if S(i) == 0
           S_i = S; 
           S_i(i) = 1;
           difference(i) = Objective_logdetSpeedUp(O,S,sigma,x_inital) - Objective_logdetSpeedUp(O,S_i,sigma,x_inital);       
        end
    end
    [MAX,MAX_INDEX] = max(difference);
    if MAX ~= -1
        S(MAX_INDEX(1)) = 1;
    end
    l=l+1;
end