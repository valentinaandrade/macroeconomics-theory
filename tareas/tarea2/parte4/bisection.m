function [r_eq, lt_activos_bar, lt_consumo,lt_labor] = bisection(a,b,liq)
%UNTITLED3 Summary of this function goes here
T=65; 
beta = 0.96;
varphi = 1.2;

tol=10^(-1);
error=1;
a=-0.06;f=0.1;%Intervalo [a,b]
liq=linspace(0,9,10);%Grilla de restricciones de liquidez
% Preallocar
r_eq=zeros(1,length(liq));%Grila de tasas de equilibrio.
lt_labor=zeros(length(liq),T+1);
lt_consumo=zeros(length(liq),T);
correlation=zeros(length(liq),1);


for i=1:length(liq)
error=1;
r_0=a;r_1=f;

[~, ~, ~, ~, lt_activos_0, ~, ~, ~,~]=labor(T, varphi, beta, r_0, liq(i));
oa_0=sum(lt_activos_0)/T;

    while  tol<error
    r_bar=(r_1+r_0)/2;

    [~, ~, ~, ~, lt_activos_bar, lt_consumo_bar, lt_labor_bar, ~,~]=labor(T, varphi, beta, r_0, liq(i));
    oa_bar=sum(lt_activos_bar)/T;
    error=abs(oa_bar);

        if sign(oa_bar)~=sign(oa_0)
            r_1=r_bar;    
        else
            r_0=r_bar;
        end

    end
disp('Solucion encontrada')

r_eq(1,i)=r_bar;
lt_consumo(i,1:T)=lt_consumo_bar;
lt_labor(i,:)=lt_labor_bar;
end
