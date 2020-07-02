% function [B BIndex RestVector]= maxk2(A, k)
% Find k largest elements in a Vector A
% B : Vector with all max elements (included repeated) 
% BIndex : idx of max k element 
% RestVector : rest of the elements without max k elements 
function [B BIndex]= mink_my(A, k)
B = 0;
RestVector = A;
sumIndex = 1;
for i=1:k
  MinA = min(A);
  I = A == MinA;
  sumI = sum(I); %To find number of Max elements (repeated) 
  B(sumIndex: sumIndex+sumI-1) = MinA; % to same max elements in B
  BIndex(sumIndex: sumIndex+sumI-1) = find(A == MinA); 
  sumIndex = sumIndex + sumI; 
  A(I) = max(A); % exchange the max elements by a smallest value  
end
%RestVector(BIndex) = [];  % remove largest values

