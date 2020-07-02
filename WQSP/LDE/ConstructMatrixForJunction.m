function [A_J, B_J]= ConstructMatrixForJunction(CurrentFlow,MassMatrix,ElementCount,IndexInVar,q_B)
% CurrentFlow = Flow(1,:);
% CurrentFlow = CurrentFlow';
JunctionCount = ElementCount.JunctionCount;
NumberofX = IndexInVar.NumberofX;
JunctionIndexInOrder = IndexInVar.JunctionIndexInOrder;
%sumFlow = MassMatrix * CurrentFlow;
massFlow = [];
[m,n] = size(MassMatrix);
for i = 1:m
    Temp = MassMatrix(i,:) .* CurrentFlow';
    indexofoutFlow = find(Temp<0);
    [~,n1] = size(indexofoutFlow);
    for j = 1:n1
        Temp(1,indexofoutFlow(j)) = 0;
    end
    massFlow = [massFlow; Temp];
end
% this outFlow already include demand
outFlow = sum(massFlow,2);
contributionC = zeros(m,n); 
for i = 1:m
    if (outFlow(i)~=0)
        contributionC(i,:) = massFlow(i,:)/outFlow(i,1);
    end
end

A_J = zeros(JunctionCount,NumberofX);

[m,~] = size(contributionC);
for i = 1:m % for each junction
    % find contribution of link
    [~,Col] = find(contributionC(i,:)~=0);
    [~,n] = size(Col);
    for j=1:n
        lastSegmentIndex = findIndexofLastSegment(Col(j),IndexInVar);
        A_J(i,lastSegmentIndex) = contributionC(i,Col(j));
    end
end


[NodeCount,~] = size(q_B);
B_J = zeros(JunctionCount,NodeCount);

for i = 1:JunctionCount % for each junction
    B_J(i,JunctionIndexInOrder(i)) = q_B(JunctionIndexInOrder(i),1)/outFlow(i,1);
end

end