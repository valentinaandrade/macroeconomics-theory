% Tarea 2 - Parte 4 ----------------------------------------------------
% Valentina Andrade ----------------------------------------------------
clear; close all; clc
% 0. Parametros-----------------------------------------------------------
beta = 0.96; % Impaciencia
T = 65; % Horizonte temporal
sigma = 2; % Elastic of intertermporal substitution (IES).
liq = 100;% Si mi restriccion de liquidez es b = 100 no es activo
alpha = 1/3;
delta = 0.1;
varphi= 1.2;
r = 0.05;
% No es necesario que  w sea un parametro de labor pues es la misma funcion
[vt, Api, Apf, Cpf, lt_activos, lt_consumo, lt_labor, lt_ahorro,y] = labor(T,varphi,beta,r,liq);


figure;
subplot(2,2,1)
plot(lt_activos)
title('Trayectoria de activos')
subplot(2,2,2)
plot(lt_consumo)
title('Trayectoria de consumo')
subplot(2,2,3)
plot(lt_labor)
title('Trayectoria de trabajo')
subplot(2,2,4)
plot(lt_ahorro)
title('Trayectoria de ahorro')




%% k. Tasa de equilibrio, usando el algoritmo de biseccion para diferentes restricciones de liquidez
% Grafique un subplot que muestre (1) consumo, (2) activos, (3) tasa
% equilibrio (4) oferta laboral,  (5) la correlación consumo - ingreso en función de la
% restricción8 de liquidez (5) oferta laboral agregada. Explique la intuición económica.
a = -0.06; %r(1)
b = 0.09;%r(10)
liq = linspace(0,9,10);

for i = 1:length(liq)
[r_eq, ~]=bisection_bueno(a,b,liq); % r endogena
[~, ~, ~, ~, lt_activos, lt_consumo, lt_labor, lt_ahorro,y] = labor(T,varphi,beta,r,liq);
end

correlation = zeros(length(liq),1);
for i =1:length(liq)
aux= corrcoef(omega(i,1:end), lt_consumo(i,:));
correlation(i) =aux(2,1);
end

%% Figuras 
figure;
sgtitle('Equilibrio general','FontSize', 20)
subplot(2,2,1)
p = plot(1:T+1,lt_activos(:,1:end));
xlabel('T')
title('Trayectoria optima de activos')
 
subplot(2,2,2)
plot(1:T,lt_consumo, 1:T, omega(end,:), ':') % saque ingresos pues como es endogena ni se nota
xlabel('$T$')
ylabel('Trayectoria de consumo')
legend('Trayectoria consumo $c_t$', 'Evolucion salarial $\omega\cdot \gamma_t$')

subplot(2,2,3)
plot(liq,r_eq)
xlabel('Restriccion endeudamiento')
ylabel('Tasa interes de equilibrio')

subplot(2,2,4)
plot(liq, correlation)
xlabel('Restriccion endeudamiento')
ylabel('Correlacion entre consumo e ingreso')
