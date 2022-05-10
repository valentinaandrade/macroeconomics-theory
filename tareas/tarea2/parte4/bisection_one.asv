% Biseccion con solo un valor de liquidez
clear; close all; clc;
T=65; 
beta = 0.96;
varphi = 1.2;

tol=10^(-2);
error=1;
a=0;f=0.1;%Intervalo [a,b]
liq=8;
r_0=a;r_1=f;


[~, ~, ~, ~, lt_activos0, lt_consumo0, lt_labor0, ~,~]=labor(T,varphi,beta,r_0,liq);
oa_0=sum(lt_activos0)/T;

while  tol<error
r_bar=(r_1+r_0)/2;
 
[~, ~, ~, ~, lt_activos_bar, ~, lt_labor_bar, ~,~]=labor(T,varphi,beta,r_bar,liq);
oa_bar=sum(lt_activos_bar)/T;
error=abs(lt_activos_bar);

if sign(oa_bar)~=sign(oa_0)
    r_1=r_bar;    
else
    r_0=r_bar;
end

end

%Evaluamos en tasa de equilibrio y recojemos trayectorias.
[~, ~, ~, ~, lt_activos_bar, lt_consumo_bar, lt_labor_bar, ~,~]=labor(T,varphi,beta,r_bar,liq);
oa_bar=sum(lt_activos_bar)/T;


figure
subplot(2,2,1)
plot(lt_activos_bar,'LineWidth',3),title('Stock de Activos','FontSize',16),ylabel('Nivel Activos','FontSize',13)

subplot(2,2,2)
plot(lt_consumo_bar,'LineWidth',3),title('Trayectoria del Consumo','FontSize',16),xlabel('Consumo','FontSize',13)

subplot(2,2,3:4)
plot(lt_labor_bar(1:65),'LineWidth',3),title('Oferta Laboral','FontSize',16),ylabel('Oferta Laboral','FontSize',13)

