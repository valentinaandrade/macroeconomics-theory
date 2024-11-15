function [vt, gammat, lt_activos, lt_ahorro, lt_consumo, omega] = fisher(T, sigma, beta,r,liq)
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
A = linspace(-15,25,1001); % Tienen como deuda maxima -15 y ahorro 25;
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
cota_inf = zeros(1,T+1); % Vector de deuda maxima. Se pone T+1 pues refiere a el último periodo 
% T+1 morir sin deuda (no ponzi) y no pueda acceder a deuda en el ultimo periodo
% at+1 parte con cero y termina con cero
% Queremos saber la deuda maxiima: Entonces si despejamos la restriccion de at,at+1 = 0, y ct=0 pues no va a
% consumir nada entonces obtenemos lo de la linea 34
for j = T:-1:1 % T entre T maximo hasta 1 con un espaciado de -1
    cota_inf(j) = (cota_inf(j+1)-omega(j))/(1+r); %  Deuda maxima en cada periodo. Entonces si 
end

ponzi = sum(A<cota_inf(T))+1;
rest_act = max([ponzi, sum(A< -liq)+1]); %Posiciones en la grilla de activos desde la cual
%está definida la VFunction_70 (a raíz de restricciones anteriores
%enfrentadas en t=64 sobre la policy a_65), tengo que quedarme con la más
%exigente entre la restricción de liquidez y la restricción a no morir
%endeudado, este es el cambio respecto al algoritmo de 1.1


% Idea principal: %Condición sobre el crédito impuesta por el hecho de que no puede morir
%endeudado. Visto de otra manera, es una cota inferior a la policy de
%activos que puede tomar el agente y corresponde al valor presente de los
%ingresos futuros del individuo. 

% 1.3 Nace sin activos --------------------------------------------------
% Se fija una "semilla" inicial sobre la posicion de un A que cumpla la
% condicion de que A>=0, y si no se avanza en posicion 
%cota_inf_a = sum(A<cota_inf(end)) + 1; %En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.
% (A<0) Si la grilla de activos es menor a 0, entonces devuelve un 1. Y así
% avanza posición donde en la grilla de activos esta sobre cero
% Duda: cota_inf(end) podria ser 0

% Preallocation ----------------------------------------------------
% Estas matrices preallocan matrices que después se van a *ir rellenando*
vt = NaN(nmax,T+1); % Activos iniciales para cada periodo
c_final=omega(T)+(1+r).*A(rest_act:end);%Consumo admisibles (es solo una opción, por ende también es un óptimo para cada nivel de activo) en el último periodo. (Recordar que a_77=0)
vt(rest_act:end,T) = crra(c_final,sigma); 

Ap = NaN(nmax,T);  % Correspondencia entre posición en la grilla A con grilla A, del nivel de capital que maximiza.
Ap(rest_act:end,end)=sum(A<cota_inf(T+1))+1; %En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.

Ac = NaN(nmax,T);            % Activos
Ac(rest_act:end,end)=A(Ap(rest_act:end,end));%Policy de activos en t=70 es 0 por estructura del problema.


% Consumo
%Consumo admisibles en el último periodo. (Recordar que a_70=0)
Cp = NaN(nmax,T); %Política de consumo, derivada de la restriccion 
Cp(rest_act:end,T)=omega(T)+(1+r).*A(rest_act:end)'-Ac(rest_act:end,end); %La policy de consumo en el último periodo queda definida también por el hecho de que a_66=0


% ------------------------------------------------------------------------
%% 2. Rellenar grilla
% ------------------------------------------------------------------------
tic
for t = T-1:-1:1
        ponzi_a = sum(A<cota_inf(t))+1;
        rest_act_a = max([ponzi_a, sum(A< -liq)+1]); % posicion de la deuda maxima en el periodo t de tal modo que muera sin deuda (se va rellenando lo que hicimos antes pero para cada t)
        c = omega(t) + (1+r).*A(rest_act_a:end)' - A(rest_act:end); % consumo fatible no es óptimo
        c(c<=0)=NaN; % se descartan consumos negativos 
        % la matriz resultante no es de 1001x1001 y es porque condicioné su deuda
        % esto lo hice por h_pos para descartar la deuda que no es factible
        % y no morir endeudado 
        vaux = crra(c,sigma) + beta*vt(rest_act:end,t+1)';  % cota_inf:end, t+1 (solo tomaremos la parte factible)
        % [  ] x*y  + [ ] 1*y
        [v,pos] = max(vaux,[],2); % entregar vector columna ese 2  donde v es el valor y p es la posicion de la value funcion 
        vt(rest_act_a:end,t) = v; % Para guardar la value function dentro de la zona factible, para la posicion t
        Ap(rest_act_a:end,t) = rest_act - 1 + pos;    % Posicion de activos al sumar cota_inf -1 es rescalar a la matriz pequeña 
        Ac(rest_act_a:end,t) = A(rest_act - 1 + pos); % Valor de activos dado la posicion
        %Cp(rest_act_a:end,t) = omega(T)+(1+r).*A(rest_act:end)'-Ac(rest_act:end,end); % Cuando se despeja consumo
        rest_act = rest_act_a; % guardar la posicion anterior para en la linea 78 cuando se corre la funcion de valor que ya se calculo
end
toc

%----------------------------------------------------------------------
%% 3. Trayectorias relevantes
% ------------------------------------------------------------------------
% Trayectorias relevantes, sabemos que a_1=0.

% Activos - lt_act ------------------------------------------------------
pos_ini = sum(A<0) + 1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
lt_activos=NaN(1,T+1); % Vector que es fila de 1 hasta T Poner hasta el ultimo periodo
lt_activos(1)=A(pos_ini); % Posición en grilla activos donde encontramos el nivel de activos inicial (cero)

for i = 2:T
    pos_activos_corr = Ap(pos_ini,i-1);
    lt_activos(i) = A(pos_activos_corr);
    pos_ini = pos_activos_corr;
end

% Consumo - lt_consumo ---------------------------------------------------
% Se despeja la ecuacion que se obtiene para consumo
% Se hace loop por tema con las dimensiones
lt_consumo = omega(1:T) + lt_activos(1:T)*(1+r) - lt_activos(2:T+1); %Policy function consumption

% Ahorro - lt_ahorro -----------------------------------------------------
% Lo mismo para ahorro
lt_ahorro = omega(1:T)  - lt_consumo; %Policy function ahorro

end