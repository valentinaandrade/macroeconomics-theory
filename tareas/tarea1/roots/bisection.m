function [xn, epsilon] = bisection(f,a,b)
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
% Punto intrmedio del n-ésimo intervalo computado por el método de
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
tol=10^(-4); % tolerancia

%% Step 5. Return midpoint value r_n = (a_n + b_n) /2


if f(a)*f(b) >= 0
    disp('Método de biseccion falla');
else
 % Preallocate 
    a0 = a;
    b0 = b;
    n= 100; % semilla iterativa
    epsilon = 0.05; % error semilla
% Algoritmo biseccion     
while epsilon > tol
  for n = 1:n+1
      r0 = (a0 + b0)/2;
    if f(a0)*f(r0) < 0
        b0 = r0;
    elseif f(b0)*f(r0) < 0
        a0 = r0;
    elseif f(r0) == 0
     %disp('Solución exacta encontrada');
    else
     disp('Metodo de biseccion falla');
    end
    xn = (a0 + b0)/2;
    epsilon = (b0-a0)/2^(n+1);
   end
end
 disp(['Solucion: ',num2str(xn),'  Error: ',num2str(epsilon)]) 
end

   