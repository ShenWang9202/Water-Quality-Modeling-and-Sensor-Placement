function NumberofSegment4Pipes = generateSegments4Pipes_store(LinkLengthPipe)

% See ConstructMatrixForJunction_NoneD.m
% When calculate the concentration at junction, we make it
% equal the average of first four segment or last four segment, 
% Hence, the minium segment should be larger than or equal to 4;

NumberofSegment4Pipes = LinkLengthPipe./10;
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
NumberofSegment4Pipes(NumberofSegment4Pipes < 5) = 5;

end