function [C] = costs(w,r,x)
% Cost production froma Cobb Dogulas production fuction with Capital (K) and
% Labor (L), defined in reduced form X = [L,K]. We model costs production
% considering prices of both gods (wages and real interest). 
% w = wages defined by a normal schedule (more of 160 hours are considered in different form) 
% r = real interest (price of capital)
% x = cobb douglas function production defined by L and K
if x(1) < 160
    wage = w;
else
    wage = w*1.5;
end
C = x(1)*wage + x(2)*r;
end