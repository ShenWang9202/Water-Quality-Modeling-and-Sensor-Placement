% A simple example to illustrate the observability (Gramian) for the
% three-node network

% System: only on Windows
% Matlab Version: R2019b
% Author: Shen Wang
% Date: 3/7/2020


%% Load EPANET MATLAB TOOLKIT
start_toolkit;
Network = 1;
NetworkName = 'Threenode-cl-2-paper.inp'; % topogy changes
filename = 'Three-node_1day.mat';
sensorNumberArray = [1 2];
COMPARE = 1;
Expected_t = 2.2;
SimutionTimeInMinute = 24*60; %Simulate three-node for 1 day
Hq_min = 5;

%% Prepare constants data for MPC
PrepareData4SensorSelection

% define the number of segment, useless code, delete later
NumberofSegment = Constants4Concentration.NumberofSegment;

%% initialize concentration at nodes

Location_B = {'J2'}; % NodeID here;
flowRate_B = [10]; % unit: GPM
Price_B = [1];

[q_B,Price_B,BoosterLocationIndex,BoosterCount] = InitialBooster(nodeCount,Location_B,flowRate_B,NodeID,Price_B);


% Compute Quality without MSX
% (This function contains events) Don't uncomment this commands!!! Crash
% easily
qual_res = d.getComputedQualityTimeSeries; %Value x Node, Value x Link
LinkQuality = qual_res.LinkQuality;
NodeQuality = qual_res.NodeQuality;

% Initial Concentration
C0 = [NodeQuality(1,:) LinkQuality(1,:)];


%% Construct aux struct

aux = struct('NumberofSegment',NumberofSegment,...
    'NumberofSegment4Pipes',[],...
    'LinkLengthPipe',LinkLengthPipe,...
    'LinkDiameterPipe',LinkDiameterPipe,...
    'TankBulkReactionCoeff',TankBulkReactionCoeff,...
    'TankMassMatrix',TankMassMatrix,...
    'JunctionMassMatrix',JunctionMassMatrix,...
    'MassEnergyMatrix',MassEnergyMatrix,...
    'NodeNameID',{NodeNameID},...
    'LinkNameID',{LinkNameID},...
    'NodesConnectingLinksID',{NodesConnectingLinksID},...
    'COMPARE',COMPARE);

%% Start

StoreRoom = cell(2,1);
QsN_Control = [];
QsL_Control = [];
T = [];
PreviousSystemDynamicMatrix = [];
X_estimated = [];
PreviousDelta_t = [];
JunctionActualDemand = [];
Head = [];
Flow = [];
XX_estimated = [];
sensorSelectionResult = [];
Velocity = [];
Delta_t = [];
NpMatrix = [];
XX_estimated_Cell = cell(200,1);
IndexInVarCell = cell(200,1);
NumberofSegment4Pipes_all = [];

Amatrix = cell(1,20);
Bmatrix = cell(1,20);
Cmatrix = cell(1,20);
tempCell = 1;
tempCell1 = 1;

PreviousValue = struct('PreviousDelta_t',PreviousDelta_t,...
    'PreviousSystemDynamicMatrix',PreviousSystemDynamicMatrix,...
    'PreviousNumberofSegment4Pipes',[],...
    'IndexInVarOld',[],...
    'X_estimated',X_estimated,...
    'U_C_B_eachStep',0,...
    'tInMin',0,...
    'UeachMinforEPANET',0);

d.openHydraulicAnalysis;
d.openQualityAnalysis;
d.initializeHydraulicAnalysis;
d.initializeQualityAnalysis;

tleft=1;
tInMin = 0;
delta_t = 0;

