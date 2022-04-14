function F = eulerin(beta,y_1,E_y2,r,S)
F=(y_1-S)*beta*(1+r)-(E_y2+(1+r)*S); % Error de Euler
end