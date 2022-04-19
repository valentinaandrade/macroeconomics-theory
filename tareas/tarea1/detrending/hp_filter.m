function [ytrend,ycycle]=hp_filter(y,lambda)
% Este programa ejecuta un filtro HP estándar utilizando una matriz dispersa
% Entrada:
% ------------
% y = una matriz de datos Txn, donde T es el número de observaciones sobre n variables
% (es decir, se supone que los datos están en formato de columnas). Además, se supone que T>4
%
% lambda = un escalar. Se trata de un parámetro de suavización. Opcional: si no se introduce,
% se utilizará un valor por defecto de 1600.
%
% Salida:
% ---------------
% ytrend = una matriz (T-discard)xn de tendencias extraídas para cada una de las n variables.
% ycycle = una matriz (T-discard)xn de desviaciones de las tendencias extraídas para
% cada una de las n variables. Opcional.
%
% El filtro HP encuentra una serie {ytrend_t}_{t=1}^T para
% cada n que resuelve el siguiente problema de minimización
% 
% min sum_{t=1}^T(y_t-ytrend_t)
% +lambda*sum_{t=2}^{T-1}[(ytrend_{t+1}-ytrend_{t})-(ytrend_{t}-ytrend_{t-1})]
%
%Reformando las condiciones de primer orden se obtiene
% A*tendencia=y
%donde
% A=[   1+lambda    -2*lambda       lambda        0               0           0 ...
%     [    -2*lambda   1+5*lambda   -4*lambda       lambda       0           0 ...
%     [    lambda       -4*lambda        1+6*lambda   -4*lambda  lambda  0 ...
%     [                                         ...
%     [    0      ...   0   lambda       -4*lambda        1+6*lambda   -4*lambda  lambda 0  ... 0]
%     [                                         ...
%     [  0   ...    lambda       -4*lambda        1+6*lambda  -4*lambda  lambda]
%     [  0   ...           0     lambda  -4*lambda       1+5*lambda      -2*lambda ]
%     [  0   ...           0       0        lambda              -2*lambda         1+lambda]
%
%   Revise: Hodrick, R.J. and E.C.Prescott (1997), "Postwar U.S. Business Cycles:
%   An Empirical Investigation." Jounal of Money, Credit and Banking.
%   29(1), Feb. pp. 1--16.

%%%%%%

if nargin < 2,  lambda = 1600; end %Si el usuario no ha proporcionado un valor para lambda, se establece el valor por defecto 1600
[T,n] = size (y);% Calcular el número de períodos y el número de variables de la serie



%Calculos
x1=[1+lambda, -2*lambda, lambda];  %Los elementos no nulos de la primera fila de A
x2=[-2*lambda, 1+5*lambda, -4*lambda, lambda]; %Los elementos no nulos de la segunds fila de A
x3=[lambda, -4*lambda, 1+6*lambda, -4*lambda, lambda]; %Lo mismo pero de j'th fila de A, 2<j<T-2
x2rev=x2(end:-1:1); %Los elementos no nulos de la penúltima fila de A (sólo x2 al revés)
x1rev=x1(end:-1:1); %Los elementos no nulos de la última fila de A (sólo x1 al revés)

%Hacer una lista (un vector de columnas) que contenga en la posición i la fila del i's elemento distinto de cero en A 
I=3:T-2;
I = I(ones(1,5),:);
I=I(:);
I=[1; 1; 1; 2; 2; 2; 2;I;T-1;T-1;T-1;T-1;T;T;T];

%Hacer una lista (un vector de columnas) que contenga en la posición i la columna del i's elemento distinto de cero en A 
J=1:T-4;
J = J(ones(1,5),:);
J=J(:);
Temp=0:4;
Temp=Temp(ones(1,T-4),:).';
Temp=Temp(:);
J=J+Temp;
J=[1;2;3;1;2;3;4;J;[T-3:1:T]';[T-2:1:T]'];

%hacer una lista (un vector de columnas) que contenga en la posición i el i's elemento no nulo de A 
X=x3(ones(1,T-4),:).';
X=X(:);
X=[x1';x2';X;x2rev';x1rev'];
 
%Construye la matriz A y resuelve el sistema A*tendencia=y
ytrend=sparse(I,J,X)\y;


if nargout==2 % Para obtener el ciclo o segunda salida
    ycycle=y-ytrend; %El segundo resultado serán las desviaciones de la tendencia HP
end

end