function util2 = util2(c2, rho, beta, A)


dim1 = size(c2,1);
dim2 = size(A,2); % En este problema solo tengo una A posible 

cons = repmat(c2,1,dim2); % arreglo de niveles de consumo
assets = repmat(A,dim1,1); % para cada nivel de consumo para cada A

%util2=util(rho, repmat(A,1,dim2)-c) + beta.*util(rho,c2);
util2= util(rho, assets - cons) + beta.*util(rho,cons); %u(s-c2)+ beta u(c2), beta multiplica de 1 a uno
%% En el valor de manana tengo util c2

zone = min(min(util2)) -1;
util2 = (zone).*(cons > assets) + util2.*(cons <= assets); % prevenir esquemas de ponzi