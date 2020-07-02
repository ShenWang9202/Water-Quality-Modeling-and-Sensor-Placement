        if t<time_step || t==time_step
            i=1;
            for nl=NodeCount
                g=1;
                for j=SpeciesCount
                    value.NodeQuality{i}(k, g)=d.getMSXNodeInitqualValue{(nl)}(j);
                    g=g+1;
                end
                i=i+1;
            end
        else
            i=1;
            for nl=NodeCount
                g=1;
                for j=SpeciesCount
                    value.NodeQuality{i}(k, g)=d.getMSXSpeciesConcentration(0, (nl), j);%node code0
                    g=g+1;
                end
                i=i+1;
            end
        end
