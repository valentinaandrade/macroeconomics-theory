function [vector, modelos] = matriz_2(r,c, modelo)
% Esta funcion construye una matriz en base a variables aleatorias
% definidas por el usuario donde podemos notar que
% [vector,todos] = matriz_2(r,c,modelo) indica la construccion de una matriz donde
% r = numero de filas
% c = numero de columnas
% modelo = numero de modelo

%% Auxiliares
x = rand(r,c);
i = [1:4];
x_i = randn(r,c);
%%Variables aleatorias
x1 = x*(4-1)+1;
x2 = x_i.^2+x_i.^2+x_i.^2;
lambda=1.1;
x3 = -(1/lambda)*log(1-x_i);
x4=x_i./((x_i.^2+x_i.^2)/2).^(1/2);
modelos = [x1 x2 x3 x4];
disp(['Modelo ',num2str(i(modelo))]);
vector=modelos(:,modelo);
end


