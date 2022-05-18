% Tarea 2 - Parte 3 ------------------------------------------------------
clear; clc, close all;
% k. Crecimiento poblacional
T = 65;
sigma = 2; beta= 0.96; alpha =1/3; delta = 0.1;
liq = 100; % Si mi restriccion de liquidez es h = 100 no es activo
g =  linspace(0,0.01,11); % grilla de crecimiento poblacional

% Estimación wt es una matriz de 11 x 65, la dejo comentada porque se
% estimara al interior de la función de bisección modificada:

vg = NaN(length(g),T);
mt = NaN(length(g),T);
for j=1:length(g)
    for s = 1 : T 
        vg(j,s) = (1+g(j))^(T-s);
    end   
    for s = 1 : T
        mt(j,s) = vg(j,s)/sum(vg(j,:));
    end      
end
figure;
p=plot(1:T, mt(:,:));
title('Masa de Agentes segun Crec. Pobl.','FontSize', 13);
xlabel('T')
ylabel('Trayectoria Masa de Agentes')
lgd = legend([p(1), p(length(g))], '$g = 0\%$', '$g = 1\%$')
saveas(gcf,'part3.png')

% Calculando tasa de interes de equilibrio usando algortimo de bisección
% modificado

% insumos algoritmo de bisección
a = 0.04; % r(4)
b = 0.13; % r(13) % Amplio el rango

r_eq=zeros(1,length(g));%Prealocacion
lt_activos_bar=zeros(length(g),T+1);

for i = 1:length(g)
[r_eq(i),lt_activos_bar(i,:), error]=bisectp3k(a,b,mt(i,:)); % r endogena
end
plot(g,r_eq)

figure;
sgtitle('Crec. Poblacional, Tasa de Interes y Activos','FontSize', 13)
subplot(1,2,1)
p=plot(g, r_eq)
title('Tasa y Crec. Poblacional','FontSize', 11)
xlabel('Crec. poblacional')
ylabel('Tasa interes de equilibrio')
subplot(1,2,2)

p=plot(1:T+1, lt_activos_bar(:,1:end))
subtitle('Tray. Optima de Activos','FontSize', 11)
xlabel('T')
ylabel('Trayec. de activos')
lgd = legend([p(1), p(length(g))], '$g = 0\%$', '$g = 1\%$',"Location","southeast")
saveas(gcf,'part3k.png')