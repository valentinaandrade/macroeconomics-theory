%% Tarea 2 - Parte 2 ------------------------------------------------------
% Valentina Andrade ------------------------------------------------------
clear; close all; clc
% Funciones que se ocupan en este codigo
% - [crra]: funcion CRRA para utilidad de consumo
% - [fisher]: funcion que calcula el ciclo de vida economico de agente 
% 0. Parametros-----------------------------------------------------------
beta = 0.96; % Impaciencia
T = 70; % Horizonte temporal
sigma = 2; % Elastic of intertermporal substitution (IES).
liq = 100;% Si mi restriccion de liquidez es b = 100 no es activo
alpha = 1/3;
delta = 0.1;
% Trayectoria por edad como handle function  y luego dentro de fischer se multiplica por salario ---------
gamma= @(t) ((40/(0.4*t*(2*pi).^(1/2)))*exp((-1/2)*((log(t)-log(32.5))/0.4).^2)+1);


%% g. Funcion Fisher -----------------------------------------------------
rdim = 10;
r = linspace(0.04,0.09,rdim); % desde 0.04 hasta 0.09 divido en 10 entradas (vector 1x10)
lt_activos = NaN(rdim,T+1);   % Trayectoria de activos optima. Tiene dimension rdim pues se calcula para cada r
oa = NaN(1,rdim);     % Oferta agregada de activos
gammat = NaN(rdim,T); % trayecctoria de salarios en fuciond de edad
ok = NaN(1,rdim);     % Oferta agregada de capital

tic
for i = 1: rdim
[~, gammat(i,:), lt_activos(i,:), ~,~,~] = fisher(T, sigma, beta,r(i),gamma,liq); % Aquí se rellena la trayectoria optima
%Cuando se usa  [~,palette], esto significa que solo quieres el segundo output de la funcion.
oa(i) = (1/T)*sum(lt_activos(i,:));
ok(i) = (1/T)*sum(((alpha)./(r(i)+delta)).^(1/(1-alpha)).*gammat(i,:));% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
end
toc

% Figura subplot ------------------------------------------------------
figure;
sgtitle('Equilibrio general','FontSize', 20)
subplot(1,2,1)
p = plot(1:T+1,lt_activos(:,1:end));
xlabel('T')
title('Trayectoria optima de activos')
lgd= legend([p(1),p(length(r))],'$r = 4\%$','$r = 9\%$'); 
lgd.Location= 'SouthEast';
 
subplot(1,2,2)
plot(r,oa,r,ok)
xlabel('$r$')
title('Equilibrio mercado de capitales')
legend('Oferta activos $a_{t+1}$', 'Demanda capital $K$')

%% h. Tasa equilibrio -------------------------------------------------
a = -0.2; %r(1)
b = 0.2;%r(10)
liq = 100;% Si mi restriccion de liquidez es h = 100 no es activo
%rho = @(x) (oa(x)-ok(x))/ok(x); %Sin valor absoluto
[r_eq, error]=bisection_res(a,b,liq); % r endogena

% 0.0775
%% h.2  Figuras ---------------------------------------------------------------
%Además, grafique la trayectoria de consumo definida por la tasa de equilibrio junto al ingreso de los agentes
[~, ~, ~,~,lt_consumo, omega] = fisher(T, sigma, beta,r_eq,gamma,liq);
figure;
plot(1:T,lt_consumo,1:T,omega(1:end))
xlabel('$T$')
title(['Equilibrio general $r$ =', num2str(r_eq)])
legend('Trayectoria consumo $c_t$', 'Evolucion salarial $\omega\cdot \gamma_t$')
% Interpretar

%% j. Tasa de equilibrio, usando el algoritmo de biseccion para diferentes restricciones de liquidez
% Grafique un subplot que muestre (1) la trayectoria de activos óptima, (2) la tasa de interés de equilibrio, (3)
% la trayectoria de consumo óptima (junto al ingreso) y (4) la correlación consumo - ingreso en función de la
% restricción8 de liquidez. Explique la intuición económica.
a = -0.1; %r(1)
b = 0.09;%r(10)
liq = linspace(0,5,15);

for i = 1:length(liq)
[r_eq(i,:), ~]=bisection(a,b,liq(i)); % r endogena
[~, lt_act(i,:), ~,~,lt_consumo(i,:), omega] = fisher(T, sigma, beta,r_eq(i),gamma,liq(i));
end

correlation = zeros(15,1);
for i =1:15
aux= corrcoef(omega(1:end), lt_consumo(1,:));
correlation(i) =aux(2,1);
end

figure;
sgtitle('Equilibrio general','FontSize', 20)
subplot(1,4,1)
p = plot(1:T,lt_act(:,1:end));
xlabel('T')
title('Trayectoria optima de activos')
 
subplot(1,4,2)
plot(1:T,lt_consumo,1:T,omega(1:end))
xlabel('$T$')
ylabel('Trayectoria de consumo')
legend('Trayectoria consumo $c_t$', 'Evolucion salarial $\omega\cdot \gamma_t$')

subplot(1,4,3)
plot(liq,r_eq(:,end))
xlabel('Restriccion endeudamiento')
ylabel('Tasa interes de equilibrio')

subplot(1,4,4)
plot(liq, correlation)
xlabel('Restriccion endeudamiento')
ylabel('Correlacion entre consumo e ingreso')
