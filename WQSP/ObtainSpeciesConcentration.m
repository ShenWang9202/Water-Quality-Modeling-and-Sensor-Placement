function [NodeQuality,LinkQuality] = ObtainSpeciesConcentration(d,t,time_step,NodeCount,LinkCount,SpeciesCount)
% This function is to obtain the concentration of species from all nodes
% and links at time t. It has the same function as d.getNodeActualQuality
% and d.getLinkActualQuality
    t
    NodeQuality = cell(1,length(NodeCount));
    LinkQuality = cell(1,length(LinkCount));
    if t<time_step || t==time_step
        i_node=1;
        i_link=1;
        for nl=NodeCount
            temp_counter=1;
            for j=SpeciesCount
                NodeQuality{i_node}(temp_counter)=d.getMSXNodeInitqualValue{(nl)}(j);
                temp_counter=temp_counter+1;
            end
            i_node=i_node+1;
        end
        for nl=LinkCount
            temp_counter=1;
            for j=SpeciesCount
                LinkQuality{i_link}(temp_counter)=d.getMSXNodeInitqualValue{(nl)}(j);
                temp_counter=temp_counter+1;
            end
            i_link=i_link+1;
        end
    else
        i_node=1;
        i_link=1;
        for nl=NodeCount
            temp_counter=1;
            for j=SpeciesCount
                NodeQuality{i_node}(temp_counter)=d.getMSXSpeciesConcentration(0, (nl), j);%node code 0
                temp_counter=temp_counter+1;
            end
            i_node=i_node+1;
        end
        for nl=LinkCount
            temp_counter=1;
            for j=SpeciesCount
                LinkQuality{i_link}(temp_counter)=d.getMSXSpeciesConcentration(1, (nl), j);%link code 1 
                temp_counter=temp_counter+1;
            end
            i_link=i_link+1;
        end
    end
   
end