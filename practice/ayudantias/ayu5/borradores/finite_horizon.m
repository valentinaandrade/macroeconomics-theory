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

% 1.2 Problema del consumidor
%----------------------
utility= @(c)  crra(c,sigma);

% 1.3 Grillas
%---------------------
% Espacio de variables de estado
amin = -15; amax=25; nmax=1001;
agrid = linspace(amin,amax,nmax)'; % Grilla activos discretizado. Niveles de riqueza posible que puede elegir el agente

%-------------------------------------------------------------------------
%% 2. Recursion
% ------------------------------------------------------------------------

% 2.1 Preallocate ------------------------------------------------------
% Estas matrices preallocan matrices que después se van a *crear*
vt = zeros(nmax, T+1); % Value function in t
%vaux = zeros(nmax,1); % Value function in t-1 (changes)
iApt = zeros(nmax,T); % Future assets for each period

% Utility como matrix: [a x a']
% Estas son matrices que después van a *cambiar*
caux= ((1+r)*agrid)*ones(1,nmax) + y - agrid; % Restriccion presupeustaria
caux= caux.*(caux>0) + (caux<=0)*(1e-20); % Restriccion de no negatividad
uaux= utility(caux); 

% restriccion de no ponzi?

% 2.2 Solve -------------------------------------------------------------
tic 
for it= T:-1:1

    % Utilidad al tiempo t
    vaux= uaux + beta*vt(:,it+1)';
    % Maximizacion
    [v,apt]= max(vaux, [],2);
    % Value function
    vt(:,it)= v;
    % Capital policy index
    iApt(:,it)= apt;
    
end
toc

% Capital policy
Apt= zeros(nmax,T);
for it= 1:T
   Apt(:,it)= agrid(iApt(:,it)); 
end


%------------------------------------------------------------------------
%% 3. Plots
%------------------------------------------------------------------------

% Color grid
color= [linspace(0.0000, 0.4940, T)',...
        linspace(0.4470, 0.1840, T)',...
        linspace(0.7410, 0.5560, T)'];

% Value function
figure;
axes('ColorOrder',color,'NextPlot','replacechildren')
plt= plot(agrid,vt(:,1:end-1));
lgd= legend([plt(1),plt(T)],'$V_0$','$V_T$'); lgd.Location= 'SouthEast';
title('Value functions'); xlabel('Capital');
% Capital policy
figure;
axes('ColorOrder',color,'NextPlot','replacechildren')
plt= plot(agrid,Apt(:,1:end));
lgd= legend([plt(1),plt(T)],'$A_1$','$A_{T+1}$'); lgd.Location= 'SouthEast';
title('Capital policy'); xlabel('Capital');


