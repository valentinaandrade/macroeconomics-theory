% Tarea 2 - Parte 4 ----------------------------------------------------
clear; close all; clc
% 0. Parametros-----------------------------------------------------------
beta = 0.96; % Impaciencia
T = 65; % Horizonte temporal
sigma = 2; % Elastic of intertermporal substitution (IES).
liq = 8;% Si mi restriccion de liquidez es b = 100 no es activo
alpha = 1/3;
delta = 0.1;
varphi= 1.2;
% Es como si quisiera negativo pirque quiero mas ocio, pero tengo la
% restriccion entonces se pone cero
% No es necesario que  w sea un parametro de labor pues es la misma funcion
%% o.1 Adicional para ver sin restricciones 
a=0;b=0.1;
[r_eq, ~,~, ~, ~, ~]=equilibrio(a,b,liq);
[vt, Api, Apf, Cpf, lt_activos, lt_consumo, lt_labor, lt_ahorro,y] = labor(T,varphi,beta,r_eq,liq);

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
plot(y)
title('Trayectoria salarial')


%% o2. Tasa de equilibrio, usando el algoritmo de biseccion para diferentes restricciones de liquidez
% Grafique un subplot que muestre (1) consumo, (2) activos, (3) tasa
% equilibrio (4) oferta laboral,  (5) la correlación consumo - ingreso en función de la
% restricción8 de liquidez (5) oferta laboral agregada. Explique la intuición económica.
a=0;
b=0.1;%Intervalo [a,b]
liq=linspace(0,9,10);%Grilla de restricciones de liquidez
[r_eq, lt_consumo, lt_laboral, lt_activos, ol, correlacion]=equilibrio(a,b,liq);

% Figuras 
figure;
sgtitle('Equilibrio general con restriccion de liquidez','FontSize', 20)
subplot(3,2,1)
p = plot(1:T+1,lt_activos);
xlabel('T')
title('Trayectoria optima de activos')
legend([p(1) p(10)],'Restriccion activa','Restriccion no activa', 'Location','best');

 
subplot(3,2,2)
p=plot(1:T,lt_consumo); % saque ingresos pues como es endogena ni se nota
xlabel('T')
title('Trayectoria de consumo')
legend([p(1) p(10)],'Restriccion activa','Restriccion no activa', 'Location','best');


subplot(3,2,3)
p = plot(1:T,lt_laboral(:,1:end-1)); % saque ingresos pues como es endogena ni se nota
xlabel('T')
title('Trayectoria laboral')
legend([p(1) p(10)],'Restriccion activa','Restriccion no activa','Location','best');

subplot(3,2,4)
plot(liq,r_eq)
xlabel('Restriccion endeudamiento')
title('Tasa interes de equilibrio')

subplot(3,2,5)
plot(liq, correlacion)
xlabel('Restriccion endeudamiento')
title('Correlacion entre consumo e ingreso')

subplot(3,2,6)
plot(ol)
xlabel('T')
title('Oferta laboral agregada')
