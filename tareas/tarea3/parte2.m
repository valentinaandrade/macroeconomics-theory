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
plot(r,AA,r,K)
xlabel('$r$')
ylim([0,29])
title('Equilibrio mercado de capitales')
legend('Oferta activos $a_{t+1}$', 'Demanda capital $K$')

%% (i) Tasa de interes de equilibrio ------------------------------------
% Usaremos algoritmo de biseccion, igual que en tarea 2
r = [0.02 0.035];
tol = 10^-2;
error = 1;

w= (1- alpha).*((alpha)./(r(1)+delta)).^(alpha/(1-alpha));
[~, ~, ~, ~,~, ~, ~, lt_activos1] = bellman2(r(1),w, sigma_mu,rho);
AA1 = mean(lt_activos1(:,end));
K1 = ((alpha)./(r(1)+delta)).^(1/(1-alpha))*L;
eq1 = (AA1 -K1)/K1;


while tol < error
    rbar = (r(1) + r(2))/2;
    w= (1- alpha).*((alpha)./(rbar+delta)).^(alpha/(1-alpha));
    [~, ~, ~, ~,~, ~, ~, lt_activosbar] = bellman2(rbar,w, sigma_mu,rho);
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

rbar; % ¡¡R de equilibrio!!

y = Kbar^alpha*L^(1-alpha);
c=mean((1+rbar)*lt_activosbar(:,end-1)+(1-alpha)*((((rbar+delta)/alpha)^(1/(alpha-1)))^(alpha))*panel_shocks(:,end)-lt_activosbar(:,end));

% Como mostrar que es consecuente?
r = linspace(0, 0.08, 10);
figure;
plot(r,AA,r,K)
hold on
plot(rbar*ones(10,1), rbar*ones(10,1))
xlabel('$r$')
ylim([0,29])
title('Equilibrio mercado de capitales')
annotation('line',[0.4 0.4], [0.33 0.11],'Color',[0.5 0.5 0.5],'LineStyle','--');
annotation('line',[0.42 0.13],[0.33 0.34],'Color',[0.5 0.5 0.5],'LineStyle','--');
annotation('textbox', [0.38 0.48 0.06 0.043],'Color',[0.15 0.15 0.15],'String',{'r = 0.031'}, 'EdgeColor',[0.52 0.52 0.52],'BackgroundColor',[0.941 0.9411 0.9411]);
annotation('arrow',[0.41 0.421], [0.4 0.35],'Color',[0.502 0.502 0.502],'LineWidth',1,'HeadWidth',5,'HeadStyle','cback1','HeadLength',5);
legend('Oferta activos $a_{t+1}$', 'Demanda capital $K$')

%% j. Muestre como varía el consumo y producción agregada en función de la volatilidad del agente.
% Ayuda: Para cada nivel de volatilidad del ingreso laboral,
% recuerde encontrar la tasa de interés de equilibrio del mercado de capitales y en base a dicha tasa compute lo solicitado. 
sigma_mu = linspace(0.1, 0.19, 10); % Volatilidad

tol=10^(-2);
error=1;

%Grilla para Restricciones de Liquidez
r_eq=zeros(1,length(sigma_mu));

for i=1:length(sigma_mu)

error=1;
r_0=0.02;r_1=0.04; % Tasas de interes
iter = 0;

    while  tol<error

    r_bar=(r_1+r_0)/2;
    
       w= (1- alpha).*((alpha)./(r_0+delta)).^(alpha/(1-alpha));
       [~, ~, ~, ~,~, ~, ~, lt_activos0] = bellman2(r_0,w, sigma_mu(i),rho);
       AA0 = mean(lt_activos0(:,end));
       K0 = ((alpha)./(r_0+delta)).^(1/(1-alpha))*L;
       eq0 = (AA0 -K0) /K0;

        
       w= (1- alpha).*((alpha)./(r_bar+delta)).^(alpha/(1-alpha));
       [~, ~, ~, ~,~, ~, ~, lt_activosbar] = bellman2(r_bar,w, sigma_mu(i),rho);
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
c(1,i)=mean((1+rbar)*lt_activosbar(:,end-1)+(1-alpha)*((((r_bar+delta)/alpha)^(1/(alpha-1)))^(alpha))*panel_shocks(:,end)-lt_activosbar(:,end));

% agregados
Keq(1,i) = Kbar;
AAeq(1,i) = AAbar;

end
% lento: 0.0341    0.0327    0.0312    0.0298    0.0287    0.0272    0.0256    0.0243    0.0231    0.0217
% Para hacer un poco de analisis
corrcoef(sigma_mu, r_eq); % -0.996 


% Figures --------------------------------------------------------------
figure;
subplot(2,2,1)
plot(sigma_mu,r_eq)
xlabel('$\sigma_\mu$'); ylabel('r');

subplot(2,2,2)
plot(sigma_mu,y)
xlabel('$\sigma_\mu$'); ylabel('Producción');

subplot(2,2,3)
plot(sigma_mu,c)
xlabel('$\sigma_\mu$'); ylabel('Consumo');

subplot(2,2,4)
plot(lt_activosbar(end,:)')
xlabel('T'); ylabel('Trayectoria activos')