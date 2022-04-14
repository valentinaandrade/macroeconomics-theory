function [xx] = xx(r,c)
% Esta funcion construye una matriz en base a variables aleatorias
% definidas por el usuario donde podemos notar que
% [xx] = xx(r,c) indica la construccion de una matriz donde
% r = numero de filas (observaciones) de igual tamaño de la muestra
% c = numero de muestras

%% Auxiliares
x = rand(r,c);
x_i = randn(r,c);
%%Variables aleatorias
x1 = x*(8-1)+1;

x2 = x_i*4 + 3;

x3 = 100*(x_i.^2);

x4a = 0;
for i = 1:2
    x4a = x4a + randn(r,c).^2;
    i = i+1;
end

x4 = x_i./sqrt(x4a/2);

x5 = zeros(r,c);

for i = 1:r
    if x (i,1) < 0.5
        x5(i,1) = x2(i, 1);
    else x5 (i) = x3(i,1);
    end
    i = i+1;
end

error = x_i* 0.1;
x6 = (x4+x5)/2 + error;

y = x + exp(0.6);

epsilon = x_i;

xx = [x1 x2 x3 x4 x5 x6];
end