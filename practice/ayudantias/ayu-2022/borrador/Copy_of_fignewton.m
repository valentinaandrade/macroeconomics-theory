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
h = (b-a)/N;
trueval = 0.4500;

for it = 1:2:N
%% Trapecio
sum = 0;

for i = 1:N-1
    sum = sum + f(a+ i*h);
end
TP(N) = (h/2)*(f(a) + 2*sum + f(b)) ; 


%% Simpson
sum1 = 0;
for j = 1:2:N-1
    sum1= sum1 + f(a + j*h);
end
sum2= 0 ;
for k =  2:2:N-2
    sum2 = sum2 + f(a + k*h);
end
SIM(N) = (h/3)*(f(a) + 4*sum1 + 2*sum2 + f(b));

err1 = abs(trueval - TP);
err2 = abs(trueval - SIM);
MM = [TP SIM err1 err2] ;


numSamplePoints = N;
TP = zeros(numSamplePoints,1);
SIM = zeros(numSamplePoints,1);
for samplePoints = 1:numSamplePoints
    % samplePoints
    [TP(samplePoints) SIM(samplePoints)]  = intnewton(f,samplePoints, 0 , 1);
    err1(samplePoints) = abs(trueval - TP(samplePoints));
    err2(samplePoints) = abs(trueval - SIM(samplePoints));
end

end
end
