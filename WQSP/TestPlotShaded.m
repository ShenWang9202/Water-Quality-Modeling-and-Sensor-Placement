% TestPlotShaded

x = 1:10;
y = [];
for i = 1:3
    y = [y; rand(1,10)]
end

figure
% plotShaded(x, y)

x=[-10:.1:10];
plotShaded(x,[sin(x.*1.1)+1;sin(x*.9)-1],'r');