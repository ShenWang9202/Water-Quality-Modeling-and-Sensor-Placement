function achieved = ErrorAchievedSensorPlacement_Random(SCell,CurrentValue,aux,ElementCount,PreviousValue,numberofNodes,numberofX,numberofStep5mins,sensorNumberArray)
% sensorNumberArray is a array, for example [ 1 4 7], that is, the number of sensors r = 1, 4 , or 7
% the min value is 1, and the largest value should < number of nodes
% hence, for a network with 11 nodes, the sensorNumberArray could be any
% subset in {1:10}

PreviousNumberofSegment4Pipes = PreviousValue.PreviousNumberofSegment4Pipes;
x_inital4Hq = PreviousValue.X_estimated;
NumberofSegment4Pipes = aux.NumberofSegment4Pipes;
SystemDynamicMatrix = CurrentValue.SystemDynamicMatrix;
Np = CurrentValue.Np;
A = SystemDynamicMatrix.A;
C = SystemDynamicMatrix.C;
lenA = length(A);
[lenX,~] = size(x_inital4Hq);

if(lenA ~= lenX)
    IndexInVarOld = PreviousValue.IndexInVarOld;
    x_inital4Hq = scalePipeSegment(x_inital4Hq,IndexInVarOld,PreviousNumberofSegment4Pipes,ElementCount,NumberofSegment4Pipes);
end


sigma = 0.1;
nX = numberofX;
k = numberofStep5mins;
nPossibleSensor = numberofNodes;

% Generate all O for each sensor, and in CO2 case, there are n = 81 sensor
% position
% When we need the O for sensor i and j, we simple add O_i + O_j together (This is a strong conclusion, is this from Equation 19?).
% O = zeros(nX,nX,nPossibleSensor);
O = cell(1,nPossibleSensor);
 
parfor i=1:nPossibleSensor
    I_i= sparse(nPossibleSensor,nX);
    I_i(i,i) = 1;
    sumTemp = sparse(nX,nX);
    temp1 = I_i;
    Temp = I_i' * I_i;
    for j=1:k
        % from [0,k]
        sumTemp = sumTemp + Temp;
        temp1 = temp1*A;
        Temp = temp1'*temp1;
    end
    O{i} = sumTemp;
end

% % The 2 is installing 0 and all sensors
% sensorNumber = size(sensorNumberArray) + 2;

zeroSensor = zeros(nPossibleSensor,1);
S0 = ones(nPossibleSensor,1);

% sensorSolution = [];
% sensorSolution = [sensorSolution; zeroSensor'];
% lastUsesfulS = zeroSensor';

% maxSensorNumber = max(sensorNumberArray);
% achieved = ones(nPossibleSensor+1,1);

num = length(sensorNumberArray);
[~,numofGroups] = size(SCell);
achieved = cell(num + 2,numofGroups);
tempAchieved = cell(num);




for i = 1:numofGroups
    parfor j = 1:num
        S = SCell{j,i};
        % install r = sum(S) sensors
        achieved{j+1,i} = Objective_logdetSpeedUp(O,S,sigma,x_inital4Hq);
    end
    % install 0 sensor
    achieved{1,i} = Objective_logdetSpeedUp(O,zeroSensor,sigma,x_inital4Hq);
    % install nPossibleSensor sensors
    achieved{num + 2,i} = Objective_logdetSpeedUp(O,S0,sigma,x_inital4Hq);
end

% for j = 1:num
%     for i = 1:numofGroups
%         S = SCell{j,i};
%         % install r = sum(S) sensors
%         achieved{j+1,i} = Objective_logdetSpeedUp(O,S,sigma,x_inital4Hq);
%         % install 0 sensor
%         achieved{1,i} = Objective_logdetSpeedUp(O,zeroSensor,sigma,x_inital4Hq);
%         % install nPossibleSensor sensors
%         achieved{num + 2,i} = Objective_logdetSpeedUp(O,S0,sigma,x_inital4Hq);
%     end
% end



