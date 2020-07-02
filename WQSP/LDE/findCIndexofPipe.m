function CIndexofPipe = findCIndexofPipe(pipeIndex,BasePipe_CIndex,NumberofSegment)
CIndexofPipe = (BasePipe_CIndex + (pipeIndex-1)*NumberofSegment):(BasePipe_CIndex + (pipeIndex)*NumberofSegment - 1);
end