function delta_t = MakeDelta_tAsInteger(delta_t)
MinInSecond = Constants4Concentration.MinInSecond;
if(delta_t<1)
    temp = 1./findDivisorofN(6000);
    minIndex = min(find(temp <= delta_t));
    if(~isempty(minIndex))
        delta_t = temp(minIndex);
    else
        disp('too small timestep')
    end
elseif(delta_t <MinInSecond )
    Divisor = [];
    divisorof60 = findDivisorofN(MinInSecond);
    Divisor = [Divisor divisorof60];
    for i = 1:10
        temp_divisorof60 = divisorof60*1.0/i;
        temp_divisorof60 = temp_divisorof60(find(temp_divisorof60>=1));
        Divisor = [Divisor temp_divisorof60];
    end
    Divisor = sort(Divisor);
    maxIndex = max(find(Divisor <= delta_t));
    delta_t = Divisor(maxIndex);
else
    delta_t = MinInSecond;
end
end