 
% problem setup
for n=1:1:40 % Number of steps
a=0; % Lower limit of integral
b=pi; % Upper limit of integral
TrueVal = ((-b*cos(b)+sin(b))-(-a*cos(a)+sin(a))); % Exact value of integral
h = (b-a)/n; % Step size
xVec = a:h:b;
fVec = myfunInt4(xVec);
Iinterval = zeros(n,1);
% Trapezoidal Rule
    I_trap1 = h/2*(fVec(1)+2*sum(fVec(2:n))+fVec(n+1));
    err1(n) = abs(TrueVal-I_trap1);
    
% Simpson1/3 Rule
    I_simp1 = h/3*(fVec(1)+4*sum(fVec(2:2:end-1))+2*sum(fVec(3:2:end-2))+fVec(n+1));
    err2(n) = abs(TrueVal-I_simp1);
%  Simpson3/8 Rule
sigma1=0;
sigma2=0;
sigma3=0;
for j=2:3:n-1
    sigma1=sigma1+(3*fVec(j));
end
for k=3:3:n
    sigma2=sigma2+(3*fVec(k));
end
for l=4:3:n
    sigma3=sigma3+(2*fVec(l));
end
    I_simp2=(3*h/8)*(fVec(1)+sigma1+sigma2+sigma3+fVec(n+1));
    err3(n) = abs(TrueVal-I_simp2);
end
% display results
disp('Trapezoidal Rule');
disp(I_trap1);
disp(['for h = ', num2str(h), ',Error=', num2str(err1(n))]);
disp('Simpson1/3 Rule');
disp(I_simp1);
disp(['for h = ', num2str(h), ',Error=', num2str(err2(n))]);
disp('Simpson3/8 Rule');
disp(I_simp2);
disp(['for h = ', num2str(h), ',Error=', num2str(err3(n))]);
% Plotting Graph
plot(1:n,err1,'-r*')
hold on
plot(1:n,err2,'-bo')
hold on
plot(1:n,err3,'-gd')
title('plot of f(x)=xsin(x) integtate 0 to pi');
xlabel('Step Size');
ylabel('Error');
grid on
legend('Trapezoidal Rule','Simpson1/3 Rule','Simpson3/8 Rule');