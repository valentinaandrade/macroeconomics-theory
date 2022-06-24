%% Parte 1 ---------------------------------------------------------------
% Ausencia de gobierno ---------------------------------------------------
clear; close all; clc
rng; % Controlar reproducibilidad
% 0. Parametros ---------------------------------------------------------
rho = 0.96; % Persistencia
sigma_mu = 0.12; % Volatilidad
delta = 0.05; % Depreciacion
alpha = 0.33; % Complementariedad K y L
n_e = 5; % Numero de estados posibles de productividad
A = linspace(0,30,1001); % Grilla de activos, parte de cero, sin endeudamiento
sigma = 2; %IES
% Especificos del problema
r = 0.03;
w = 1;

% Estados de productividad -----------------------------------------------
% Para poder resolver el problema necesitamos obtener los distintos estados
% posibles de productividad, dado que la funcion de valor depende de estos.
% Para ello ocuparemos la funcion discAR que entrega como output los
% estados posibles y la matriz de transicion, segun los parametros de
% persistencia y volatilidad entregados

[ee, tr] = discAR(n_e,rho,sigma_mu);

%% (a) Resolver el problema del agente: sin incertidumbre ni posibilidad de endeudarse
[ct, at, s, v1,pos, panel_shocks, lt_consumo,lt_activos] = bellman(r,w, sigma_mu, rho);

%% (b) Figuras de politica 
policyfigures(ct, at, v1, ee)

% Adicional ahorro precautorio

%% (c) Simule las trayectorias de shocks de productividad
%para  individuos durante  periodos. Grafique la trayectoria del 1 agente
n = 10000; % numero de individuos
t1= 2000; % periodos
t0= 1000; % periodos que descartare depsues, asique que son irrelevantes para el analisis mas adelante
[panel_shocks] = shocks(n,t1,tr,ee);

figure
subplot (1,2,1)
plot(linspace(1,t1,t1),[mean(panel_shocks);mean(panel_shocks(:,t0+1:end),'all')*ones(1,t1)])
title('Trayectoria media de los shocks')
legend('Medias segun periodo','Media para $t>1000$');
subplot (1,2,2)
plot((1:t1), panel_shocks(1,:))
title('Simulacion para un agente')


%% (d) Trayectorias de consumo y activos ante shocks
% Si el individuo tiene shocks en su productividad, y queremos saber que
% pasa con su consumo y ahorro, en el fondo necesitaremos saber como eso
% afecta a la trayectoria de productividad. 
% Entonces simularemos como siempre la trayectoria de activos y consumo
% pero condicional al shock
% Preallocar trayectorias y transponer dimension de posicion optima

% Ya fueron calculadas en punto (A)

