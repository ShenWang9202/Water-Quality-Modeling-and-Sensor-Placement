function value = step(d, varargin)
NodeCount=1:d.getNodeCount;%index node
LinkCount=1:d.getLinkCount;%index link
SpeciesCount=1:d.getMSXSpeciesCount;

value.NodeQuality = cell(1, length(NodeCount));
value.LinkQuality = cell(1, length(LinkCount));
% Obtain a hydraulic solution
d.solveMSXCompleteHydraulics;
% Run a step-wise water quality analysis without saving
% RESULTS to file
d.initializeMSXQualityAnalysis(0);
% Retrieve species concentration at node
k=1; tleft=1;t=0;
value.Time(k, :)=0;
time_step = d.getMSXTimeStep;
timeSmle=d.getTimeSimulationDuration;%bug at time
while(tleft>0 && d.Errcode==0 && timeSmle~=t)
    [t, tleft]=d.stepMSXQualityAnalysisTimeLeft;
    if t<time_step || t==time_step
        i_node=1;
        i_link=1;
        for nl=NodeCount
            g=1;
            for j=SpeciesCount
                value.NodeQuality{i_node}(k, g)=d.getMSXNodeInitqualValue{(nl)}(j);
                g=g+1;
            end
            i_node=i_node+1;
        end
        for nl=LinkCount
            g=1;
            for j=SpeciesCount
                value.NodeQuality{i_link}(k, g)=d.getMSXNodeInitqualValue{(nl)}(j);
                g=g+1;
            end
            i_link=i_link+1;
        end
    else
        i_node=1;
        i_link=1;
        for nl=NodeCount
            g=1;
            for j=SpeciesCount
                value.LinkQuality{i_node}(k, g)=d.getMSXSpeciesConcentration(0, (nl), j);%node code 0
                g=g+1;
            end
            i_node=i_node+1;
        end
        for nl=LinkCount
            g=1;
            for j=SpeciesCount
                value.LinkQuality{i_link}(k, g)=d.getMSXSpeciesConcentration(1, (nl), j);%link code 1 
                g=g+1;
            end
            i_link=i_link+1;
        end
    end
    
    if k>1
        value.Time(k, :)=t;
    end
    k=k+1;
end
end