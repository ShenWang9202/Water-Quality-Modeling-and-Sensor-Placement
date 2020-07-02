function scaledX = scaleUpDown(x,newDimension)
% this function scale a vector x to the newDimesion
% the imput x must be in vector form

[row,~] = size(x);
lcmValue = lcm(row,newDimension);
seg_x = lcmValue / row; % 3
seg_y = lcmValue / newDimension; % 2

scaledX = zeros(newDimension,1);

lcmX = repmat(x, [1,seg_x]);
lcmX = reshape(lcmX',[seg_x*row,1]);

if(seg_y == 1)
    scaledX = lcmX;
else
    for i = 1:newDimension
        rowVector = ((i - 1) * seg_y + 1): (i * seg_y);
        scaledX(i,1) = mean(lcmX(rowVector,:));
    end
end



end