% Figuras ----------------------------------------------------------------
figure
subplot(2,1,1);
histogram(lt_activos(:,end),'Normalization','pdf'),xlim([0,27]);title('Distribucion del stock de activos','FontSize',20);
ylim([0,0.5]);
dim = [.3 .5 .4 .4];
str = ['media:',num2str(mean(lt_activos(:,end),'all')),'  mediana:',num2str(median(lt_activos(:,end),'all')),'  \sigma:',num2str(var(lt_activos(:,end))), '  percentil:', num2str(prctile(lt_activos(:,end),10)), '(10);', num2str(prctile(lt_activos(:,end),90)), '(90); ', num2str(prctile(lt_activos(:,end),99)), '(99)'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

subplot(2,1,2);
histogram(lt_consumo(:,end),'Normalization','pdf'),xlim([0.3,3]);
title('Distribucion del consumo','FontSize',20);
ylim([0,3])
dim = [.3 .2 .2 .2];
str = ['media:',num2str(mean(lt_consumo(:,end),'all')),'  mediana:',num2str(median(lt_consumo(:,end),'all')),'  \sigma:',num2str(var(lt_consumo(:,end))), '  percentil:', num2str(prctile(lt_consumo(:,end),10)), '(10);', num2str(prctile(lt_consumo(:,end),90)), '(90); ', num2str(prctile(lt_consumo(:,end),99)), '(99)'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');



%% (e) Efecto de la volatilidad
% Utilice el vector de volatilidad  y compute nuevamente la estadísica descriptiva solicitidada en el ítem anterior. 
% Explique cómo y por qué cambian sus resultados e interprete económicamente.
sigma_mu = linspace(0.10, 0.19,10);
rho = 0.96; % Persistencia
for i = 1:length(sigma_mu)
[ct, at, s, ~,pos, panel_shocks, lt_consumo(:,:,i),lt_activos(:,:,i)] = bellman(r,w, sigma_mu(i),rho);
end

[tab_act, tab_consumo] = descriptives(sigma_mu,rho,lt_activos,lt_consumo);
tab_consumo;
tab_act; % Nos dan estadisticos descriptivos solicitados (en terminos numericos)

%% (f) Efecto de la persistencia
% Utilice el vector de persistencia  y compute nuevamente la estadísica descriptiva solicitidada en el ítem anterior. 
% Explique cómo y por qué cambian sus resultados e interprete económicamente.
sigma_mu = 0.12; % Volatilidad
rho = linspace(0.9, 0.98,9);
for i = 1:length(sigma_mu)
[ct, at, s, ~,pos, panel_shocks, lt_consumo(:,:,i),lt_activos(:,:,i)] = bellman(r,w, sigma_mu,rho(i));
end

[tab_act, tab_consumo] = descriptives(sigma_mu,rho,lt_activos,lt_consumo);

%% (g) Compute efecto en el bienestar de un aumento en la volatilidad del ingreso desde 0.10 hasta 0.15 usando la siguiente medida
% Reforzaremos el punto (e) mostrando que un aumento en la volatilidad, mas
% amplitud de estados de productividad puede tomar un shock de
% productividad. 

% Para hacer esto ocuparemos interpolacion. Esto consiste en usar la
% funcion de valor del rango más grande de estados de productividad para
% interpolar aquella con el rango mas pequeño. Entonces tomare como v0 al
% sigma con 0.1 y como v1 al sigma con 0.15
sigma_mu = [0.1 0.15];
rho = 0.96;
[~,~, ~, v0,~, ~, ~,~] = bellman(r,w, sigma_mu(1),rho); % limite inferior
[~,~, ~, v1,~, ~, ~,~] = bellman(r,w, sigma_mu(2),rho); % limite superior

% Necesito saber el area que esta entremedio. La forma funcional me la da
% log(et) = alpha + rho*log(et-1) + mu
plot(v0'); hold on; plot(v1');legend('$V_0$', '$V_1$'); % Me sirve para explorar
% Voy a interpolar como referencia a v0
[ee0, ~] = discAR(n_e,rho,sigma_mu(1));
[ee1, ~] = discAR(n_e,rho,sigma_mu(2));

v1_interp = zeros(length(A), length(ee));
v0 = v0'; v1 = v1';
%interp1(grilla epsilon para v1, v1, grilla epsilon para v0)
for i = 1:length(A)
 v1_interp(i,:) = interp1(ee1,v1(i,:),ee0);
end

plot(v0); hold on; plot(v1);plot(v1_interp);legend('$V_0$', '$V_1$', '$V_1 interpolada$'); % Me sirve para explorar
% ¡Me dio!

g = (v1_interp./v0).^(1/(1-sigma)) - 1; % funcion

plot(A,g','LineWidth',1.5),legend('$\varepsilon=0.54$','$\varepsilon=0.71$','$\varepsilon=0.93$','$\varepsilon=1.22$','$\varepsilon=1.6$','Interpreter','Latex','FontSize',15,'Location','northeast');
title('Efecto en bienestar de una reduccion de la volatilidad','FontSize', 20);

