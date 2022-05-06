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
beta = 0.96; % Impaciencia
T = 70; % Horizonte temporal
sigma = 2; % Elastic of intertermporal substitution (IES).
alpha = 1/3;
delta = 0.1;
% Trayectoria por edad como handle function  y luego dentro de fischer se multiplica por salario ---------
gamma= @(t) ((40/(0.4*t*(2*pi).^(1/2)))*exp((-1/2)*((log(t)-log(32.5))/0.4).^2)+1);
mt = 1/T;

% Loop 
% a
    [~, gammat_a, lt_activos_a, ~,~,~] = fisher(T, sigma, beta,a,gamma,liq); % Aquí se rellena la trayectoria optima
    oa_a = mt.*sum(lt_activos_a);
    ok_a = mt.*sum(((alpha)./(a+delta)).^(1/(1-alpha)).*gammat_a);% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
    f_a =abs(oa_a-ok_a)/ok_a;
    
    % b
    [~, gammat_b, lt_activos_b, ~,~,~] = fisher(T, sigma, beta,b,gamma,liq); % Aquí se rellena la trayectoria optima
    oa_b = mt.*sum(lt_activos_b);
    ok_b = mt.*sum(((alpha)./(b+delta)).^(1/(1-alpha)).*gammat_b);% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
    f_b=abs(oa_b-ok_b)/ok_b;
    
    epsilon = 1;
    tol = 10^(-3);
    % Algoritmo biseccion     
    while epsilon > tol
        r0 = (a + b)/2;
        [~, gammat_r0, lt_activos_r0, ~,~,~] = fisher(T, sigma, beta,r0,gamma,liq); % Aquí se rellena la trayectoria optima
        oa_r0 = mt.*sum(lt_activos_r0);
        ok_r0 = mt.*sum(((alpha)./(r0+delta)).^(1/(1-alpha)).*gammat_r0);
        f_r0=abs(oa_r0-ok_r0)/ok_r0;
        epsilon = abs((oa_r0-ok_r0)/ok_r0);
    
        if sign(f_a)~=sign(f_r0)
            b = r0;
        else
            a = r0;
        end
       
    end
    r_eq = r0;
    disp(['Solucion: ',num2str(r_eq),'  Error: ',num2str(epsilon)])
  

end


   