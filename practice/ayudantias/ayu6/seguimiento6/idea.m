clear;clc
beta =0.96;
alpha=0.4;
x0=10;
c0= 1.5:1.5:6; %desde 1.5 a 6 con espaciado 1.5
T = 10;

dim1 = size(c0,1);
dim2 = size(x0,2); % En este problema solo tengo una A posible 

cons = repmat(c0,1,dim2); % arreglo de niveles de consumo
x = repmat(x0,dim1,1); % para cada nivel de consumo para cada A
V1(:,T+1)=0; % Value function ultimo periodo 0

copt = NaN(1,T);


for t = T:-1:1
V= log((x-cons).^alpha) + beta.*V1(:,t+1)'; %u(s-c2)+ beta u(c2), beta multiplica de 1 a uno
%zone = min(min(V)) -1;
%V = (zone).*(cons > x) + V.*(cons <= x); % prevenir esquemas de ponzi
% Buscar maximo
[V0, cell_opt] = max(V); %[utilidad, la fila donde se ubica el maximo y con eso puedo saber el consumo correcpondiente]
V1(:,t) = V0;
copt(:,t) = c0(cell_opt);  
end

