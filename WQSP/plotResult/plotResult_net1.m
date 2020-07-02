clear
close all;
clc

load('Net1_4days.mat')
plotDemandPipeFlowRateSeperately_net1

InterestedTime2 = 3012;
plotControlActionU_net1_4days(ControlActionU,BoosterLocationIndex,Location_B,InterestedTime2)
plotJunction
plotPipe