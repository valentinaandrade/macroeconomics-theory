function [MM] = fignewton(f, N, a, b)

% Función que permite integrar numéricamente con un enfoque de Newton-Cotes
% a partir de la regla del Trapecio y Simpson para conjuntos cerrados
% A partir de esta función obtenemos como resultado la estimación de la
% integral en base a los siguientes parámetros
% f = es la funcion. Se debe ingresar como @(x) 
% N = numero de nodos
% a = limite inferior
% b = limite superior

%% Parametrizacion
trueval = 0.4500;

TP = zeros(N,1);
SIM = zeros(N,1);
err1= zeros(N,1);
err2 = zeros(N,1);
MM = zeros(N,4);
for it = 1:N+1
    % samplePoints
    MM = [TP SIM  err1  err2];

    [TP(it),SIM(it), err1(it), err2(it)]  = intnewton(f,it, a , b);
  
end
end
