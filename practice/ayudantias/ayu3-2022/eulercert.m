function F = eulercert(beta,y_1,y_2,r,S)
F=(y_1-S)*beta*(1+r)-(y_2+(1+r)*S); % Error de Euler
end