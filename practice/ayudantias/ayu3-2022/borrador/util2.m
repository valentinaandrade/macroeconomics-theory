function util2 = util2(c2, rho, beta, A)
dim1 = size(c2,1);
dim2 = size(A,2);

cons = repmat(c2,1,dim2);
assets = repmat(A,dim1,1);

util2= util(rho, assets - cons) + beta.*util(rho,cons); %u(s-c2)+ beta u(c2), beta multiplica de 1 a uno

zone = min(min(util2)) -1;
util2 = (zone).*(cons > assets) + util2.*(cons <= assets); % prevenir esquemas de ponzi