function [r_eq, error] = bisection_pob(a,b, liq,g)
% Aproximacion a la solucion de f(x)=0 con el método de biseccion
% Parametros
% ----------
% - [g]: grila tasa crecimiento 
% Funcion para la cual estamos tratando de aproximar la solucion f(x) = 0
% - [a, b] = numeros
% Intervalo donde se busca la solucion.
% - [liq] = restriccion de liquidez
% Output
% --------
% - [r_eq] numero
% Punto intermedio del n-ésimo intervalo computado por el método de
% biseccion. El intervalo inicial [a0,b0] esta dado por [a,b].
% - [error]: numero
% Como biseccion es una aproximacion, se estima el error
% Nota: por definicion del teorema, la funcion bisection no devuelve
% nada si f(a)*f(b) >= 0 pues la solucion no está asegurada. 
%We know the solution f(x) = 0 is in the in[a,b] because the Intermediate value theorem
% 0. Parametros-----------------------------------------------------------
% Trayectoria por edad como handle function  y luego dentro de fischer se multiplica por salario ---------
T=65; 
beta = 0.96;
sigma = 2;
alpha = 1/3;
delta = 0.1;
tol=10^(-2);
g =  linspace(0,0.01,11);
mt = growth(T,g);

%Grilla para Restricciones de Liquidez
r_eq=zeros(1,length(g));

for i=1:length(mt)
error=1;
r_0=a;r_1=b;
[~,~,~,~,lt_activos_0,~,gamma,~]=fisher(T, sigma, beta,r_0,liq);
oa_0=sum(mt(i).*lt_activos_0);
kk_0=(alpha/(r_0+delta))^(1/(1-alpha))*sum(mt(i).*gamma);
f_0 = (oa_0-kk_0)/kk_0;
    while  tol<error
    r_bar=(r_1+r_0)/2;

    [~,~,~,~,lt_activos_bar,~,gamma,~]=fisher(T, sigma, beta, r_bar, liq);
    oa_bar=sum(mt(i).*lt_activos_bar);
    kk_bar=(alpha/(r_bar+delta))^(1/(1-alpha))*sum(mt(i).*gamma);
    f_bar = (oa_bar-kk_bar)/kk_bar;
    error=abs(oa_bar);

        if sign(oa_bar)~=sign(oa_0)
            r_1=r_bar;    
        else
            r_0=r_bar;
        end

    end

disp('Terminado')

r_eq(1,i)=r_bar;
end