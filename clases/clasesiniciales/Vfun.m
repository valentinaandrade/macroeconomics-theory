function Vfun = Vfun(Wp, rho, beta, A, Vp)
dim1 = size(Wp,1);
dim2 = size(A,2);
assets_future = repmat(Wp,1,dim2); % Wp con %dim colums
assets = repmat(A,dim1,1);

Vfun= util(rho,assets-assets_future)+beta.*repmat(Vp,1,dim2);
% En el valor de manana tengo Vp

zone = min(min(Vfun))-1000; %min min para escalar, porque -1000?
Vfun = (zone).*(assets_future>assets)+Vfun.*(assets_future<=assets);