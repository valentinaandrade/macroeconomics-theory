%GenerateData
%
%GenerateData(alpha,beta,N)
%
%alpha: y-intercept
%beta: slope
%N: number of points
function GenerateData(alpha,beta,N)

x=[1:1:N]';

y=alpha + beta * x + randn(N,1);
%y=alpha + beta * x ;

save data x y

figure(1);
plot(x,y,'b',x,alpha+x*beta,':r')