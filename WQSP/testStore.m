StoreRoom = cell(2,1);
step = 3;
for i = 0:step:1440
    i
    [~,StoreRoom] = cacheValue(i/step,'save',StoreRoom,num2str(i))
    if(i > 0)
        [returnVaule,StoreRoom] = cacheValue(i/step,'fetch',StoreRoom)
    end
end


function [returnVaule,StoreRoom] = cacheValue(i,operation,StoreRoom,data)
% this function use two subcell to save or fetch value.
% When save, it save current value to StoreRoom
returnVaule = 0;
if(strcmp(operation,'save'))
    mod2Result = mod(i,2);
    if(mod2Result == 1)
        StoreRoom{mod2Result} = data;
    else
        StoreRoom{mod2Result + 2} = data;
    end
end
% when fetch, it fetches the oldValue
if(strcmp(operation,'fetch'))
    if(i>0)
        mod2Result = mod((i-5),2);
        if(mod2Result == 1)
            returnVaule = StoreRoom{mod2Result};
        else
            returnVaule = StoreRoom{mod2Result + 2};
        end
    end
end
end