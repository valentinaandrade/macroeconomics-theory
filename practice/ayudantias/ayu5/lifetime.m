function [vt,Api, Apf, Cpf,lifetime_act, lifetime_ahorro, lifetime_consumo] = lifetime(T, sigma, beta,r)
%Funcion que permite obtener la value function y policy function de activos
% -----------------------------------------------------------------------
%% 1. Information
% ----------------------------------------------------------------------

% 1.1 Parametros
%-----------------------
w = zeros(1,T);
for i = 1:T
    w(i) = 1.5 + 6*(exp(i)^(-2))-1*(exp(i^2)^-3);
end

% 1.2 Grillas
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

end