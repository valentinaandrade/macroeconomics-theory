%% Tarea 2 - Parte 2 ------------------------------------------------------
clear; close all; clc
% Funciones que se ocupan en este codigo
% - [crra]: funcion CRRA para utilidad de consumo
% - [fisher]: funcion que calcula el ciclo de vida economico de agente
% - [bisection]: funcion para calcular equilibrio
% 0. Parametros-----------------------------------------------------------
beta = 0.96; % Impaciencia
T = 65; % Horizonte temporal
sigma = 2; % Elastic of intertermporal substitution (IES).
liq = 100;% Si mi restriccion de liquidez es b = 100 no es activo
alpha = 1/3;
delta = 0.1;
r = (1-beta)/beta;
% No es necesario que  w sea un parametro de fisher pues es fijo
[vt, Api, Apf, Cpf, ~, ~, ~,~, y] = fisher(T, sigma, beta,r,liq);
figurepolicy(T, vt, Api,Cpf)

%% h. Trayectoria activos y mercado capitales sin restriccion liquidez  -----------------------------------------------------
rdim = 10;
r = linspace(0,0.1,rdim); % desde 0.04 hasta 0.09 divido en 10 entradas (vector 1x10)
lt_activos = NaN(rdim,T+1);   % Trayectoria de activos optima. Tiene dimension rdim pues se calcula para cada r
oa = NaN(1,rdim);     % Oferta agregada de activos
gammat = NaN(rdim,T); % trayecctoria de salarios en fuciond de edad
kk = NaN(1,rdim);     % Oferta agregada de capital

alpha=1/3;
delta=0.1;
z= @(x,mu,sig) 0.4 + 40 *exp(-( (log(x)-mu)/sig ).^2 /2 ) ./(x* sig*sqrt(2*pi));
gamma = z(2:T+1, log(32.5), 0.4);
mt= 1/T;
Lbar = sum(mt*gamma);

tic
for i = 1: rdim
[~,~, ~, ~,lt_activos(i,:), ~,~,gammat(i,:),~] = fisher(T, sigma, beta,r(i),liq); % Aquí se rellena la trayectoria optima
%Cuando se usa  [~,palette], esto significa que solo quieres el segundo output de la funcion.
oa(i) = sum(mt.*lt_activos(i,:));
kk(i) = ((alpha)./(r(i)+delta)).^(1/(1-alpha))*Lbar;% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
end
toc

% Figura subplot ------------------------------------------------------
figure;
sgtitle('Equilibrio general','FontSize', 20)
subplot(1,2,1)
p = plot(1:T+1,lt_activos(:,1:end));
xlabel('T')
title('Trayectoria optima de activos')
lgd= legend([p(1),p(length(r))],'$r = \%$','$r = 10\%$'); 
lgd.Location= 'SouthEast';
 
subplot(1,2,2)
plot(r,oa,r,kk)
xlabel('$r$')
title('Equilibrio mercado de capitales')
legend('Oferta activos $a_{t+1}$', 'Demanda capital $K$')

%% i. Tasa equilibrio -------------------------------------------------
a = 0.01; %Ampliar el intervalo
b = 0.1;  %r(10)
liq = 100;% Si mi restriccion de liquidez es h = 100 no es activo
%rho = @(x) (oa(x)-ok(x))/ok(x); %Sin valor absoluto
[r_eq, error]=bisection_simple(a,b,liq); % r endogena

% i.2  Figuras ---------------------------------------------------------------
%Además, grafique la trayectoria de consumo definida por la tasa de equilibrio junto al ingreso de los agentes
[~,~, ~, ~,~, lt_consumo,~,~,omega] = fisher(T, sigma, beta,r_eq,liq);
figure;
plot(1:T,lt_consumo(1:end),1:T,omega(1:end))
xlabel('$T$')
title(['Equilibrio general $r$ =', num2str(r_eq)])
legend('Trayectoria consumo $c_t$', 'Evolucion salarial $\omega\cdot \gamma_t$')

%% j. Tasa de equilibrio, usando el algoritmo de biseccion para diferentes restricciones de liquidez
% Grafique un subplot que muestre (1) la trayectoria de activos óptima, (2) la tasa de interés de equilibrio, (3)
% la trayectoria de consumo óptima (junto al ingreso) y (4) la correlación consumo - ingreso en función de la
% restricción8 de liquidez. Explique la intuición económica.
a = -0.06; %Se pone negativa solo para que se vea mejor la grafica
b = 0.1;%r(10)
liq = linspace(0,9,10); % Se hace grilla mas grande para que se note mas (recomendacion Pablo)

for i = 1:length(liq)
[r_eq, ~]=bisection(a,b,liq); % r endogena
[~, ~, ~, ~, lt_activos(i,:), lt_consumo(i,:), ~,~, omega(i,:)] = fisher(T, sigma, beta,r_eq(i),liq(i));
end

correlation = zeros(length(liq),1);
for i =1:length(liq)
aux= corrcoef(omega(i,1:end), lt_consumo(i,:));
correlation(i) =aux(2,1);
end

% Figuras 
figure;
sgtitle('Equilibrio general','FontSize', 20)
subplot(2,2,1)
p = plot(1:T+1,lt_activos(:,1:end));
xlabel('T')
title('Trayectoria optima de activos')
legend([p(1) p(9)], 'Restriccion activa', 'Restriccion no activa', 'Location','best')
 
subplot(2,2,2)
p = plot(1:T,lt_consumo, 1:T, omega(end,:), ':'); % saque ingresos pues como es endogena ni se nota
xlabel('$T$')
ylabel('Trayectoria de consumo')
legend([p(1) p(7) p(9)], 'Restriccion activa', 'Restriccion no activa' ,'Evolucion salarial $\omega\cdot \gamma_t$','Location','best')

subplot(2,2,3)
plot(liq,r_eq)
xlabel('Restriccion endeudamiento')
ylabel('Tasa interes de equilibrio')

subplot(2,2,4)
plot(liq, correlation)
xlabel('Restriccion endeudamiento')
ylabel('Correlacion entre consumo e ingreso')