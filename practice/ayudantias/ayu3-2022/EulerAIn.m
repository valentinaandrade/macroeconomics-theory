function F = EulerAIn(Beta,Alpha,r,y_1,y_21,y_22,p,S)
F=y_1-S-Alpha-Beta*(1+r)*(p*y_21+(1-p)*y_22+(1+r)*S-Alpha); % Error de Euler
end