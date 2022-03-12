function [VL, maxT, minT] = test(i,t)
% Esta funcion construye una muestra en base a variables aleatorias
% definidas por el usuario que da como resultado algunos parámetros
% [VL] = vector columna que indica el tiempo total de compra de cada
% persona
% maxT = la persona y el tiempo que pasó la persona que mas tiempo estuvo
% minT = lo mismo que maxT pero con el minimo
% i = número de personas de la muestra
% t = días que se recopiló la muestra
% Un supuesto clave es que las personas asistieron todos los días al
% supermercado

%% Preallocate
r = i*t;
c = 1;
VL = zeros(r, 1);

%% Variables aleatorias
I = exp(2) + rand(r,c);
B = randn(r,c)*0.3+1;
P = randn(r,c)*0.15+0.2;

%% Matrices
for col = 1
    T = I + B + P; % Crear fila total
    VL(:,col) = T;
end

%%
maxT = max(VL(:,1));
minT = min(VL(:,1));

disp(['El individuo que tardó más, tardó en total ', ...
    num2str(maxT),' minutos. Su posición en la muestra es la posición ', num2str(find(VL == maxT))])
disp(['El individuo que tardó memnos, tardó en total ', ...
    num2str(minT),' minutos. Su posición en la muestra es la posición ', num2str(find(VL == minT))])
end