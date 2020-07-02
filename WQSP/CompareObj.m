function CompareObj
% The number of tank the pipe connecting with Tank to 200 is set to 10

clear
load('Net1_1days_Expected5.2_1min.mat')
achievedError_5s1min = achievedError;
finalResultCell_5s1min  = finalResultCell;

load('Net1_1days_Expected5.2_5min.mat')
achievedError_5s = achievedError;
finalResultCell_5s  = finalResultCell;

load('Net1_1days_Expected10.2_5min.mat')
achievedError_10s = achievedError;
finalResultCell_10s = finalResultCell;

% different time steps
[~,r] = size(achievedError);
Error = [];
errorDis = [];
for i = 1:r
    error = achievedError_10s(:,i) - achievedError_5s(:,i);
    errorDistance = norm(error)/norm(achievedError_5s(:,i));
    Error = [Error error];
    errorDis = [errorDis errorDistance];
end

% different observation interval



achievedError_5s = achievedError_5s(1:end-1,:);
achievedError_5s1min = achievedError_5s1min(1:end-1,:);
achievedError_5s1min_scaled = zeros(size(achievedError_5s1min));

for i = 1:3
    achievedError_5s1min_scaled(:,i) = scaleUpDown(achievedError_5s(:,i),1440);
end

[~,r] = size(achievedError_5s1min_scaled);
Error = [];
errorDis = [];
for i = 1:r
    error = achievedError_5s1min_scaled(:,i) - achievedError_5s1min(:,i);
    errorDistance = norm(error)/norm(achievedError_5s1min(:,i));
    Error = [Error error];
    errorDis = [errorDis errorDistance];
end







