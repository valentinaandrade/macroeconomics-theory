function lastemp =lastemp(N,K,A,alpha,delta,theta)

lastemp = A.*(K.^alpha).*(N.^(1-alpha))+(1-delta).*K...
    -((1-alpha)/theta).*A.*((K./N).^alpha).*(ones(size(K,1),size(K,2))-N);
if N<0
    lastemp = 10+N.^2;
end