function KSegmentIndexofPipe = findKSegmentIndexofPipe(pipeIndex,k,BasePipe_CIndex,NumberofSegment)
CIndexofPipe = findCIndexofPipe(pipeIndex,BasePipe_CIndex,NumberofSegment);
KSegmentIndexofPipe = CIndexofPipe(1:(k-1));
%KSegmentIndexofPipe = BaseCindeofPipe_i:(BaseCindeofPipe_i+k-2);
end