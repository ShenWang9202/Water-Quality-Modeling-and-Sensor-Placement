% Main Program to perform sensor selection under the metric of minimizing error of Kalman filter
% System: only on Windows
% Author: Shen Wang
% Date: 3/7/2020


clear all
clc
close all
%% Load EPANET MATLAB TOOLKIT
start_toolkit;

% check this example Toolkit_EX3_Minimum_chlorine_residual.m
%% run EPANET MATLAB TOOLKIT to obtain data

% Demand uncertainty on or off
DEMAND_UNCERTAINTY = 0;
Demand_Unc = 0.1;
% Unknown uncertainty on or off
UNKNOW_UNCERTAINTY = 0;
% Parameter uncertainty on or off

PARAMETER_UNCERTAINTY = 0;
Kb_uncertainty = 0.1;
Kw_uncertainty = 0.1;

SENSORSELECT = Constants4Concentration.SensorSelction;
COMPARE = Constants4Concentration.COMPARE;


assert((SENSORSELECT || COMPARE) == 1, "One of them most be 1")

if(COMPARE || SENSORSELECT) % when compare LDE with EPANET, We have to make all uncertainty disappear
    PARAMETER_UNCERTAINTY = 0;
    UNKNOW_UNCERTAINTY = 0;
    DEMAND_UNCERTAINTY = 0;
end

 % Don't use case 2

Network = Constants4Concentration.Network;

% Network = 1; % Don't use case 2
% Network = 9; % Don't use case 2

% Don't forget to add the corresponding code for a new netwrok in
% GenerateSegments4Pipes.m
sensorNumberArray = [];
switch Network
    case 1
        % Quality Timestep = 1 min, and  Global Bulk = -0.3, Global Wall= -0.0
        % NetworkName = 'Threenode-cl-2-paper.inp'; pipe flow direction
        % never changed, and the result is perfectly matched with EPANET
        %NetworkName = 'Threenode-cl-3-paper.inp'; % Pipe flow direction changes
        NetworkName = 'Threenode-cl-2-paper.inp'; % topogy changes
        Unknown_Happen_Time = 200;
        PipeID_Cell = {'P1'};
        JunctionID_Cell = {'J2'};
        Sudden_Concertration = 1.0; % Suddenly the concentration jumps to this value for no reason
        filename = 'Three-node_1day.mat';
        sensorNumberArray = [1 2];
    case 2
        % Don't not use one: Quality Timestep = 5 min, and  Global Bulk = -0.3, Global Wall=
        % -1.0
        NetworkName = 'tutorial8node.inp';
    case 3
        % Quality Timestep = 1 min, and  Global Bulk = -0.3, Global Wall= -0.0
        NetworkName = 'tutorial8node1.inp';
    case 4
        % Quality Timestep = 1 min, and  Global Bulk = -0.3, Global Wall=
        % -0.0; initial value: J2 = 0.5 mg/L, J6 = 1.2 mg/L, R1 = 0.8 mg/L;
        % segment = 1000;
        NetworkName = 'tutorial8node1inital3.inp';
        filename = '8node_1day.mat';
        sensorNumberArray = [1 3 5];
    case 5
        % Quality Timestep = 1 min, and  Global Bulk = -0.5, Global Wall=
        % -0.0;
        NetworkName = 'Net1-1min.inp';
    case 6
        % The initial value is slightly different
        NetworkName = 'Net1-1mininitial.inp';
    case 7
        % Quality Timestep = 1 min, and  Global Bulk = -0.3, Global Wall= -0.0
        NetworkName = 'Net1-1min-new-demand-pattern.inp';
        Unknown_Happen_Time = 3000; % Unknow Disturbance happened at the 3000-th minutes
        PipeID_Cell = {'P11','P21','P31'};
        JunctionID_Cell = {'J11','J21','J31'};
        Sudden_Concertration = 0.5;
        filename = 'Net1_1days.mat';
        sensorNumberArray = [1 4 7];
    case 8
        % Quality Timestep = 1 min, and  Global Bulk = -0.3, Global Wall= -0.0
        NetworkName = 'Fournode-Cl-As-1.inp';
    case 9
        %NetworkName = 'Net3-NH2CL-24hour-4.inp'; % this is used to test the topology changes
        NetworkName = 'Net3-NH2CL-24hour-6.inp';
        filename = 'Net3_1day.mat';
        sensorNumberArray = [1 4 7 10 15 20];
    otherwise
        disp('other value')
