function [xn]=newtonraphson(f, x0)
% Aproximación a la solucion de f(x) = 0 por el método de Newton Raphson.
% Parametros
% -----------
% [f]: funcion
% Funcion a la cual se le buscara la solucion f(x) = 0
% [df]: funcion
% derivada de la funcion
% [x0]: numero
% Guess inicial
% [tol]: numero
% Stop criteria es abs(f(x)) < tol
% [max_iter]: natural
% numero maximo de iteraciones del metodo
% Output
% -----------
% [xn]: aproximacion lineal 


% La funcion finaliza en base a tres caminos
%1. Si abs(f(xn)) < tol, el algoritmo ha encontrado una aproximación a
%la solucion y devuelve xn
%2. Su f'(xn) == 0, el algoritmo se detiene y no devuelve nada
%3. Si el numero de iteraciones excede 'max_iter' entonces el algoritmo se
%detiene y devuelve "Nada"

%Parameters
tol = 10^(-4);
n = 100;
% Process to differentials
syms x
f1 = str2sym(char(f));
df = diff(f1);
df = matlabFunction(df);

% Method
if df(x0) ~= 0
    for i=1:n
        xn = x0 - f(x0)/ df(x0);
        %fprintf('x%d = %.20f\n',i,xn);
        if abs(xn-x0)<tol
            break
        end
    if df(x0) == 0
        disp('Derivada igual a cero. Solucion no encontrada')
    end
    x0=xn;
    end
  else
        disp('Excede el numero maximo de iteraciones. No solucion encontrada')
end
