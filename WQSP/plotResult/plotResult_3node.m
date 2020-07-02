clear
% Plot MPC
load('Three-node_1day.mat')
plotDemandPipeFlowRateSeperately_3nodes
plotControlActionU_3node(ControlActionU,BoosterLocationIndex,Location_B)


% LinkID4Legend= {'P23','M12'};
% % This is from LED model
% plotLinkConcentrations_3node(LinkID4Legend,X_link_control_result)
% plotNodeConcentrations_3node(NodeID4Legend,X_node_control_result)
% % This is from EPANET model
% plotLinkConcentrations_3node(LinkID4Legend,QsL_Control)
% plotNodeConcentrations_3node(NodeID4Legend,QsN_Control)

%% Plot LinkNodeConcentration_3node Together
% NodeID4Legend = {'J2','T3'};
% LinkID4Legend= {'P23'};


% This is from LED model
ID4Legend = {'J2','TK3','P23'};
X_control_result = [];
X_control_result = [X_control_result X_node_control_result(:,1)]; % J2
X_control_result = [X_control_result X_node_control_result(:,3)]; % T3
X_control_result = [X_control_result X_link_control_result(:,1)]; % P23
fileName = 'EnlargedLinkNodeConcentrations_3node';
plotLinkNodeConcentrations_3node(ID4Legend,X_control_result,fileName)
% This is from EPANET model
X_control_result = [];
X_control_result = [X_control_result QsN_Control(:,1)]; % J2
X_control_result = [X_control_result QsN_Control(:,3)]; % T3
X_control_result = [X_control_result QsL_Control(:,1)]; % P23
plotLinkNodeConcentrations_3node(ID4Legend,X_control_result,fileName)

% Compute cost function

% Compute deviation, 
[m,n] = size(X_control_result);
deviation =  X_control_result - 2* ones(m,n);
deviation = deviation.^2;
deviation = sum(sum(deviation))
% Compute smoothness, 
[m,n] = size(ControlActionU);
DelataControlActionU = zeros(m-1,n);
for i = 1:m-1
 DelataControlActionU(i,:) = ControlActionU(i+1,:) - ControlActionU(i,:);
end

smoothness = DelataControlActionU.^2;
smoothness = sum(sum(smoothness))

chlorinedose = sum(sum(ControlActionU(:,BoosterLocationIndex)));
Price_Weight = Constants4Concentration.Price_Weight;
Cost = chlorinedose* Price_Weight

AllCost = deviation + smoothness + Cost

%%
close all;
clc
% Plot Rule based control Results
clear

load('Three-node_1day_RBC.mat')
plotControlActionU_3node_RBC(ControlActionU,BoosterLocationIndex,Location_B)
% LinkID4Legend= {'P23','M12'};
% plotLinkConcentrations_3node_RBC(LinkID4Legend,X_link_control_result)
% plotNodeConcentrations_3node_RBC(NodeID4Legend,X_node_control_result)

% This is from LED model
ID4Legend = {'J2','TK3','P23'};
X_control_result = [];
X_control_result = [X_control_result X_node_control_result(:,1)]; % J2
X_control_result = [X_control_result X_node_control_result(:,3)]; % T3
X_control_result = [X_control_result X_link_control_result(:,1)]; % P23
fileName = 'EnlargedLinkNodeConcentrations_RBC';
plotLinkNodeConcentrations_3node(ID4Legend,X_control_result,fileName)

% Compute cost function

% Compute deviation, 
[m,n] = size(X_control_result);
deviation =  X_control_result - 2* ones(m,n);
deviation = deviation.^2;
deviation = sum(sum(deviation))
% Compute smoothness, 
[m,n] = size(ControlActionU);
DelataControlActionU = zeros(m-1,n);
for i = 1:m-1
 DelataControlActionU(i,:) = ControlActionU(i+1,:) - ControlActionU(i,:);
end

smoothness = DelataControlActionU.^2;
smoothness = sum(sum(smoothness))

chlorinedose = sum(sum(ControlActionU(:,BoosterLocationIndex)));
Price_Weight = Constants4Concentration.Price_Weight;
Cost = chlorinedose* Price_Weight

AllCost = deviation + smoothness + Cost



% This is from EPANET model
X_control_result = [];
X_control_result = [X_control_result QsN_Control(:,1)]; % J2
X_control_result = [X_control_result QsN_Control(:,3)]; % T3
X_control_result = [X_control_result QsL_Control(:,1)]; % P23
plotLinkNodeConcentrations_3node(ID4Legend,X_control_result,fileName)