end

%% Prepare constants data for MPC
PrepareData4SensorSelection

% define the number of segment, useless code, delete later
NumberofSegment = Constants4Concentration.NumberofSegment;
NumberofSegment4PipesStore = generateSegments4Pipes_store(LinkLengthPipe);
%% initialize concentration at nodes

% initialize BOOSTER
% flow of Booster, assume we put booster at each nodes, so the size of it
% should be the number of nodes.



switch Network
    case 1
        Location_B = {'J2'}; % NodeID here;
        flowRate_B = [10]; % unit: GPM
        Price_B = [1];
        % the C_B is what we need find in MPC, useless here
        %C_B = [1]; % unit: mg/L % Concentration of booster
    case {2,3,4}
        Location_B = {'J3','J7'}; % NodeID here;
        flowRate_B = [10,10]; % unit: GPM
        Price_B = [1,1];
        % the C_B is what we need find in MPC, useless here
        %C_B = [1]; % unit: mg/L % Concentration of booster
    case {5,6,7}
        Location_B = {'J11','J22','J31'}; % NodeID here;
        flowRate_B = [10,10,10]; % unit: GPM
        Price_B = [1,1,1];
        % the C_B is what we need find in MPC, useless here
        %C_B = [1]; % unit: mg/L % Concentration of booster
    case 8
        Location_B = {'J2'}; % NodeID here;
        flowRate_B = [100]; % unit: GPM
        Price_B = [1];
    case 9
        Location_B = {'J10'}; % NodeID here;
        flowRate_B = [100]; % unit: GPM
        Price_B = [1];
    otherwise
        disp('other value')
end


[q_B,Price_B,BoosterLocationIndex,BoosterCount] = InitialBooster(nodeCount,Location_B,flowRate_B,NodeID,Price_B);


% Get the flow rate and head when use demand without uncertainty
HydraulicInfoWithoutUncertainty =[];

if DEMAND_UNCERTAINTY
    HydraulicInfoWithoutUncertainty = ObtainNetworkHydraulicInfoWithoutUncertainty(d);
end


% Compute Quality without MSX
% (This function contains events) Don't uncomment this commands!!! Crash
% easily
qual_res = d.getComputedQualityTimeSeries; %Value x Node, Value x Link
LinkQuality = qual_res.LinkQuality;
NodeQuality = qual_res.NodeQuality;

% Initial Concentration
C0 = [NodeQuality(1,:) LinkQuality(1,:)];

% add uncertainty to the network
NodeJunctionIndex = d.getNodeJunctionIndex;
NodePatternIndex = d.getNodePatternIndex;
JunctionPatternIndex = NodePatternIndex(NodeJunctionIndex);
UniqueJunctionPatternIndex = unique(JunctionPatternIndex);

% get junction patterns
Patterns = d.getPattern;
JunctionPattern = Patterns(UniqueJunctionPatternIndex,:);

% generate new pattern with uncertainty
JunctionPattern_Uncertainty = add_uncertainty(JunctionPattern,Demand_Unc);

% Set Pattern needs pattern index and the corresponding pattern.
% for example, we need the Junction 2's index is 2, and the correpsonding
% Pattern index is 1. If we want to set Junction 2's new pattern, then just
% setPattern(1,newpattern)

if DEMAND_UNCERTAINTY
    d.setPattern(UniqueJunctionPatternIndex,JunctionPattern_Uncertainty);
end

%% Construct aux struct

aux = struct('NumberofSegment',NumberofSegment,...
    'NumberofSegment4Pipes',[],...
    'LinkLengthPipe',LinkLengthPipe,...
    'LinkDiameterPipe',LinkDiameterPipe,...
    'TankBulkReactionCoeff',TankBulkReactionCoeff,...
    'TankMassMatrix',TankMassMatrix,...
    'JunctionMassMatrix',JunctionMassMatrix,...
    'MassEnergyMatrix',MassEnergyMatrix,...
    'flowRate_B',flowRate_B,...
    'q_B',q_B,...
    'Price_B',Price_B,...
    'NodeNameID',{NodeNameID},...
    'LinkNameID',{LinkNameID},...
    'NodesConnectingLinksID',{NodesConnectingLinksID},...
    'COMPARE',COMPARE);


%% Start


