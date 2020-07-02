function NumberofSegment4Pipes = GenerateSegments4Pipes(LinkLengthPipe,PipeIndex,d,Network)

% See ConstructMatrixForJunction_NoneD.m
% When calculate the concentration at junction, we make it
% equal the average of first four segment or last four segment, 
% Hence, the minium segment should be larger than or equal to 4;

[~,PipeCount] = size(PipeIndex);

NumberofSegment4Pipes = 4 * ones(1,PipeCount); % defaultly, it should be 4;

allResult = d.getComputedHydraulicTimeSeries;
Velocity = allResult.Velocity; % volocity for all pipes at all times
pipeVelocity = Velocity(:,PipeIndex);

% maxVelocity = max(Velocity);
% maxVelocity = maxVelocity(:,PipeIndex);
% 
% minVelocity = min(Velocity);
% minVelocity = minVelocity(:,PipeIndex);

Expectedt = 5;
NumberofSegment4Pipes = LinkLengthPipe./pipeVelocity'./Expectedt;
NumberofSegment4PipesMax = LinkLengthPipe./10;

NumberofSegment4Pipes = min(NumberofSegment4Pipes,NumberofSegment4PipesMax);
NumberofSegment4Pipes(NumberofSegment4Pipes > 4) = 4;

% switch Network
%     case 1 % 3-node network
%         NumberofSegment4Pipes = 150;%Constants4Concentration.NumberofSegment;
%     case 4  % 8-node network
%         NumberofSegment4Pipes = LinkLengthPipe/10; % ones(size(LinkLengthPipe))*3;
%         NumberofSegment4Pipes = ceil(NumberofSegment4Pipes);
%     case 7
%         NumberofSegment4Pipes = LinkLengthPipe/20;
%         NumberofSegment4Pipes = ceil(NumberofSegment4Pipes);
% %         NumberofSegment4Pipes(NumberofSegment4Pipes<80) = 80;
%         
%     case 9 % net3 network
% %         extraSeg = 10;
% %         for i = 1:PipeCount
% %             if(LinkLengthPipe(i) <= 200)
% %                 NumberofSegment4Pipes(i) = 15 + extraSeg;
% %             end
% %             if(LinkLengthPipe(i) > 200 && LinkLengthPipe(i) <= 500)
% %                 NumberofSegment4Pipes(i) = 20 + extraSeg;
% %             end
% %             if(LinkLengthPipe(i) > 500 && LinkLengthPipe(i) <= 1000)
% %                 NumberofSegment4Pipes(i) = 50;
% %             end
% %             if(LinkLengthPipe(i) > 1000 && LinkLengthPipe(i) <= 2000)
% %                 NumberofSegment4Pipes(i) = 80;
% %             end
% %             if(LinkLengthPipe(i) > 2000 && LinkLengthPipe(i) <= 3000)
% %                 NumberofSegment4Pipes(i) = 100;
% %             end
% %             if(LinkLengthPipe(i) > 3000 && LinkLengthPipe(i) <= 5000)
% %                 NumberofSegment4Pipes(i) = 150;
% %             end
% %             if(LinkLengthPipe(i) > 5000 && LinkLengthPipe(i) <= 10000)
% %                 NumberofSegment4Pipes(i) = 400;
% %             end
% %             
% %             if(LinkLengthPipe(i) > 10000 && LinkLengthPipe(i) <= 30000)
% %                 NumberofSegment4Pipes(i) = 800;
% %             end
% %             if(LinkLengthPipe(i) > 30000 && LinkLengthPipe(i) <= 50000)
% %                 NumberofSegment4Pipes(i) = 2000;
% %             end
% %             
% %             if(LinkLengthPipe(i) > 50000)
% %                 NumberofSegment4Pipes(i) = 3000;
% %             end
% %         end
%         NumberofSegment4Pipes = LinkLengthPipe/5;
%         NumberofSegment4Pipes = ceil(NumberofSegment4Pipes);
%         NumberofSegment4Pipes(NumberofSegment4Pipes<4) = 4;
% %         NumberofSegment4Pipes(1:3) = 20;
%         
%         
%         % allResult = d.getComputedHydraulicTimeSeries;
%         % Velocity = allResult.Velocity; % volocity for all pipes at all times
%         % maxVelocity = max(Velocity);
%         % maxVelocity = maxVelocity(:,PipeIndex);
%         %
%         % minVelocity = min(Velocity);
%         % minVelocity = minVelocity(:,PipeIndex);
%         %
%         % Expectedt = 10;
%         % NumberofSegment4Pipes = LinkLengthPipe./minVelocity./Expectedt;
%         % NumberofSegment4Pipes = LinkLengthPipe./maxVelocity./Expectedt;
%         
% 
%  
% end

% See ConstructMatrixForJunction_NoneD.m
% When calculate the concentration at junction, we make it
% equal the average of first four segment or last four segment, 
% Hence, the minium segment should be larger than or equal to 4;
% NumberofSegment4Pipes(NumberofSegment4Pipes < 4) = 4;

end