% profile on
tic
while (tleft>0 && tInMin < SimutionTimeInMinute && delta_t <= 60)
    t1 = d.runHydraulicAnalysis;
    t=d.runQualityAnalysis;
    
    % Obtain the actual Concentration
    QsN_Control=[QsN_Control; d.getNodeActualQuality];
    QsL_Control=[QsL_Control; d.getLinkQuality];
    Head=[Head; d.getNodeHydaulicHead];
    Flow=[Flow; d.getLinkFlows];
    TempDemand = d.getNodeActualDemand;
    JunctionActualDemand = [JunctionActualDemand; TempDemand(NodeJunctionIndex)];
    
    tInMin = t/60;
    if(mod(tInMin,Hq_min)==0)
        % 5 miniute is up, Calculate the New Control Action
        disp('Current time')
        tInMin
        PreviousValue.tInMin = tInMin;
        tInHour = tInMin/60
        
        CurrentVelocity = d.getLinkVelocity;
        CurrentVelocityPipe = CurrentVelocity(:,PipeIndex);
        Velocity = [Velocity CurrentVelocityPipe'];
        
        % obtain Pipe Reaction Coeffs
        PipeReactionCoeff = CalculatePipeReactionCoeff(CurrentVelocityPipe,LinkDiameterPipe,Kb_all,Kw_all,PipeIndex);
        
        % obtain the segments according to current velocity and link length
        if(mod(tInMin,60)==0)
            NumberofSegment4Pipes = generateDynamicSegments4Pipes(Network,LinkLengthPipe,CurrentVelocityPipe,Expected_t);
            PreviousValue.PreviousNumberofSegment4Pipes = NumberofSegment4Pipes;
        end
        
        NumberofSegment4Pipes_all = [NumberofSegment4Pipes_all; NumberofSegment4Pipes];
        % update corresponding structures
        [IndexInVar,aux] = updateStructures(IndexInVar,aux,ElementCount,NumberofSegment4Pipes);
        % the minium step length for all pipes
        delta_t = LinkLengthPipe./NumberofSegment4Pipes./CurrentVelocityPipe;
        
        delta_t = min(delta_t);
        Delta_t = [Delta_t delta_t'];
        delta_t = MakeDelta_tAsInteger(delta_t)
        
        CurrentFlow = d.getLinkFlows; CurrentHead = d.getNodeHydaulicHead; Volume = d.getNodeTankVolume;
        CurrentNodeTankVolume = Volume(NodeTankIndex);
        
        % Estimate Hp of concentration; basciall 5 mins = how many steps
        SetTimeParameter = Hq_min*Constants4Concentration.MinInSecond/delta_t;
        Np = round(SetTimeParameter)
        NpMatrix = [NpMatrix Np];
        
        CurrentValue = struct('CurrentVelocityPipe',CurrentVelocityPipe,...
            'CurrentNodeTankVolume',CurrentNodeTankVolume,...
            'CurrentFlow',CurrentFlow,...
            'CurrentHead',CurrentHead,...
            'delta_t',delta_t,...
            'PipeReactionCoeff',PipeReactionCoeff,...
            'Np',Np,...
            'tInMin',tInMin,...
            'SystemDynamicMatrix',[]);
        
        % obtain dynamic
        [A,B,C] = ObtainDynamicNew(CurrentValue,IndexInVar,aux,ElementCount,q_B); % zeroRate(A)
        Amatrix{1,tempCell} = A;
        Bmatrix{1,tempCell} = B; 
        Cmatrix{1,tempCell} = C;
        tempCell = tempCell + 1;
    end
    T=[T; t];
    tstep1 = d.nextHydraulicAnalysisStep;
    tstep = d.nextQualityAnalysisStep;
    
end

runningtime = toc
d.closeQualityAnalysis;
d.closeHydraulicAnalysis;
%% Start to calculate observability (Gramian)

A = Amatrix{1};
B = Bmatrix{1};
C = Cmatrix{1};
D = 0;
ob = obsv(A,C);
delta_t = Delta_t(1);
% plot ob
figure
spy(ob)
% rank of ob
rank(ob)

% Since our system is marginally stable, the Gramian command cannot be
% used.
% sys = ss(A,B,C,D,delta_t);
% Wo = gram(sys, 'o');
% istable(A)

nx = size(A,1);
gramian = sparse(nx,nx);
temp1 = C;
Temp = C' * C;
kf = 200;
for j=1:kf
    % from [0,k]
    gramian = gramian + Temp;
    temp1 = temp1*A;
    Temp = temp1'*temp1;
end


