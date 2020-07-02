function NumberofSegment4Pipes = generateDynamicSegments4Pipes(network,LinkLengthPipe,pipeVelocity,Expected_t)

% See ConstructMatrixForJunction_NoneD.m
% When calculate the concentration at junction, we make it
% equal the average of first four segment or last four segment, 
% Hence, the minium segment should be larger than or equal to 4;

NumberofSegment4Pipes = LinkLengthPipe./pipeVelocity./Expected_t;
NumberofSegment4PipesMax = LinkLengthPipe./2;

NumberofSegment4Pipes = min(NumberofSegment4Pipes,NumberofSegment4PipesMax);
NumberofSegment4Pipes = ceil(NumberofSegment4Pipes);
num = length(NumberofSegment4Pipes);
% make sure all segments can be mod by 5; this would be use for scaling x up
% or down
for i = 1:num
    if(mod(NumberofSegment4Pipes(i),5))
        temp = floor(NumberofSegment4Pipes(i)/5) + 1;
        NumberofSegment4Pipes(i) = temp * 5;
    end
end
% NumberofSegment4Pipes = ceil(NumberofSegment4Pipes);
% sum(NumberofSegment4PipesMax)
% sum(NumberofSegment4Pipes)
NumberofSegment4Pipes(NumberofSegment4Pipes < 15) = 15;
NumberofSegment4Pipes(NumberofSegment4Pipes > 800) = 800;
% 
switch network
    case 6 % net1 network
        NumberofSegment4Pipes(NumberofSegment4Pipes < 15) = 15;
        NumberofSegment4Pipes(NumberofSegment4Pipes > 500) = 500;
    case 7
        NumberofSegment4Pipes(NumberofSegment4Pipes < 15) = 15;
        NumberofSegment4Pipes(NumberofSegment4Pipes > 500) = 500;
    case 9 % net1 network
        NumberofSegment4Pipes(NumberofSegment4Pipes < 10) = 10;
        NumberofSegment4Pipes(NumberofSegment4Pipes > 800) = 800;
    case 1
        NumberofSegment4Pipes(NumberofSegment4Pipes < 15) = 15;
        NumberofSegment4Pipes(NumberofSegment4Pipes > 800) = 800;
end

% See ConstructMatrixForJunction_NoneD.m
% When calculate the concentration at junction, we make it
% equal the average of first four segment or last four segment, 
% Hence, the minium segment should be larger than or equal to 4;
% NumberofSegment4Pipes(NumberofSegment4Pipes < 4) = 4;

end