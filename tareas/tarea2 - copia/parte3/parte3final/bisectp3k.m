function [r_eq,lt_activos_bar,error] = bisectp3k(a,b,mt)
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
T=65; 
beta = 0.96;
sigma = 2;
alpha = 1/3;
delta = 0.1;
% mt = 1/T;
tol=10^(-2);
error=1;

%Grilla para Restricciones de Liquidez
% r_eq=zeros(1,length(g));

% for i=1:length(liq)

error=1;
%a = 0.01
%b = 0.1
r_0=a;r_1=b;
iter = 0;
liq = 100;

    while  tol<error

    r_bar=(r_1+r_0)/2;
    
    
        [~,~,~,~,lt_activos_0,~,~,y1]=fisher(T, sigma, beta,r_0,liq);
        oa_0=sum(mt.*lt_activos_0(1:T));
        Lbar1 = mt.*sum(y1);
        kk_0= ((alpha)./(r_0+delta)).^(1/(1-alpha))*Lbar1;
        e0 = (oa_0 - kk_0)/kk_0;
        
        % kk_0=(alpha/(r_0+delta))^(1/(1-alpha))*sum(mt.*gamma);
        % Of_Activos_0 = (oa_0-kk_0)/kk_0;

         [~,~,~,~,lt_activos_bar,~,~,y2]=fisher(T, sigma, beta, r_bar, liq);
         oa_bar=sum(mt.*lt_activos_bar(1:T));
         Lbar2 = mt.*sum(y2);
         kk_2= ((alpha)./(r_bar+delta)).^(1/(1-alpha))*Lbar2;
         ebar = (oa_bar - kk_2) /kk_2;
            
        %     kk_bar=(alpha/(r_bar+delta))^(1/(1-alpha))*sum(mt.*gamma);
        %     Of_Activos_bar = (Of_Activos_bar-kk_bar)/kk_bar;
            error=abs(ebar);

        if sign(ebar)==sign(e0)
%             r_1=r_bar;
            r_0 = r_bar;
            
        else
            r_1 = r_bar;

        end
        
        iter = iter + 1;
        if iter == 50
            break
        end

    end

disp('Terminado')

r_eq=r_bar;

