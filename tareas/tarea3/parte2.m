%% Parte 2 ---------------------------------------------------------------
% Ausencia de gobierno y equilibrio general--------------------------------
clear; close all; clc
rng; % Controlar reproducibilidad
% 0. Parametros ---------------------------------------------------------
rho = 0.96; % Persistencia
sigma_mu = 0.12; % Volatilidad
delta = 0.05; % Depreciacion
alpha = 0.33; % Complementariedad K y L
n_e = 5; % Numero de estados posibles de productividad
A = linspace(0,30,1001); % Grilla de activos, parte de cero, sin endeudamiento

%% (h) Grafique la oferta agregada de activos A y demanda agregada de capital K en función de la tasa de interés.
% Para obtener los siguientes valores ver CPO en el informe
% 1.  Sabemos que la tasa de interes de equilibrio es la que iguala A con K. 
% Utilizaremos una grilla de tasa de interes
r = linspace(0, 0.08, 10);
w= (1- alpha).*((alpha)./(r+delta)).^(alpha/(1-alpha));
for i = 1:length(r)
[ct, at, s, v1,pos, panel_shocks, lt_consumo, lt_activos(:, :, i)] = bellman2(r(i),w(i), sigma_mu,rho);
AA(1,i) = mean(lt_activos(:,end,i));
end

% Agregados
% 2. L  promedio simple del nivel de productividad de los agentes en el último periodo (estado estacionario).
L = mean(panel_shocks(:,end));
% Demanda de K desde las CPO
K = ((alpha)./(r+delta)).^(1/(1-alpha))*L;
%3. Promedio simple del estado estacionario de A para computar la oferta agregada de activos de la economía.
% AA
%  Recuerde endogenizar w

% Figura
figure;
plot(AA,r,K,r)
xlabel('$r$')
xlim([0,29])
title('Equilibrio mercado de capitales')
legend('Oferta activos $a_{t+1}$', 'Demanda capital $K$')

%% (i) Tasa de interes de equilibrio ------------------------------------
% Usaremos algoritmo de biseccion, igual que en tarea 2
r1=0.035;r0=0.02
