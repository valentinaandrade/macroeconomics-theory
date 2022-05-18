function [xn, epsilon] = bisection(a,b, liq)
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


% Step 1. Choose a starting interval
%in = [a,b]; % Interval
%a0=in(1); % a0 -> f(a0)
%b0=in(2); % b0 -> f(b0)
%% Such that f(a0) f(b0) <0

% Step 2. Compute a midpoint
%r0 = (a0+b0)/2 % \bar{r}

% Step 3. Determine the next subinterval [a1,b1]
%% a. If f(a0)f(b) >= 0, then bisection method fails
%% a. If f(a0)f(r0) < 0, then let [a1,b1] be the next interval a1= a0, and b1=r0
%% b. If f(b0)f(r0) < 0 (or else in the other case), then let [a1,b1] be the next interval a1=r0, b1=b0

%% Step 4. Repeat 2 and 3 until the interval [an, bn] reachers some predetmined lenght tolerance 
tol=10^(-5); % tolerancia

%% Step 5. Return midpoint value r_n = (a_n + b_n) /2
% 0. Parametros-----------------------------------------------------------
beta = 0.96; % Impaciencia
T = 65; % Horizonte temporal
sigma = 2; % Elastic of intertermporal substitution (IES).
alpha = 1/3;
delta = 0.1;
% Trayectoria por edad como handle function  y luego dentro de fischer se multiplica por salario ---------
mt = 1/T;

% a
[~,~, ~, ~,lt_activos_a, ~,~,gammat_a,~] = fisher(T, sigma, beta,a,liq); % Aquí se rellena la trayectoria optima
oa_a = sum(mt.*lt_activos_a);
ok_a = sum(mt.*((alpha)./(a+delta)).^(1/(1-alpha)).*gammat_a);% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
f_a =(oa_a-ok_a)/ok_a;

% b
[~,~, ~, ~,lt_activos_b, ~,~,gammat_b,~] = fisher(T, sigma, beta,b,liq); % Aquí se rellena la trayectoria optima
oa_b = sum(mt.*lt_activos_b);
ok_b = sum(mt.*((alpha)./(b+delta)).^(1/(1-alpha)).*gammat_b);% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
f_b=(oa_b-ok_b)/ok_b;

% Midpoint r0
r0 = (a + b)/2;
[~,~, ~, ~,lt_activos_r0, ~,~,gammat_r0,~] = fisher(T, sigma, beta,r0,liq); % Aquí se rellena la trayectoria optima
oa_r0 = sum(mt.*lt_activos_r0);
ok_r0 = sum(mt.*((alpha)./(r0+delta)).^(1/(1-alpha)).*gammat_r0);% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
f_r0=(oa_r0-ok_r0)/ok_r0;

if f_a*f_b >= 0
    disp('Método de biseccion falla');
else
 % Preallocate 
    n= 120; % semilla iterativa
    epsilon = 1; % error semilla
% Algoritmo biseccion     
while epsilon > tol
  for n = 1:n+1
    if f_a*f_r0 < 0
        b = r0;
    elseif f_b*f_r0 < 0
        a = r0;
    elseif f_r0 == 0
     disp('Solución exacta encontrada');
    else
     disp('Metodo de biseccion falla');
    end
    xn = (a + b)/2;
    epsilon = (b-a)/2^(n+1);
   end
end
 disp(['Solucion: ',num2str(xn),'  Error: ',num2str(epsilon)]) 
end

   