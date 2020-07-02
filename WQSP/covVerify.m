
load('ThreeNodeSystemMatrix')
[mX,nX] = size(x0);
Np = 10;
y=randn(mX,1); 
var(y)
y=y./std(y); 
y=y-mean(y); 
muY = 0;
varY = 1;
y=muY + sqrt(varY) .* y;
yNew = y*y';
mean(yNew)
%y = [x0 y];
covY = cov(y);
inv_cov = inv(covY);



var(y)
var(x0)
var([x0 y])
cov([x0 y])
cov([x0 x0])
cov(x0)
result = [];
for i = 1:1440
    result = [result cov(XX_estimated(:,i))\1];
end
figure
stairs(result)



cov(y)