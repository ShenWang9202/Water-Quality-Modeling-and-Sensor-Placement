function [q_B,Price_B,Index,Count] = InitialBooster(nodeCount,Location_B,flowRate_B,NodeID,Price_B1)
q_B = zeros(nodeCount,1);
%C_B = zeros(nodeCount,1);
Price_B = zeros(nodeCount,1);
[~,nB] = size(Location_B);
Index = [];
for i = 1:nB
    index = findIndexByID(Location_B{i},NodeID);
    Index = [Index index];
    q_B(index) = flowRate_B(i);
    %C_B(index) = C_B1(i);
    Price_B(index) = Price_B1(i);
end
Count = nB;
end