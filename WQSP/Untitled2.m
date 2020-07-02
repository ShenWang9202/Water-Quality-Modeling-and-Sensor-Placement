clear
load('Debug8NODE.mat')
sigma=1;
nN = numberofNodes;
nPossibleSensor = numberofNodes;
nX = numberofX;

k = numberofStep5mins;
% k =300;
% nX = 90;
% A = sprand(nX,nX,0.1);

% Generate all O for each sensor, and in CO2 case, there are n = 81 sensor
% position
% When we need the O for sensor i and j, we simple add O_i + O_j together (This is a strong conclusion, is this from Equation 19?).
% O = zeros(nX,nX,nPossibleSensor);
O = cell(1,nPossibleSensor);
O1 = [];
O2 = [];
tic
for i=1:1
    I_i= sparse(nX,nX);
    sumTemp = sparse(nX,nX);
    % This I_i is C matrix, and it represent where the sensor is.
    I_i(i,i) = 1;
    %temp = I_i'*I_i; since I_i is diagonal, and the diagonal value is 1;
    %hence I_i'*I_i is the same I_i
    temp = I_i;
    for j=1:k
        % from [0,k]
        sumTemp = sumTemp + temp;
        temp = A'*temp*A;
    end
    O1 = sumTemp;
end
r1 = toc
for i=1:1
    I_i= sparse(nX,nX);
    sumTemp = sparse(nX,nX);
    % This I_i is C matrix, and it represent where the sensor is.
    I_i(i,i) = 1;
    %temp = I_i'*I_i; since I_i is diagonal, and the diagonal value is 1;
    %hence I_i'*I_i is the same I_i
    temp1 = I_i;
    Temp = I_i;
    for j=1:k
        % from [0,k]
        sumTemp = sumTemp + Temp;
        temp1 = temp1*A;
        Temp = temp1'*temp1;
    end
    O2= sumTemp;
end
ZER = O1-O2;
r2 = toc;
r2-r1



%%
A = O1 + speye(len,len);



nX = 5000;
A = sprand(nX,nX,0.1);

fullA = full(A);
fullA = fullA'*fullA;
len = nX;
tic
% eigval = eig(fullA + eye(len,len));
eigval = eig(A'*A + speye(len,len));
for i=1:len
    log_eigval(i)=log(eigval(i));
end

logDetValue1 = sum(log_eigval)
t1 = toc

logDetValue = logdetA(A'*A + speye(len,len))
t2 = toc;
t2 = t2 - t1
