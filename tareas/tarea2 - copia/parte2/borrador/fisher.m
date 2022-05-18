function [vt, gammat, lt_activos, lt_ahorro, lt_consumo, omega] = fisher(T, sigma, beta,r,gamma,liq)
% Funcion que permite obtener el ciclo de vida economico del agente, con
% horizonte finito
% Input 
% ----------
% T : horizonte de tiempo de agente
% sigma: elasticidad intertemporal de sustitucion
% beta: impaciencia
% r: tasa de interes
% gamma: trayectoria de ingreso
% Output
%------------
% t: value function
% Ac: decision optima de activos
% Ap: posicion de activos
% Cp: cosumo policy function
% lt_act: trayectoria de activos
% lt_ahorro: trayectoria de ahorros
% lt_consumo: trayectoria consumo

% 0. Parametros fijos
A = linspace(-15,25,1001)'; % Tienen como deuda maxima -15 y ahorro 25;
alpha = 1/3;
delta = 0.1;
w=@(r) (1- alpha).*((alpha)./(r+delta)).^(alpha/(1-alpha));

gammat=zeros(1,T);
for i=1:T
  gammat(i) = ((40/(0.4*i*(2*pi).^(1/2)))*exp((-1/2)*((log(i)-log(32.5))/0.4).^2)+1);
  omega(i) = gammat(i)*w(r);
end

% -----------------------------------------------------------------------
% 1 Restricciones
%-----------------------------------------------------------------------
% 1.1  Espacio de variables de estado ---------------------------------
nmax = length(A);
% Grilla activos discretizado. Niveles de riqueza posible que puede elegir el agente
% 1.2 Aceso al credito  vector de puros
% zeros--------------------------------------------------------------
h = zeros(1,T+1); % Vector de deuda maxima. Se pone T+1 pues refiere a el último periodo 
% T+1 morir sin deuda (no ponzi) y no pueda acceder a deuda en el ultimo periodo
% at+1 parte con cero y termina con cero
% Queremos saber la deuda maxiima: Entonces si despejamos la restriccion de at,at+1 = 0, y ct=0 pues no va a
% consumir nada entonces obtenemos lo de la linea 34
for t = T:-1:1 % T entre T maximo hasta 1 con un espaciado de -1
    h(t) = (h(t+1)-omega(t))/(1+r); %  Deuda maxima en cada periodo. Entonces si 
        if h(t) >= -liq % Es mayor a la restriccion, no activa. Es decir que si su liquidez es mayor a lo que se exige, entonces es esta misma (no se ve afectad
            h(t) = h(t);
        else 
            h(t) = -liq; % Es menor a la restriccion de liquidez, entonces la deuda la restriccion de liquidez (no se puede endeudar mas)
        end  
end

% Idea principal: %Condición sobre el crédito impuesta por el hecho de que no puede morir
%endeudado. Visto de otra manera, es una cota inferior a la policy de
%activos que puede tomar el agente y corresponde al valor presente de los
%ingresos futuros del individuo. 


% 1.3 Nace sin activos --------------------------------------------------
% Se fija una "semilla" inicial sobre la posicion de un A que cumpla la
% condicion de que A>=0, y si no se avanza en posicion 
h_pos_p = sum(A<h(end)) + 1; %En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.
% (A<0) Si la grilla de activos es menor a 0, entonces devuelve un 1. Y así
% avanza posición donde en la grilla de activos esta sobre cero
% Duda: h(end) podria ser 0

% Preallocation ----------------------------------------------------
% Estas matrices preallocan matrices que después se van a *ir rellenando*
vt = NaN(nmax,T+1); % Activos iniciales para cada periodo
vt(h_pos_p:end,end) = 0; % Activos finales en esa posicion estará el cero

Ap = NaN(nmax,T);  % Correspondencia entre posición en la grilla A con grilla A, del nivel de capital que maximiza.
Ac = NaN(nmax,T);            % Activos

% Consumo
%Consumo admisibles en el último periodo. (Recordar que a_70=0)
%c_70 = gamma(70) + (1+r).*agrid; % en el ultimo periodo me lo como todo
%c_70(c_70<0)=NaN;
Cp = NaN(nmax,T); %Política de consumo, derivada de la eq. (3) de la tarea. 
%Cp(:, end)=c_70; %La policy de consumo en el último periodo queda definida también por el hecho de que a_66=0

% ------------------------------------------------------------------------
%% 2. Rellenar grilla
% ------------------------------------------------------------------------
tic
for t = T:-1:1   
        h_pos = sum(A<h(t)) + 1; % posicion de la deuda maxima en el periodo t de tal modo que muera sin deuda (se va rellenando lo que hicimos antes pero para cada t)
        c = gamma(t)*w(r) + (1+r).*A(h_pos:end) - A(h_pos_p:end)'; % consumo fatible no es óptimo
        c(c<=0)=NaN; % se descartan consumos negativos 
        % la matriz resultante no es de 1001x1001 y es porque condicioné su deuda
        % esto lo hice por h_pos para descartar la deuda que no es factible
        % y no morir endeudado 
        vaux = crra(c,sigma) + beta*vt(h_pos_p:end,t+1)';  % h_pos_p:end, t+1 (solo tomaremos la parte factible)
        % [  ] x*y  + [ ] 1*y
        [v,pos] = max(vaux,[],2); % entregar vector columna ese 2  donde v es el valor y p es la posicion de la value funcion 
        vt(h_pos:end,t) = v; % Para guardar la value function dentro de la zona factible, para la posicion t
        Ap(h_pos:end,t) = h_pos_p - 1 + pos;    % Posicion de activos al sumar h_pos_p -1 es rescalar a la matriz pequeña 
        Ac(h_pos:end,t) = A(h_pos_p - 1 + pos); % Valor de activos dado la posicion
        Cp(h_pos:end,t) = gamma(t)*w(r) + (1+r).*A(h_pos:end) - A(h_pos_p - 1 + pos); % Cuando se despeja consumo
        h_pos_p = h_pos; % guardar la posicion anterior para en la linea 78 cuando se corre la funcion de valor que ya se calculo
end
toc

%----------------------------------------------------------------------
%% 3. Trayectorias relevantes
% ------------------------------------------------------------------------
% Trayectorias relevantes, sabemos que a_1=0.

% Activos - lt_act ------------------------------------------------------
lt_activos_pos=NaN(1,T); % Vector que es fila de 1 hasta T Poner hasta el ultimo periodo
lt_activos_pos(1)=sum(A<0)+1; % Posición en grilla activos donde encontramos el nivel de activos inicial (cero)

for i = 2:T+1
    lt_activos_pos(i) = Ap(lt_activos_pos(i-1),i-1);
end

lt_activos = A(lt_activos_pos)';

% Consumo - lt_consumo ---------------------------------------------------
% Se despeja la ecuacion que se obtiene para consumo
% Se hace loop por tema con las dimensiones
lt_consumo = omega(1:T) + (1+r).*lt_activos(1:T) - lt_activos(2:T+1); %Policy function consumption

% Ahorro - lt_ahorro -----------------------------------------------------
% Lo mismo para ahorro
lt_ahorro = omega(1:T)  - lt_consumo; %Policy function ahorro

end