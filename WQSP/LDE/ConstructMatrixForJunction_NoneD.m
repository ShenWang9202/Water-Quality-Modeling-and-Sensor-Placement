function [A_J, B_J]= ConstructMatrixForJunction_NoneD(CurrentFlow,MassEnergyMatrix,flipped,ElementCount,IndexInVar,q_B,aux)
% CurrentFlow = Flow(1,:);
% CurrentFlow = CurrentFlow';
JunctionCount = ElementCount.JunctionCount;
NumberofX = IndexInVar.NumberofX;
JunctionIndexInOrder = IndexInVar.JunctionIndexInOrder;
inFlowSelectionMatrix = MassEnergyMatrix(:,JunctionIndexInOrder);
NumberofSegment4Pipes = aux.NumberofSegment4Pipes;

% Next we find the outFlow of each jucntion. Sine the outflow of a junction is actual outflow in pipes + its demand, which is the inflows flow links
% So all we need to do is just to find the inflow index
% To find the inflow index, just replace all -1 with 0

% [m,n] = size(inFlowSelectionMatrix);
% for i = 1:n
%     inflow_index = find(inFlowSelectionMatrix(:,i)<0);
%     inFlowSelectionMatrix(inflow_index,i) = 0;
% end

inFlowSelectionMatrix(inFlowSelectionMatrix<0) = 0;
% this outFlow already include demand

inFlowMatrix = inFlowSelectionMatrix .* CurrentFlow;
outFlowofEachJuction = sum(inFlowMatrix);
outFlow = outFlowofEachJuction;
inFlow = inFlowMatrix';
%% find contribution from pipes
[m,n] = size(inFlow);
contributionC = zeros(m,n);
for i = 1:m
    if (outFlow(i)~=0)
        contributionC(i,:) = inFlow(i,:)/outFlow(i);
    end
end
%% find the downstram node of pump and valves

PumpIndex = IndexInVar.PumpIndex;
ValveIndex = IndexInVar.ValveIndex;
PumpValveIndex =  [PumpIndex ValveIndex];
PumpValveEnergMatrix = MassEnergyMatrix(PumpValveIndex,:);
[row,~] = size(PumpValveEnergMatrix);
DownStreamNodesIndex_PumpValves = [];
% for links, -1 is its index of upstream nodes, 1 is its index of downstream nodes
for i = 1:row
    tempindex = find(PumpValveEnergMatrix(i,:)>0);
    DownStreamNodesIndex_PumpValves = [DownStreamNodesIndex_PumpValves tempindex];
end

A_J = sparse(JunctionCount,NumberofX);

[m,~] = size(contributionC);
for i = 1:m % for each junction
    if(~ismember(i,DownStreamNodesIndex_PumpValves)) % if this junction is not the downstream nodes of pumps and valves
        % find contribution of link
        [~,Col] = find(contributionC(i,:)~=0);
        [~,n] = size(Col);
        for j=1:n
            [lastSegmentIndex,isPipe] = findIndexofLastorFirstSegment(Col(j),IndexInVar,flipped(Col(j)),NumberofSegment4Pipes);
%             lastSegmentIndex = findIndexofLastSegment(Col(j),IndexInVar);
            % When calculate the concentration at junction, we make it
            % equal the average of first four segment or last four segment,
            % instead of the first or last segment.
            
            %             A_J(i,lastSegmentIndex) = contributionC(i,Col(j));
            %             % consider the average of two.
            %             A_J(i,lastSegmentIndex) = contributionC(i,Col(j))/2;
            %             if(flipped(Col(j)))
            %                A_J(i,lastSegmentIndex+1) = contributionC(i,Col(j))/2;
            %             else
            %                A_J(i,lastSegmentIndex-1) = contributionC(i,Col(j))/2;
            %             end
            % consider the average of two, three or four. to make LW smooth
%              A_J(i,lastSegmentIndex) = contributionC(i,Col(j));
            % When calculate the concentration at junction, we make it
            % equal the average of first four segment or last four segment,
            % instead of the first or last segment.
            if(isPipe)
                A_J(i,lastSegmentIndex+0) = contributionC(i,Col(j))/4;
                if(flipped(Col(j)))
                    A_J(i,lastSegmentIndex+1) = contributionC(i,Col(j))/4;
                    A_J(i,lastSegmentIndex+2) = contributionC(i,Col(j))/4;
                    A_J(i,lastSegmentIndex+3) = contributionC(i,Col(j))/4;
                else
                    A_J(i,lastSegmentIndex-1) = contributionC(i,Col(j))/4;
                    A_J(i,lastSegmentIndex-2) = contributionC(i,Col(j))/4;
                    A_J(i,lastSegmentIndex-3) = contributionC(i,Col(j))/4;
                end
            else % when it is pump or valve
                A_J(i,lastSegmentIndex) = contributionC(i,Col(j));
            end
        end
    end
end


[NodeCount,~] = size(q_B);
B_J = sparse(JunctionCount,NodeCount);

for i = 1:JunctionCount % for each junction
    if(~ismember(i,DownStreamNodesIndex_PumpValves)) % not the downstream nodes of pumps and valves
        B_J(i,JunctionIndexInOrder(i)) = q_B(JunctionIndexInOrder(i),1)/outFlow(i);
    end
end


end