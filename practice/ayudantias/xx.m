function [xx] = xx(r,c)
% Esta funcion construye una matriz en base a variables aleatorias
% definidas por el usuario donde podemos notar que
% [xx] = xx(r,c) indica la construccion de una matriz donde
% r = numero de filas
% c = numero de columnas

%% Auxiliares
x = rand(r,c);
x_i = randn(r,c);
%%Variables aleatorias
x1 = x*(4-1)+1;
x2 = 0;
for i = 1:3
    x2 = x2 + randn(r,c).^2;
    i = i+1;
end
x3a = 0;
for i = 1:2
    x3a = x3a + randn(r,c).^2;
    i = i+1;
end
x3 = randn(r,c)./sqrt(x3a/2);
x4 = randn(r,c)*1.5 + 5;
x5a = rand(r,c);
x5 = zeros(r,c);
for i=1:r
    if x5a(i,1) < 0.5
        x5(i,1) = x3(i,1);
    else x5(i,1) = x4(i,1);
    end
    i = i+1;
end
error = x_i*0.0001;
x6 = 0.5*(x4+x5)+error;

xx = [x1 x2 x3 x4 x5 x6];
end