QsN_Control = []; QsL_Control = []; NodeSourceQuality = []; T = []; PreviousSystemDynamicMatrix = []; UeachMin = [];
X_estimated = []; PreviousDelta_t = []; ControlActionU = []; JunctionActualDemand = []; Head = []; Flow = []; XX_estimated = [];
ControlActionU_LDE = [];
sensorSelectionResult = [];
Velocity = [];
Delta_t = [];
NpMatrix = [];
Magnitude = [];
Hq_min = Constants4Concentration.Hq_min;% I need that all concention 5 minutes later are  in 0.2 mg 4 mg
SimutionTimeInMinute = Constants4Concentration.SimutionTimeInMinute;

NumberofSegment4Pipes_all = [];

Amatrix = cell(1,20);
Cmatrix = cell(1,20);

tempCell = 1;

PreviousValue = struct('PreviousDelta_t',PreviousDelta_t,...
    'PreviousSystemDynamicMatrix',PreviousSystemDynamicMatrix,...
    'PreviousNumberofSegment4Pipes',[],...
    'IndexInVarOld',[],...
    'X_estimated',X_estimated,...
    'U_C_B_eachStep',0,...
    'UeachMinforEPANET',0);

d.openHydraulicAnalysis;
d.openQualityAnalysis;
d.initializeHydraulicAnalysis;
d.initializeQualityAnalysis;

tleft=1;
tInMin = 0;
delta_t = 0;

if DEMAND_UNCERTAINTY
    % load the head, flow, and velocity without uncertainty
    HeadWithoutUncertainty = HydraulicInfoWithoutUncertainty.Head;
    FlowWithoutUncertainty = HydraulicInfoWithoutUncertainty.Flow;
    VelocityPipeWithoutUncertainty = HydraulicInfoWithoutUncertainty.Velocity;
