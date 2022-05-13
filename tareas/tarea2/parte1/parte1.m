%% Tarea 2 ---------------------------------------------------------------
% Valentina Andrade ------------------------------------------------------
clear; clc; close all
% 0. Parametros
beta = 0.96; % Impaciencia
T = 65; % Horizonte temporal
sigma = 2; % Elastic of intertermporal substitution (IES).
liq = 100;% Si mi restriccion de liquidez es b = 100 no es activo
A = linspace(-15,25,1001)'; % Tienen como deuda maxima -15 y ahorro 25

% Salario como handle function  y luego hacer vector para cada T
w  = @(t) -10^(-3)*t.^2 + 5*10^(-2)*t + 1 ; % se multiplica escalar, entonces voy a ocupar vectores

% Funciones
% - crra: funcion CRRA para utilidad de consumo
% - lifetime: funcion que calcula el ciclo de vida economico de agente 

%% a. Identificar variables de control y estado --------------------------

%% b. Obtener ecuaciones de euler e interpretar --------------------------

%% c. Asumiendo r = (1-beta)/(beta) -------------------------------------
r = (1-beta)/beta;
[vt,~, Ap, Cp,lt_activos, lt_ahorro, lt_consumo] = lifetime(A,T, sigma, beta,r,w,liq);


%% c.1 Obtener subplot que reporte la trayectoria optima de activos, ahorros,
% consumo e ingreso del agente. Interpretar economicamente

figurelifetime(T, w,lt_activos, lt_ahorro, lt_consumo);

%% c.2 grafico adicional
figurepolicy(T, vt, Ap,Cp)

%% d. Cambio en la funcion de salarios
% Salario como handle function  y luego hacer vector para cada T
w2  = @(t) -10^(-3)*t.^2 + 9*10^(-2)*t + 1 ; % se multiplica escalar, entonces voy a ocupar vectores

[vt,~, Ap, Cp,lt_activos, lt_ahorro, lt_consumo] = lifetime(A,T, sigma, beta,r,w2,liq);
figurelifetime(T, w2,lt_activos, lt_ahorro, lt_consumo);

%% e. Discutir con cambio en tasa de interes y sigma
r = [(1-beta)/beta 0.05];
sigma = [2 8];
w  = @(t) -10^(-3)*t.^2 + 7*10^(-2)*t + 1 ; % se multiplica escalar, entonces voy a ocupar vectores

figuremultiple(A,T, sigma, beta,r,w,liq)