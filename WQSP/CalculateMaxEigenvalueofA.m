function maxMag = CalculateMaxEigenvalueofA(A)
  MaxEigenvalueofA = eig(full(A));
  Magnitude = abs(MaxEigenvalueofA);
  maxMag = max(Magnitude);
end