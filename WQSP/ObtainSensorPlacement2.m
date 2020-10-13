function sensorSelectionResult = ObtainSensorPlacement2(CurrentValue,aux,ElementCount,PreviousValue,numberofNodes,numberofX,numberofStep5mins,sensorNumberArray)
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

% The 2 is installing 0 and all sensors
sensorNumber = size(sensorNumberArray) + 2;

achieved = ones(nPossibleSensor+1,1);

zeroSensor = zeros(nPossibleSensor,1);
S0 = ones(nPossibleSensor,1);

sensorSolution = [];
sensorSolution = [sensorSolution; zeroSensor'];
lastUsesfulS = zeroSensor';

maxSensorNumber = max(sensorNumberArray);
for r = 1:maxSensorNumber
    r
    S = zeros(1,nPossibleSensor);
    S = EnhancedSearch4BestSensorLocation2(nPossibleSensor,O,r,sigma,lastUsesfulS,x_inital4Hq);
    sensorSolution = [sensorSolution; S];
    % install r sensors
    achieved(r+1) = Objective_logdetSpeedUp(O,S,sigma,x_inital4Hq);
end

% since we have observed the submodularity matching theory very well, we
% can change the obove code into following to speed up the overall process
% The idea is bacially save result for the previous step, and make it for
% the next step

% maxSensorNumber = max(sensorNumberArray);
% for r = 1:maxSensorNumber
%     r
%     S = lastUsesfulS;
%     S = EnhancedSearch4BestSensorLocation2(nPossibleSensor,O,r,sigma,lastUsesfulS,x_inital4Hq);
%     lastUsesfulS = S;
%     sensorSolution = [sensorSolution; S];
%     % install r sensors
%     achieved(r+1) = Objective_logdetSpeedUp(O,S,sigma,x_inital4Hq);
% end


% install 0 sensor
achieved(1) = Objective_logdetSpeedUp(O,zeroSensor,sigma,x_inital4Hq);
% install nPossibleSensor sensors
achieved(maxSensorNumber + 2) = Objective_logdetSpeedUp(O,S0,sigma,x_inital4Hq);

sensorSolution = [sensorSolution; S0'];

numberofSensorsArray = [0 1:maxSensorNumber nPossibleSensor];

sensorSelectionResult = struct('sensorSolution',sensorSolution,...
    'achieved',achieved,...
    'numberofSensors',numberofSensorsArray);

