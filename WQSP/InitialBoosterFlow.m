function [q_B,C_B] = InitialBoosterFlow(nodeCount,Location_B,flowRate_B,NodeID,C_B1)
q_B = zeros(nodeCount,1);
C_B = zeros(nodeCount,1);
[~,nB] = size(Location_B);
for i = 1:nB
    index = findIndexByID(Location_B{i},NodeID);
    q_B(index) = flowRate_B(i);
    C_B(index) = C_B1(i);
end
end