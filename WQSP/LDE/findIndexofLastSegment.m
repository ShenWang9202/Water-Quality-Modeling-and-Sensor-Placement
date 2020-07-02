function Index =  findIndexofLastSegment(ind,IndexInVar)
basePipeIndex = min(IndexInVar.PipeIndex);
BasePipe_CIndex = min(IndexInVar.Pipe_CIndex);
basePumpIndex = min(IndexInVar.PumpIndex);
BasePump_CIndex = min(IndexInVar.Pump_CIndex);
if(ispipe(ind,IndexInVar.PipeIndex)) % contribution is from pipe
    howmany = ind - basePipeIndex +1;
    Index =  howmany * Constants4Concentration.NumberofSegment + BasePipe_CIndex - 1;
else % pump or valves
    Index = ind - basePumpIndex + BasePump_CIndex;
end
end

function result =  ispipe(ind,PipeIndex)
result = true;
if(ind>max(PipeIndex))
    result = false;
end
end