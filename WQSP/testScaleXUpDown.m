% x = xx_estimated(:,2);
% scalex = scaleUpDown(x,25);
% figure;
% subplot(2,1,1)
% plot(x);
% subplot(2,1,2)
% plot(scalex)

len = length(XX_estimated)
newXX = [];
for i = 1:len
    x = XX_estimated(:,i);
    x_scaled = scalePipeSegment(x,IndexInVar,aux,ElementCount);
    newXX = [newXX x_scaled];
end
figure
imagesc(XX_estimated)
figure
imagesc(newXX)
% x = XX_estimated(:,300);
% x_scaled = scalePipeSegment(x,IndexInVar,aux,ElementCount);
% figure;
% subplot(2,1,1)
% plot(x);
% subplot(2,1,2)
% plot(x_scaled)

