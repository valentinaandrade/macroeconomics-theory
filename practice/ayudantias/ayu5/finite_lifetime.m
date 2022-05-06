% Ayudantia 5 ------------------------------------------------------------
% Valentina Andrade
clear; close all; clc
% -----------------------------------------------------------------------
%% 1. Information
% ----------------------------------------------------------------------

% 1.1 Parametros
%-----------------------
beta = 0.96; % Factor de descuento
r = 0.04; %tasa interes exogena
T = 65; % Horizonte
sigma = 2; %Tasa intertemporal de sustitucion
%w = @(T) 1.5 + 6*(exp(T)^(-2))-1*(exp(T^2)^-3); % Funcion del salario
w = zeros(1,T);
for i = 1:T
    w(i) = 1.5 + 6*(exp(i)^(-2))-1*(exp(i^2)^-3);
end

% Otra funcion: 1+0.07*i-0.001*i^2

% 1.3 Grillas
%---------------------
% Espacio de variables de estado
amax=1001;
agrid = linspace(-15,25,amax); % Grilla activos discretizado. Niveles de riqueza posible que puede elegir el agente

%-------------------------------------------------------------------------
%% 2. Recursion
% ------------------------------------------------------------------------

% 2.1 Preallocate ------------------------------------------------------
% Activos iniciales
Api = NaN(amax,T); % Iniciales assets for each period
Api(:, end) = sum(agrid<0)+1; %%En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.
% Activos finales
Apf= NaN(amax,T); %Correspondencia entre posición en la grilla A con grilla A, del nivel de capital que maximiza.
Apf(:,end)=agrid(Api(:,end)); %Policy de activos en t=65 es 0 por estructura del problema.

% Policy Consumo
%Consumo admisibles en el último periodo. (Recordar que a_66=0)
c_65 = w(65) + (1+r).*agrid; % en el ultimo periodo me lo como todo
c_65(c_65<0)=NaN;
Cpf = NaN(amax,T); %Política de consumo, derivada de la eq. (3) de la tarea. 
Cpf(:, end)=c_65; %La policy de consumo en el último periodo queda definida también por el hecho de que a_66=0

% Estas matrices preallocan matrices que después se van a *crear*
vt = NaN(amax, T); % Value function in t (pq t+1)?
vt(:,T) = crra(c_65,sigma);
%vaux = zeros(nmax,1); % Value function in t-1 (changes)

% restriccion de no ponzi?

% 2.2 Solve -------------------------------------------------------------
tic 
for t= T-1:-1:1
    
    % Estas son matrices de consumo 
    c= w(t) + (1+r)*agrid' - agrid; % Restriccion presupeustaria
    c(c <0) = NaN; % Restriccion de no negatividad

    % Utilidad al tiempo t
    vaux= crra(c,sigma)+beta*vt(:,t+1)';
    
    % Maximizacion
    [v0, api]=max(vaux,[],2); % optenemos la value function y su posicion
    
    % Value function 
    vt(:,t)= v0; % resgistramos la value function nueva
    
    Api(:,t)=api;%Posición donde encontramos la policy de activos óptima.
    
    % Policy activos
    Apf(:,t)=agrid(Api(:,t))';
    
    % Policy consumo
    Cpf(:,t)=w(t)+(1+r)*agrid'-Apf(:,t);   
       
end
toc

%----------------------------------------------------------------------
%% 3. Trayectorias relevantes
% ------------------------------------------------------------------------
%Trayectorias relevantes, sabemos que a_1=0.

