function [TP,SIM, err1, err2] = intnewton(f, N, a, b)
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
h = (b-a)/N;

%% Trapacio 
sum = 0;

for i = 1:N-1
    sum = sum + f(a+ i*h);
end
TP = (h/2)*(f(a) + 2*sum + f(b)) ; 
fprintf('Result using trapezoidal rule is:  %.6f\n', TP)


%% Simpson
sum1 = 0;
for j = 1:2:N-1
    sum1= sum1 + f(a + j*h);
end
sum2= 0 ;
for k =  2:2:N-2
    sum2 = sum2 + f(a + k*h);
end
SIM = (h/3)*(f(a) + 4*sum1 + 2*sum2 + f(b));
fprintf('Result using 1/3rd Simpson rule is:  %.6f\n', SIM)


%% Errors
err1 = abs(trueval - TP);
err2 = abs(trueval - SIM);



end


