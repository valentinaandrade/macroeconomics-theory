function F = EulerA(Beta,Alpha,y_1,y_2,r,S)
F=y_1-S-Alpha-Beta*(1+r)*(y_2+(1+r)*S-Alpha); % Error de Euler
end