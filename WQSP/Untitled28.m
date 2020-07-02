clear
clc
% test the segment impact of a single pipe

% The number of tank the pipe connecting with Tank to 200 is set to 10
load('Net1_1days_3189x1441_5min.mat')
achievedError_20 = achievedError;
finalResultCell_20  = finalResultCell;

load('Net1_1days_6365x1441_5min.mat')
achievedError_10 = achievedError;
finalResultCell_10 = finalResultCell;

% The number of tank the pipe connecting with Tank to 200 is set to 80
load('Net1_1days_3259x1441_5min.mat')

achievedError_20_80 = achievedError;
finalResultCell_20_80 = finalResultCell;

% change number of tank the pipe connecting with Tank to 200
load('Net1_1days_3379x1441.mat')
achievedError_20_200 = achievedError;
finalResultCell_20_200 = finalResultCell;

[~,r] = size(achievedError);
Error = [];
errorDis = [];
for i = 1:r
    error = achievedError_20_80(:,i) - achievedError_20(:,i);
    errorDistance = norm(error)/norm(achievedError_20_80(:,i));
    Error = [Error error];
    errorDis = [errorDis errorDistance];
end

errorDis

load('Net1_1days_2203x1441.mat')

achievedError_30_80 = achievedError;
finalResultCell_30_80 = finalResultCell;

load('Net1_1days_2130x1441_5min.mat')

achievedError_30 = achievedError;
finalResultCell_30 = finalResultCell;

% 
[~,r] = size(achievedError);
Error = [];
errorDis = [];
for i = 1:r
    error = achievedError_30(:,i) - achievedError_20(:,i);
    errorDistance = norm(error)/norm(achievedError_20(:,i));
    Error = [Error error];
    errorDis = [errorDis errorDistance];
end


errorDis


% test the Hq impact.

% The number of tank the pipe connecting with Tank to 200 is set to 10
load('Net1_1days_3189x1441_1min.mat')
achievedError_20_1min = achievedError;
finalResultCell_20_1min  = finalResultCell;

achievedError_20 = achievedError_20(1:end-1,:);
achievedError_20_1min = achievedError_20_1min(1:end-1,:);
achievedError_20_scaled = zeros(size(achievedError_20_1min));

for i = 1:3
    achievedError_20_scaled(:,i) = scaleUpDown(achievedError_20(:,i),1440);
end


[~,r] = size(achievedError_20_scaled);
Error = [];
errorDis = [];
for i = 1:r
    error = achievedError_20_scaled(:,i) - achievedError_20_1min(:,i);
    errorDistance = norm(error)/norm(achievedError_20_1min(:,i));
    Error = [Error error];
    errorDis = [errorDis errorDistance];
end