end
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
        tInHour = tInMin/60
        
        if(tInMin == 65)
            stophere = 1;
        end
        CurrentVelocity = d.getLinkVelocity;
        CurrentVelocityPipe = CurrentVelocity(:,PipeIndex);
        Velocity = [Velocity CurrentVelocityPipe'];
        
        % obtain Pipe Reaction Coeffs
        PipeReactionCoeff = CalculatePipeReactionCoeff(CurrentVelocityPipe,LinkDiameterPipe,Kb_all,Kw_all,PipeIndex);
        
        % obtain the segments according to current velocity and link length
        NumberofSegment4Pipes = generateDynamicSegments4Pipes(LinkLengthPipe,CurrentVelocityPipe);
        NumberofSegment4Pipes_all = [NumberofSegment4Pipes_all; NumberofSegment4Pipes];
        % update corresponding structures        
        [IndexInVar,aux] = updateStructures(IndexInVar,aux,ElementCount,NumberofSegment4Pipes);

        % the minium step length for all pipes
        delta_t = LinkLengthPipe./NumberofSegment4Pipes./CurrentVelocityPipe;
        Delta_t = [Delta_t delta_t'];
        
        delta_t = min(delta_t);
        delta_t = MakeDelta_tAsInteger(delta_t)

        CurrentFlow = d.getLinkFlows; CurrentHead = d.getNodeHydaulicHead; Volume = d.getNodeTankVolume;
        CurrentNodeTankVolume = Volume(NodeTankIndex);
        
        % Estimate Hp of concentration; basciall 5 mins = how many steps
        SetTimeParameter = Hq_min*Constants4Concentration.MinInSecond/delta_t;
        Np = round(SetTimeParameter)
        NpMatrix = [NpMatrix Np];

        % Collect the current value
        CurrentValue = struct('CurrentVelocityPipe',CurrentVelocityPipe,...
            'CurrentNodeTankVolume',CurrentNodeTankVolume,...
            'CurrentFlow',CurrentFlow,...
            'CurrentHead',CurrentHead,...
            'delta_t',delta_t,...
            'PipeReactionCoeff',PipeReactionCoeff,...
            'Np',Np,...
            'tInMin',tInMin);

        if(COMPARE)
            % Esitmate the concentration in all elements according to the system dynamics each 5 mins
            xx_estimated = EstimateState_XX_SaveMem(CurrentValue,IndexInVar,aux,ElementCount,C0,PreviousValue);
            % This is every 1 minute, that is, all 5 mins, for records purpose
            xx_estimated_scaled = scaleX(tInMin,xx_estimated,IndexInVar,PreviousValue,NumberofSegment4Pipes,ElementCount,NumberofSegment4PipesStore);
            XX_estimated = [XX_estimated xx_estimated_scaled];
        end
        
        if(SENSORSELECT && tInMin ~= 0)
            sensorSelectionResultEach5mins = ObtainSensorPlacement2(PreviousValue,nodeCount,IndexInVar.NumberofX,Np,sensorNumberArray,aux,IndexInVar);
            sensorSelectionResult = [sensorSelectionResult sensorSelectionResultEach5mins];
        end

        [A,B,C] = ObtainDynamicNew(CurrentValue,IndexInVar,aux,ElementCount,q_B); % zeroRate(A)

        Amatrix{1,tempCell} = A; Cmatrix{1,tempCell} = C; tempCell = tempCell + 1;

        PreviousSystemDynamicMatrix = struct('A',A,'B',B,'C',C);
        PreviousValue.PreviousDelta_t = delta_t;
        PreviousValue.PreviousSystemDynamicMatrix = PreviousSystemDynamicMatrix;
        PreviousValue.PreviousNumberofSegment4Pipes = NumberofSegment4Pipes;
        PreviousValue.IndexInVarOld = struct('Junction_CIndex',IndexInVar.Junction_CIndex,...
            'Reservoir_CIndex', IndexInVar.Reservoir_CIndex,...
            'Tank_CIndex',IndexInVar.Tank_CIndex,...
            'Pipe_CIndex',IndexInVar.Pipe_CIndex,...
            'Pipe_CStartIndex',IndexInVar.Pipe_CStartIndex,...
            'Pump_CIndex',IndexInVar.Pump_CIndex,...
            'Valve_CIndex',IndexInVar.Valve_CIndex);
        
        if(COMPARE)
            PreviousValue.X_estimated = xx_estimated(:,end);
        end
    end

    T=[T; t];
    tstep1 = d.nextHydraulicAnalysisStep;
    tstep = d.nextQualityAnalysisStep;
end
runningtime = toc
d.closeQualityAnalysis;
d.closeHydraulicAnalysis;
% p = profile('info')
% save myprofiledata p
% profile viewer
%% Start to plot


x0 = XX_estimated(:,1);
disp('Summary:')
disp(['Compare is: ',num2str(COMPARE)]);
disp(['Demand uncertainty is: ',num2str(DEMAND_UNCERTAINTY)]);
disp(['Unknown uncertainty is: ',num2str(UNKNOW_UNCERTAINTY)]);
disp(['Parameter uncertainty is: ',num2str(PARAMETER_UNCERTAINTY)]);
disp(['NumberofSegment4Pipes is: '])
NumberofSegment4Pipes

disp('Done!! Start to organize data')

NodeIndex = d.getNodeIndex;
LinkIndex = nodeCount+d.getLinkIndex;
NodeID4Legend = Variable_Symbol_Table2(NodeIndex,1);
LinkID4Legend = Variable_Symbol_Table2(LinkIndex,1);

figure
plot(QsN_Control);
legend(NodeID4Legend)
xlabel('Time (minute)')
ylabel('Concentrations at junctions (mg/L)')

figure
plot(QsL_Control);
legend(LinkID4Legend)
xlabel('Time (minute)')
ylabel('Concentrations in links (mg/L)')

figure
plot(JunctionActualDemand)
xlabel('Time (minute)')
ylabel('Demand at junctions (GPM)')

legend(NodeID4Legend)



figure
plot(Flow)
legend(LinkID4Legend)
xlabel('Time (minute)')
ylabel('Flow rates in links (GPM)')

if(COMPARE)
    % find average data;
    X_Min_Average = mergePipeSegment(XX_estimated,IndexInVar,aux,ElementCount);
    
    X_Min_Average = X_Min_Average';
    X_node_control_result =  X_Min_Average(:,NodeIndex);
    X_link_control_result =  X_Min_Average(:,LinkIndex);
    X_Junction_control_result =  X_Min_Average(:,NodeJunctionIndex);
    % X_link_control_result =  X_Min_Average(:,LinkIndex);
    
    figure
    plot(X_node_control_result);
    legend(NodeID4Legend)
    xlabel('Time (minute)')
    ylabel('Concentrations at junctions (mg/L)')
    
    figure
    plot(X_link_control_result);
    legend(LinkID4Legend)
    xlabel('Time (minute)')
    ylabel('Concentrations in links (mg/L)')
    
    epanetResult1 = [NodeQuality LinkQuality];
    epanetResult = [QsN_Control QsL_Control];
    % note that the above are both from EPAENT, their result are a little bit
    % different. I believe this because they use different method to implement
    % this.
    
    LDEResult = [X_node_control_result X_link_control_result];
    LDEResult1 = updateLDEResult(LDEResult,IndexInVar,MassEnergyMatrix);


%     Calculate_Error_EPANET_LDE(epanetResult1',LDEResult1');
%      This is for control purpose
    Calculate_Error_EPANET_LDE(epanetResult',LDEResult1');
    
% For large scale network, we compare them in group
    
    linkCount = d.getLinkCount;
    if(linkCount > 20)
        eachGroup = 10;
        numberOfGroups = ceil(linkCount/eachGroup);
        for i = 1:numberOfGroups
            range = ((i-1)*eachGroup+1):(i*eachGroup);
            if i == numberOfGroups
                range = ((i-1)*10+1):linkCount;
            end
            InterestedID = LinkID4Legend(range,:);
            InterestedID = InterestedID';
            LDEGroup = LDEResult1(1:SimutionTimeInMinute,LinkIndex);
            %         plotInterestedComponents(InterestedID,LinkID4Legend,LDEGroup,'LDE');
            EPANETGroup = epanetResult1(1:SimutionTimeInMinute,LinkIndex);
            %         plotInterestedComponents(InterestedID,LinkID4Legend,EPANETGroup,'EPANET');
            Calculate_Error_EPANET_LDE_Group(InterestedID,LinkID4Legend,EPANETGroup,LDEGroup)
        end
    end
    
end

filenameSplit = split(filename,'.');
if(SENSORSELECT)
    [finalResultCell,finalOccupationTimePlusNodeID,achievedError] = analyzeSensorSelectionResult(sensorSelectionResult,NodeID4Legend,filenameSplit{1},sensorNumberArray);
    plotSensorSelectionResult_specific(sensorSelectionResult,NodeID4Legend,filenameSplit{1},sensorNumberArray);
end

% InterestedID = LinkID4Legend(PipeIndex)';%{'P103','P105','P107','P109','P111'};
% plotImaginesc4InterestedComponents(X_Min,Pipe_CStartIndex,NumberofSegment4Pipes,InterestedID,LinkID4Legend);


% Plot interested data to compare
% Find interested data first

% InterestedID = {'P60','Pu335','Pu10','P330','P333'};
% SourceData = LDEResult1(:,LinkIndex);
% plotInterestedComponents(InterestedID,LinkID4Legend,SourceData,'LDE');
% SourceData = epanetResult1(1:SimutionTimeInMinute,LinkIndex);
% plotInterestedComponents(InterestedID,LinkID4Legend,SourceData,'EPANET');

% % Find interested data first
% InterestedID = {'J11','J21','J31'};
% SourceData = LDEResult1(:,NodeIndex);
% plotInterestedComponents(InterestedID,NodeID4Legend,SourceData);


% For large scale network, we compare them in group

linkCount = d.getLinkCount;
if(linkCount > 20)
    eachGroup = 10;
    numberOfGroups = ceil(linkCount/eachGroup);
    for i = 1:numberOfGroups
        range = ((i-1)*eachGroup+1):(i*eachGroup);
        if i == numberOfGroups
            range = ((i-1)*10+1):linkCount;
        end
        InterestedID = LinkID4Legend(range,:);
        InterestedID = InterestedID';
        LDEGroup = LDEResult1(1:SimutionTimeInMinute,LinkIndex);
%         plotInterestedComponents(InterestedID,LinkID4Legend,LDEGroup,'LDE');
        EPANETGroup = epanetResult1(1:SimutionTimeInMinute,LinkIndex);
%         plotInterestedComponents(InterestedID,LinkID4Legend,EPANETGroup,'EPANET');
        Calculate_Error_EPANET_LDE_Group(InterestedID,LinkID4Legend,EPANETGroup,LDEGroup)
    end
end
[row, column] = size(XX_estimated);
fileName2 = [filenameSplit{1},'_',num2str(row),'x',num2str(column),'_',num2str(Hq_min),'min','.mat'];
save(fileName2,'finalResultCell','finalOccupationTimePlusNodeID','achievedError')
save(filename)


sound1 = load('gong.mat');
sound(sound1.y,sound1.Fs);

