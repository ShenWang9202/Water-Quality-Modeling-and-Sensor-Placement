% Main Program to generate different scenarios

% System: only on Windows
% Matlab Version: R2019b
% Author: Shen Wang
% Date: 3/7/2020

clear all;clc;close all;
%% test Three-node Network
SENSORSELECT = 1;
COMPARE = 1;
Network = 1; % Don't use case 2
ExpectedTimeStep = 2.2;
SimutionTimeInMinute = 24*60; %Simulate three-node for 1 day
Hq_min = 5;

tic
SensorSelection1(Network,SENSORSELECT,COMPARE,Hq_min,SimutionTimeInMinute,ExpectedTimeStep);
three_nodetime = toc;

%% test Eight-node Network
% SENSORSELECT = 1;
% COMPARE = 1;
% Network = 4; % Don't use case 2
% ExpectedTimeStep = 2.2;
% SimutionTimeInMinute = 24*60; %Simulate three-node for 1 day
% Hq_min = 5;
% tic
% SensorSelection1(Network,SENSORSELECT,COMPARE,Hq_min,SimutionTimeInMinute,ExpectedTimeStep);
% three-nodetime = toc
%% test Net1
SENSORSELECT = 1;
COMPARE = 1;
Network = 7; % Don't use case 2
ExpectedTimeStep = 5.2;
SimutionTimeInMinute = 24*60; %Simulate three-node for 1 day
Hq_min = 5;
tic
SensorSelection1(Network,SENSORSELECT,COMPARE,Hq_min,SimutionTimeInMinute,ExpectedTimeStep);
Net1time = toc
% another demand pattern
clc;close all;
Network = 6; 
tic
SensorSelection1(Network,SENSORSELECT,COMPARE,Hq_min,SimutionTimeInMinute,ExpectedTimeStep);
Net1newdemand = toc

% change observation interval to 1 min
clc;close all;
Network = 6; 
Hq_min = 1;
tic
SensorSelection1(Network,SENSORSELECT,COMPARE,Hq_min,SimutionTimeInMinute,ExpectedTimeStep);
Net1newdemand =  toc;
% change to another expected timestep ( smaller number of segments)
clc;close all;
Network = 6; 
Hq_min = 5;
ExpectedTimeStep = 10.2;
tic
SensorSelection1(Network,SENSORSELECT,COMPARE,Hq_min,SimutionTimeInMinute,ExpectedTimeStep);
Net1newtimestep =  toc;
% change to another expected timestep ( bigger number of segments)
clc;close all;
Network = 6; 
Hq_min = 5;
ExpectedTimeStep = 2.2;
SensorSelection1(Network,SENSORSELECT,COMPARE,Hq_min,SimutionTimeInMinute,ExpectedTimeStep);

%% test net3

clear all;clc;close all;
SENSORSELECT = 0;
COMPARE = 1;
Network = 9; % 
ExpectedTimeStep = 45;
SimutionTimeInMinute = 24*60; %Simulate three-node for 1 day
Hq_min = 5;

SensorSelection1(Network,SENSORSELECT,COMPARE,Hq_min,SimutionTimeInMinute,ExpectedTimeStep);

% find the achieved error of Kalman filter given different sensor
% locations;

SensorSelection_Random(Network,SENSORSELECT,COMPARE,Hq_min,SimutionTimeInMinute,ExpectedTimeStep);



