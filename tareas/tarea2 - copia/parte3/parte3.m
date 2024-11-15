% Tarea 2 - Parte 3 ------------------------------------------------------
% Valentina Andrade
clear; clc, close all;
% k. Crecimiento poblacional
T = 65;
g =  linspace(0,0.01,11);
sigma = 2; beta= 0.96; alpha =1/3; delta = 0.1;
liq= 100;

% Explorando el equilibrio para cada masa
mt=growth(T,g)';
r = 0.09; % desde 0.04 hasta 0.09 divido en 10 entradas (vector 1x10)
lt_activos = NaN(length(mt),T+1);   % Trayectoria de activos optima. Tiene dimension rdim pues se calcula para cada r
oa = NaN(1,length(mt));     % Oferta agregada de activos
gammat = NaN(length(mt),T); % trayecctoria de salarios en fuciond de edad
kk = NaN(1,length(mt));     % Oferta agregada de capital

tic
for i = 1: length(mt)
[~,~, ~, ~,lt_activos, ~,~,gammat,~] = fisher(T, sigma, beta,r,liq); % Aquí se rellena la trayectoria optima
%Cuando se usa  [~,palette], esto significa que solo quieres el segundo output de la funcion.
oa(i) = sum(mt(i).*lt_activos);
kk(i) = sum(mt(i).*((alpha)./(r+delta)).^(1/(1-alpha)).*gammat);% sacarle el w de antes y agregrar ((1- alpha)*((alpha)/(r+delta)).^(1/(1-alpha))).*
end
toc

% Figuras para explorar
figure;
subplot(1,2,1)
plot(mt,oa)
xlabel('$mt$')
title('Oferta de activos')
 
subplot(1,2,2)
plot(mt,kk)
xlabel('$mt$')
title('Demanda capital $K$')

%% Calculando tasa de interes de equilibrio
a = 0.04; %r(1)
b = 0.09;%r(10)
liq = 100;% Si mi restriccion de liquidez es h = 100 no es activo
%rho = @(x) (oa(x)-ok(x))/ok(x); %Sin valor absoluto
[r_eq, error]=bisection_pob(a,b,liq,g); % r endogena

%% Con tasa interes obtener trayectoria activos

for i = 1: length(mt)
[~,~, ~, ~,lt_activos(i,:), ~,~,gammat,~] = fisher(T, sigma, beta,r_eq(i,:),liq); % Aquí se rellena la trayectoria optima
end
toc


%% k.1 Subplot con 
% 1. crecimiento versus tasa de interes equilibrio 
% 2. trayectoria de activos para cada tasa de crecimiento

figure;
sgtitle('Crecimiento poblacional',10)
subplot(1,2,1)
plot(g, r_eq)
xlabel('Crecimiento poblacional')
ylabel('Tasa interes de equilibrio')

subplot(1,2,2)
p=plot(1:T, lt_activos(:,1:end))
xlabel('T')
title('Trayectoria optima de activos')
lgd = legend([p(1), p(length(g))], '$g = 0\%$', '$g = 1\%$')
