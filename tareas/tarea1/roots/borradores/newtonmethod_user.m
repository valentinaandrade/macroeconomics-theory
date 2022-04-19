% Parametros
f = input('Ingresa una funcion');
df = input('Ingresa la derivada de la funcion');
tol = 10^(-4);
x0 = 0;
n = 100;

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