%Activos
pos_act_i=sum(agrid<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
lifetime_act=zeros(1,T+1);%Prealocamos la trayectoria
lifetime_act(1)=agrid(pos_act_i);
for i=2:T
    pos_act_corr=Api(pos_act_i,i-1);
    lifetime_act(i)=agrid(pos_act_corr);
    pos_act_i=pos_act_corr;   
end

%Consumo
lifetime_consumo=lifetime_act(1:65)*(1+r)+w-lifetime_act(2:T+1);

%Ahorro
lifetime_ahorro=w-lifetime_consumo;



%------------------------------------------------------------------------
%% 3. Plots
%------------------------------------------------------------------------
% Color grid
color= [linspace(0.0000, 0.4940, T)',...
        linspace(0.4470, 0.1840, T)',...
        linspace(0.7410, 0.5560, T)'];


%Subplots

figure;
subplot(2,2,1)
plot(w)
title("Trayectoria salario")
subplot(2,2,2)
plot(lifetime_act)
title("Trayectoria activos")
subplot(2,2,3)
plot(lifetime_ahorro)
title("Trayectoria ahorros")
subplot(2,2,4)
plot(lifetime_consumo)
title("Trayectoria consumo")

% Value function
figure;
axes('ColorOrder',color,'NextPlot','replacechildren')
plt= plot(agrid',vt(:,1:end-1));
lgd= legend([plt(1),plt(T)],'$V_0$','$V_T$'); lgd.Location= 'SouthEast';
title('Value functions'); xlabel('Capital');
% Capital policy
figure;
axes('ColorOrder',color,'NextPlot','replacechildren')
plt= plot(agrid,Apt(:,1:end));
lgd= legend([plt(1),plt(T)],'$A_1$','$A_{T+1}$'); lgd.Location= 'SouthEast';
title('Capital policy'); xlabel('Capital');


% -------------------------------------------------------------------------
%% b. Repetir proceso
% -------------------------------------------------------------------------
% Se utilizara la funcion lifetime para poder obtener distintos casos

T = 65; beta=0.96;
sigma = [-2 1 2 5]; % IES distintas
r = [0.04 0.07]; %tasas distintas

[vt_m2,Api_m2, Apf_m2, Cpf_m2,lifetime_act_m2, lifetime_ahorro_m2, lifetime_consumo_m2]=lifetime(T,sigma(1),beta,r(1));
[vt_1,Api_1, Apf_1, Cpf_1,lifetime_act_1, lifetime_ahorro_1, lifetime_consumo_1]=lifetime(T,sigma(2),beta,r(1));
[vt_2,Api_3, Apf_3, Cpf_3,lifetime_act_3, lifetime_ahorro_3, lifetime_consumo_3]=lifetime(T,sigma(3),beta,r(1));
[vt_5,Api_5, Apf_5, Cpf_5,lifetime_act_5, lifetime_ahorro_5, lifetime_consumo_5]=lifetime(T,sigma(4),beta,r(1));


% Trayectoria activos
%Subplots

figure;
subplot(2,2,1)
plot(lifetime_act_m2)
title("Trayectoria activos $sigma = -2$")
subplot(2,2,2)
plot(lifetime_act_1)
title("Trayectoria activos $sigma = 1$")
subplot(2,2,3)
plot(lifetime_act_3)
title("Trayectoria activos $sigma = 2$")
subplot(2,2,4)
plot(lifetime_act_5)
title("Trayectoria activos $sigma = 5$")

figure;
subplot(2,2,1)
plot(lifetime_ahorro_m2)
title("Trayectoria ahorro $sigma = -2$")
subplot(2,2,2)
plot(lifetime_ahorro_1)
title("Trayectoria ahorro $sigma = 1$")
subplot(2,2,3)
plot(lifetime_ahorro_3)
title("Trayectoria ahorro $sigma = 2$")
subplot(2,2,4)
plot(lifetime_ahorro_5)
title("Trayectoria ahorro $sigma = 5$")

figure;
subplot(2,2,1)
plot(lifetime_consumo_m2)
title("Trayectoria consumo $sigma = -2$")
subplot(2,2,2)
plot(lifetime_consumo_1)
title("Trayectoria consumo $sigma = 1$")
subplot(2,2,3)
plot(lifetime_consumo_3)
title("Trayectoria consumo $sigma = 2$")
subplot(2,2,4)
plot(lifetime_consumo_5)
title("Trayectoria consumo $sigma = 5$")

% r distinta
[vt_2,Api_3, Apf_3, Cpf_3,lifetime_act_3, lifetime_ahorro_3, lifetime_consumo_3]=lifetime(T,sigma(2),beta,r(1));
[vt_22,Api_32, Apf_32, Cpf_32,lifetime_act_32, lifetime_ahorro_32, lifetime_consumo_32]=lifetime(T,sigma(2),beta,r(2));

figure;
subplot(2,2,1)
plot(lifetime_consumo_3)
title("Trayectoria consumo $r = 0.04$")
subplot(2,2,2)
plot(lifetime_consumo_32)
title("Trayectoria consumo $r = 0.07$")
subplot(2,2,3)
plot(lifetime_ahorro_3)
title("Trayectoria ahorro $r = 0.04$")
subplot(2,2,4)
plot(lifetime_ahorro_5)
title("Trayectoria ahorro $r = 0.07$")
