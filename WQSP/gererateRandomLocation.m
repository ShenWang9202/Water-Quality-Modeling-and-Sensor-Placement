function [SCell,indexCell] = gererateRandomLocation(sensorNumberArray,nodeCount,numofGroups)
% output: the sensor placement vector cell and its corresponding index cell
NodeIndexMax = nodeCount;
rng('default')
num = length(sensorNumberArray);
indexCell = cell(num,numofGroups);
SCell= cell(num,numofGroups);
for j = 1:num
    for i = 1:numofGroups
        s = rng(i);
        % Generate r locations between NodeIndexMin and NodeIndexMax;
        r = sensorNumberArray(j);
        %randomIndex = floor(NodeIndexMin + rand(1,r)*(NodeIndexMax - NodeIndexMin));
        randomIndex = randperm(NodeIndexMax,r);
        indexCell{j,i} = randomIndex;
        S = zeros(1,NodeIndexMax);
        S(randomIndex) = 1;
        SCell{j,i} = S;
    end
end

end

