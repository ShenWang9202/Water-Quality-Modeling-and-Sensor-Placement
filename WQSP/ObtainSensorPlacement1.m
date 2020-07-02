function sensorSelectionResult = ObtainSensorPlacement1(PreviousSystemDynamicMatrix,numberofNodes,numberofX,numberofStep5mins)

A = PreviousSystemDynamicMatrix.A;
sigma=1;

nX = numberofX;
k = numberofStep5mins;

sensorStep = 1;
nPossibleSensor = numberofNodes;
if(numberofNodes > 10 && numberofNodes <= 20)
    sensorStep = 2;
    nPossibleSensor = ceil(numberofNodes/3);
end
if(numberofNodes > 20 && numberofNodes <= 40)
    sensorStep = 3;
    nPossibleSensor = ceil(numberofNodes/4);
end
if(numberofNodes > 40 && numberofNodes <= 200)
    sensorStep = 5;
    nPossibleSensor = ceil(numberofNodes/5);
end

% Generate all O for each sensor, and in CO2 case, there are n = 81 sensor
% position
% When we need the O for sensor i and j, we simple add O_i + O_j together (This is a strong conclusion, is this from Equation 19?).
% O = zeros(nX,nX,nPossibleSensor);
O = cell(1,nPossibleSensor);

for i=1:nPossibleSensor
    I_i= sparse(nX,nX);
    sumTemp = sparse(nX,nX);
    % This I_i is C matrix, and it represent where the sensor is.
    I_i(i,i) = 1;
    %temp = I_i'*I_i; since I_i is diagonal, and the diagonal value is 1;
    %hence I_i'*I_i is the same I_i
%     temp = I_i;
%     for j=1:k
%         % from [0,k]
%         sumTemp = sumTemp+ temp;
%         temp = A'*temp*A;
%     end
    temp1 = I_i;
    Temp = I_i;
    for j=1:k
        % from [0,k]
        sumTemp = sumTemp + Temp;
        temp1 = temp1*A;
        Temp = temp1'*temp1;
    end
    O{i} = sumTemp;
end

S0 = ones(nPossibleSensor,1);

% % Assume all sensor are installed here to get the min error
% mine = Objective_logdetSpeedUp(O,S0,sigma);
% 
% % Assume no sensor is installed to get the max error
% maxe = Objective_logdetSpeedUp(O,zeros(nPossibleSensor,1),sigma);

% ceil(maxe-mine)
% numberofs = zeros(ceil(maxe-mine),1);

zeroSensor = zeros(nPossibleSensor,1);
sensorSolution = [];
sensorSolution = [sensorSolution; zeroSensor'];
lastUsesfulS = zeroSensor';
achieved=ones(nPossibleSensor + 1,1);

for r=1:sensorStep:nPossibleSensor-1
    r
    %S = Search4BestSensorLocation(nPossibleSensor,O,r,sigma);
    S = EnhancedSearch4BestSensorLocation1(nPossibleSensor,O,r,sigma,lastUsesfulS);
    lastUsesfulS = S;
    sensorSolution = [sensorSolution; S];
    % install r sensors
    achieved(r + 1) = Objective_logdetSpeedUp(O,S,sigma);
end

% install 0 sensor
achieved(1) = Objective_logdetSpeedUp(O,zeroSensor,sigma);
% install nPossibleSensor sensors
achieved(nPossibleSensor+1) = Objective_logdetSpeedUp(O,S0,sigma);
sensorSolution = [sensorSolution; S0'];

sensorSelectionResult = struct('sensorSolution',sensorSolution,...
    'achieved',achieved,...
    'numberofSensors',0:nPossibleSensor);

