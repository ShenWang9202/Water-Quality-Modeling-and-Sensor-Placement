function [Index,isPipe] =  findIndexofLastorFirstSegment(ind,IndexInVar,flipped,NumberofSegment4Pipes)
basePipeIndex = min(IndexInVar.PipeIndex);
%BasePipe_CIndex = min(IndexInVar.Pipe_CIndex);
Pipe_CStartIndex = IndexInVar.Pipe_CStartIndex;
basePumpIndex = min(IndexInVar.PumpIndex);
BasePump_CIndex = min(IndexInVar.Pump_CIndex);
baseValveIndex = min(IndexInVar.ValveIndex);
BaseValve_CIndex = min(IndexInVar.Valve_CIndex);

isPipe = isLink(ind,IndexInVar.PipeIndex);
isPump = isLink(ind,IndexInVar.PumpIndex);
isValve = isLink(ind,IndexInVar.ValveIndex);

% if(isPipe) % contribution is from pipe
%     howmany = ind - basePipeIndex +1;
%     if(flipped)
%         Index =  (howmany - 1) * Constants4Concentration.NumberofSegment + BasePipe_CIndex;
%     else
%         Index =  howmany * Constants4Concentration.NumberofSegment + BasePipe_CIndex - 1;
%     end
% else % pump or valves
%     Index = ind - basePumpIndex + BasePump_CIndex;
% end


if(isPipe) % contribution is from pipe
    firstSegment = Pipe_CStartIndex(ind);
    lastSegment = Pipe_CStartIndex(ind) + NumberofSegment4Pipes(ind)-1;
    if(flipped)
        Index =  firstSegment;
    else
        Index =  lastSegment;
    end
end
 
if(isPump) % pump 
    Index = ind - basePumpIndex + BasePump_CIndex;
end

if(isValve) %valves
    Index = ind - baseValveIndex + BaseValve_CIndex;
end
    
end

function result =  isLink(ind,LinkIndexRanges)
result = false;
index = find(LinkIndexRanges == ind, 1);
if(~isempty(index))
    result = true;
end
end

% 
% function result =  isPump(ind,PipeIndex)
% result = true;
% if(ind>max(PipeIndex))
%     result = false;
% end
% end
% 
% 
% function result =  ispipe(ind,PipeIndex)
% result = true;
% if(ind>max(PipeIndex))
%     result = false;
% end
% end