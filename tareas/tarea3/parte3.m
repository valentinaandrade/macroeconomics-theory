%% Parte 3 ---------------------------------------------------------------
% Impuestos y gobierno --------------------------------
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
tau = 0.1; %
% Especificos del problema
r = 0.03;
w = 1;

[~, ~, ~, v0_singob,~, ~, ~,~] = bellman2(r,w, sigma_mu, rho); % value function sin gobierno
v0_singob = v0_singob';
%% k. Resolver el problema del agente en equilibrio parcial ---------------
% Explique económicamente las diferencias con respecto a lo obtenido en el ítem anterior.
% Se refiere al item de equilibrio parcial?
load('panel_shock.mat');
[ee, tr] = discAR(n_e,rho,sigma_mu);
L = mean(panel_shocks(:,end));
[ct, at, s, v1,pos, panel_shocks, lt_consumo,lt_activos] = bellman2(r,w, sigma_mu, rho,2, L);


%% Figures; 
policyfigures(ct, at, v1, ee)
% Menos varianza en value function

figure;
subplot(2,1,1);
histogram(lt_activos(:,end),'Normalization','pdf'),xlim([0,27]);title('Distribucion del stock de activos con gobierno','FontSize',20);
ylim([0,0.5]);
dim = [.3 .5 .4 .4];
str = ['media:',num2str(mean(lt_activos(:,end),'all')),'  mediana:',num2str(median(lt_activos(:,end),'all')),'  \sigma:',num2str(var(lt_activos(:,end))), '  percentil:', num2str(prctile(lt_activos(:,end),10)), '(10);', num2str(prctile(lt_activos(:,end),90)), '(90); ', num2str(prctile(lt_activos(:,end),99)), '(99)'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

subplot(2,1,2);
histogram(lt_consumo(:,end),'Normalization','pdf'),xlim([0.3,3]);
title('Distribucion del consumo con gobierno','FontSize',20);
ylim([0,3])
dim = [.3 .2 .2 .2];
str = ['media:',num2str(mean(lt_consumo(:,end),'all')),'  mediana:',num2str(median(lt_consumo(:,end),'all')),'  \sigma:',num2str(var(lt_consumo(:,end))), '  percentil:', num2str(prctile(lt_consumo(:,end),10)), '(10);', num2str(prctile(lt_consumo(:,end),90)), '(90); ', num2str(prctile(lt_consumo(:,end),99)), '(99)'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%% Volatilidad - con gobierno ---------------------------------------------
sigma_mu = linspace(0.10, 0.19,10);
rho = 0.96; % Persistencia
for i = 1:length(sigma_mu)
[ct, at, s, ~,pos, panel_shocks, lt_consumo(:,:,i),lt_activos(:,:,i)] = bellman2(r,w, sigma_mu(i),rho, tau, L);
end

[tab_act, tab_consumo] = descriptives(sigma_mu,rho,lt_activos,lt_consumo);
tab_consumo;
tab_act; % Nos dan estadisticos descriptivos solicitados (en terminos nume

%% Persistencia - con gobierno ------------------------------------------
sigma_mu = 0.12; % Volatilidad
rho = linspace(0.9, 0.98,9);
for i = 1:length(sigma_mu)
[ct, at, s, ~,pos, panel_shocks, lt_consumo(:,:,i),lt_activos(:,:,i)] = bellman2(r,w, sigma_mu,rho(i), tau, L);
end

[tab_act, tab_consumo] = descriptives(sigma_mu,rho,lt_activos,lt_consumo);

%% Impacto en el bienestar por cambio en volatilidad ----------------------
sigma_mu = [0.1 0.15];
rho = 0.96;
[~,~, ~, v0,~, ~, ~,~] = bellman2(r,w, sigma_mu(1),rho, tau, L); % limite inferior
[~,~, ~, v1,~, ~, ~,~] = bellman2(r,w, sigma_mu(2),rho, tau, L); % limite superior

[ee0, ~] = discAR(n_e,rho,sigma_mu(1));
[ee1, ~] = discAR(n_e,rho,sigma_mu(2));

v1_interp = zeros(length(A), length(ee));
v0 = v0'; v1 = v1';
%interp1(grilla epsilon para v1, v1, grilla epsilon para v0)
for i = 1:length(A)
 v1_interp(i,:) = interp1(ee1,v1(i,:),ee0);
end
g = (v1_interp./v0).^(1/(1-sigma)) - 1; % funcion

plot(A,g','LineWidth',1.5),legend('$\varepsilon=0.54$','$\varepsilon=0.71$','$\varepsilon=0.93$','$\varepsilon=1.22$','$\varepsilon=1.6$','Interpreter','Latex','FontSize',15,'Location','northeast');
title('Efecto en bienestar de una reduccion de la volatilidad, caso con impuestos','FontSize', 20);

%% l. Compute los efectos en el bienestar de tasas impositivas ------------
% Se compara con la v0 sin tau. ¿Sin interpolacion?
tau = [0.12 0.04];
rho = 0.96;
sigma_mu = 0.12; % Volatilidad
[~, ~, ~, v0,~, ~, lt_consumo0,lt_activos0] = bellman2(r,w, sigma_mu,rho, tau(1), L);
[~, ~, ~, v1,~, ~, lt_consumo1,~] = bellman2(r,w, sigma_mu,rho, tau(2), L);

% Computamos efecto en bienestar del gobierno ----------------------------
figure;
g1=(v0./v0_singob').^(1/(1-sigma)) -1;
subplot(1,2,1)
plot(A,g1,'LineWidth',1.5),legend('$\varepsilon=0.48$','$\varepsilon=0.66$','$\varepsilon=0.91$','$\varepsilon=1.26$','$\varepsilon=1.73$','Interpreter','Latex','FontSize',15,'Location','northeast');
title('Efecto en bienestar por impuesto $\tau = 0.12 $ ','FontSize', 20);
subplot(1,2,2)
g2=(v1./v0_singob').^(1/(1-sigma)) -1;
plot(A,g2,'LineWidth',1.5),legend('$\varepsilon=0.48$','$\varepsilon=0.66$','$\varepsilon=0.91$','$\varepsilon=1.26$','$\varepsilon=1.73$','Interpreter','Latex','FontSize',15,'Location','northeast');
ylim([-0.02,0.08])
title('Efecto en bienestar por impuestos $\tau = 0.04 $','FontSize', 20);

%% m. Tasa de interes de equilibrio para una tasa tau = 0.075
tau = 0.075;
r = linspace(0, 0.08, 10);
w= (1- alpha).*((alpha)./(r+delta)).^(alpha/(1-alpha));
for i = 1:length(r)
[ct, at, s, v1,pos, panel_shocks, lt_consumo, lt_activos(:, :, i)] = bellman2(r(i),w(i), sigma_mu,rho, tau,L);
AA(1,i) = mean(lt_activos(:,end,i));
end
% Agregados
K = ((alpha)./(r+delta)).^(1/(1-alpha))*L;
% Figura
figure;
plot(r,AA,r,K)
xlabel('$r$')
ylim([0,29])
title('Equilibrio mercado de capitales, $\tau = 0.075$')
legend('Oferta activos $a_{t+1}$', 'Demanda capital $K$')

%% Tasa de interes de equilibrio ------------------------------------
% Usaremos algoritmo de biseccion, igual que en tarea 2
tau = 0.075;
r = [0.02 0.035];
tol = 10^-2;
error = 1;

w= (1- alpha).*((alpha)./(r(1)+delta)).^(alpha/(1-alpha));
[~, ~, ~, ~,~, ~, ~, lt_activos1] = bellman2(r(1),w, sigma_mu,rho,tau,L);
AA1 = mean(lt_activos1(:,end));
K1 = ((alpha)./(r(1)+delta)).^(1/(1-alpha))*L;
eq1 = (AA1 -K1)/K1;


while tol < error
    rbar = (r(1) + r(2))/2;
    w= (1- alpha).*((alpha)./(rbar+delta)).^(alpha/(1-alpha));
    [~, ~, ~, ~,~, ~, ~, lt_activosbar] = bellman2(rbar,w, sigma_mu,rho, tau,L);
    AAbar = mean(lt_activosbar(:,end));
    Kbar = ((alpha)./(rbar+delta)).^(1/(1-alpha))*L;
    eqbar = (AAbar -Kbar)/Kbar;

    error = abs(eqbar);

    if sign(eq1)~=sign(eqbar)
        r(2) = rbar;
        eq2 = eqbar;
    else
        r(1) = rbar;
        eq1 = eqbar;
    end
end
rbar; 

display(['Tasa encontrada ',num2str(rbar)]) % 0.032656

%% n. Equilibrio general con gobierno ------------------------------------
% Muestre como varía el consumo y producción agregada en función de tau
% Ayuda: Para cada nive de tau del ingreso laboral,
% recuerde encontrar la tasa de interés de equilibrio del mercado de capitales y en base a dicha tasa compute lo solicitado. 
% Ojo, se demora 2horas
%0.0316    0.0320    0.0325    0.0332    0.0341

tau = linspace(0, 0.15, 5); % Impuestos
tol=10^(-2);
error=1;

% Grilla para Restricciones de Liquidez ----------------------------------
r_eq=zeros(1,length(tau));

for i=1:length(tau)
error=1;
r_0=0.02;r_1=0.06; % Tasas de interes
iter = 0;

    while  tol<error
    r_bar=(r_1+r_0)/2;
    
       w= (1- alpha).*((alpha)./(r_0+delta)).^(alpha/(1-alpha));
       [~, ~, ~, ~,~, ~, ~, lt_activos0] = bellman2(r_0,w, sigma_mu,rho, tau(i), L);
       AA0 = mean(lt_activos0(:,end));
       K0 = ((alpha)./(r_0+delta)).^(1/(1-alpha))*L;
       eq0 = (AA0 -K0) /K0;

        
       w= (1- alpha).*((alpha)./(r_bar+delta)).^(alpha/(1-alpha));
       [~, ~, ~, ~,~, ~, ~, lt_activosbar] = bellman2(r_bar,w, sigma_mu,rho, tau(i), L);
       AAbar = mean(lt_activosbar(:,end));
       Kbar = ((alpha)./(r_bar+delta)).^(1/(1-alpha))*L;
       eqbar = (AAbar -Kbar) /Kbar;
        
       error=abs(eqbar);

        if sign(eqbar)==sign(eq0)

            r_0 = r_bar;
            
        else
            r_1 = r_bar;

        end
        
        iter = iter + 1;
        if iter == 50
            break
        end

    end

disp('Terminado')

r_eq(1,i)=r_bar;
y(1,i) = Kbar^alpha*L^(1-alpha);
c(1,i)= mean((1+rbar)*lt_activosbar(:,end-1)+(1-alpha)*((((r_bar+delta)/alpha)^(1/(alpha-1)))^(alpha))*panel_shocks(:,end)-lt_activosbar(:,end));

% Agregados -------------------------------------------------------------
Keq(1,i) = Kbar;
AAeq(1,i) = AAbar;

end
% lento: 0.0341    0.0327    0.0312    0.0298    0.0287    0.0272    0.0256    0.0243    0.0231    0.0217
% Para hacer un poco de analisis
corrcoef(tau, r_eq); % 


%% Figures --------------------------------------------------------------
figure;
subplot(2,2,1)
plot(tau,r_eq)
xlabel('$\tau$'); ylabel('r');

subplot(2,2,2)
plot(tau,y)
xlabel('$\tau$'); ylabel('Produccion');

subplot(2,2,3)
plot(tau,c)
xlabel('$\tau$'); ylabel('Consumo');

subplot(2,2,4)
plot(lt_activosbar(end,:)')
xlabel('T'); ylabel('Trayectoria activos')

figure;
plot(tau, KKeq, tau, AAeq)
legend

%% Efecto del bienestar en equilibrio
tau = 0.075;
% Con gobierno req
[~, ~, ~, v1_eqgob,~, ~, ~,~] = bellman2(req,w, sigma_mu, rho,tau, L);
[~, ~, ~, v1_eqsingob,~,~,~,~] = bellman2(0.031,w, sigma_mu, rho,tau, L);

g_eq = (v1_eqgob./v1_eqsingob).^(1/(1-sigma)) -1 ;
plot(A,g_eq,'LineWidth',1.5),legend('$\varepsilon=0.48$','$\varepsilon=0.66$','$\varepsilon=0.91$','$\varepsilon=1.26$','$\varepsilon=1.73$','Interpreter','Latex','FontSize',15,'Location','northeast');
title('Efecto en bienestar por impuestos $\tau = 0.075$ en equilibrio','FontSize', 20);

