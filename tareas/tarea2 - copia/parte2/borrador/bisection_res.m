function [r_eq, epsilon] = bisection_res(a,b, liq)
% Aproximacion a la solucion de f(x)=0 con el método de biseccion
% Parametros
% ----------
% - [f]: funcion
% Funcion para la cual estamos tratando de aproximar la solucion f(x) = 0
% - [a, b] = numeros
% Intervalo donde se busca la solucion.
% - [N]: un entero positivo
% Numero de iteraciones a implementar
% Notemos que por definicion del teorema, la funcion bisection no devuelve
% nada si f(a)*f(b) >= 0 pues la solucion no está asegurada. 
% Output
% --------
% - [xn] numero
% Punto intermedio del n-ésimo intervalo computado por el método de
% biseccion. El intervalo inicial [a0,b0] esta dado por [a,b].
% - [error]: numero
% Como biseccion es una aproximacion, se estima el error
% Nota: por definicion del teorema, la funcion bisection no devuelve
% nada si f(a)*f(b) >= 0 pues la solucion no está asegurada. 
%We know the solution f(x) = 0 is in the in[a,b] because the Intermediate value theorem
% 0. Parametros-----------------------------------------------------------
a = 0; %r(1)
b = 0.1;%r(10)
liq = linspace(0,7,8);

beta = 0.96; % Impaciencia
T = 65; % Horizonte temporal
sigma = 2; % Elastic of intertermporal substitution (IES).
alpha = 1/3;
delta = 0.1;
r_eq= zeros(1,length(liq));

% Trayectoria por edad como handle function  y luego dentro de fischer se multiplica por salario ---------
mt = 1/T;

% Loop
for i =1:length(liq)
[~,~, ~, ~,lt_activos_a, ~,~,gammat_a,~] = fisher(T, sigma, beta,a,liq(i)); % Aquí se rellena la trayectoria optima
oa_a = sum(mt.*lt_activos_a);
ok_a = sum(mt.*((alpha)./(a+delta)).^(1/(1-alpha)).*gammat_a);% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
f_a =(oa_a-ok_a)/ok_a;
    
    epsilon = 1;
    tol = 10^(-2);
    % Algoritmo biseccion     
    while  tol < epsilon
        r0 = (a + b)/2;
        [~,~, ~, ~,lt_activos_r0, ~,~,gammat_r0,~] = fisher(T, sigma, beta,r0,liq(i)); % Aquí se rellena la trayectoria optima
        oa_r0 = sum(mt.*lt_activos_r0);
        ok_r0 = sum(mt.*((alpha)./(r0+delta)).^(1/(1-alpha)).*gammat_r0);% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
        f_r0=(oa_r0-ok_r0)/ok_r0;

        epsilon = abs(oa_r0);
    
        if sign(oa_r0)~=sign(oa_a)
            b = r0;
        else
            a = r0;
        end
       
    end
    disp(['Solucion encontrada'])
    r_eq(1,i) = r0;
    
end 
end



   