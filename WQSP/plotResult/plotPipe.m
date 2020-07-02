X_Pipe_control_result =  X_Min_Average(:,PipeIndexInOrder);
faceColor = 'b';
transparency = 0.2;
fontSize = 40;
lineWidth = 3.5;
InterestedID = {'P11'};
% Since the first junction is J10, however, it is uncontrollable, and the
% data is always 1, we don't display the concentration of J10
%IngoreID = {'J10'};
InterestedTime2 = 3050;
BlueLineWidth = 3.5;
plotMinMaxRange4Pipe(X_Pipe_control_result,InterestedID,PipeID,faceColor,transparency,fontSize,BlueLineWidth,lineWidth,InterestedTime2)

InterestedID = {'P31','P110'};
InterestedTime2 = 3200;
lineWidth = 3.5;
BlueLineWidth = 2;
plotMinMaxRange4Pipe(X_Pipe_control_result,InterestedID,PipeID,faceColor,transparency,fontSize,BlueLineWidth,lineWidth,InterestedTime2)
