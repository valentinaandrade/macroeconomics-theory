function F = EulerB(Beta,Alpha,y_1,y_2,r,S)
F=-Alpha*(y_1-S)-(log(Beta*(1+r))-Alpha*(y_2+(1+r)*S)); % Error de Euler
end