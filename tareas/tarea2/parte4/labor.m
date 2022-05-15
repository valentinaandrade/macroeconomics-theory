function [vt, Api, Apf, Cpf, lt_activos, lt_consumo, lt_labor, lt_ahorro,y]=labor(T,varphi,beta,r,h)
% Funcion que resuelve el problema del agente para la decision del consumo
% y el trabajo-ocio. 
% [T]: ciclo de vida
% [varphi]: elasticidad oferta de trabajo (antes era inelastica)
% [beta]: impaciencia
% [r]: tasa de interes
% [h]: restriccion liquidez

% Parametros -------------------------------------------------------------
A=linspace(-15,25,1001); %Grilla de activos
alpha = 1/3; % elasticidad trabajo/capital
delta = 0.1; %tasa de dep
%Salario exógeno
 w= @(r,alpha,delta) (1-alpha).*((alpha)./(r+delta)).^(alpha/(1-alpha));
 z =@ (t,mu,sig) 1 +40*exp(-((log(t)-mu)/sig).^2 /2)./ (t* sig*sqrt(2*pi));
 y = z(1:T, log(32.5), 0.4)*w(r,alpha,delta);

%Resolución numérica del problema del agente-----------------------------
% Restriccion (alpha2)
%Condición sobre el crédito impuesta por el hecho de que no puede morir
%endeudado. Visto de otra manera, es una cota inferior a la policy de
%activos que puede tomar el agente y corresponde al valor presente de los
%ingresos futuros del individuo. 
a_cota_inf=zeros(1,T+1);
for j=T:-1:1
    a_cota_inf(j)=(a_cota_inf(j+1)-y(j))/(1+r);
end

%Última columna es caso especial (sabemos que se consume todo):
ponzi=sum(A<a_cota_inf(T))+1; %alpha 2
rest_act=max([ponzi, sum(A<-h)+1]);%Posiciones en la grilla de activos desde la cual
%está definida la VFunction_65 (a raíz de restricciones anteriores
%enfrentadas en t=64 sobre la policy a_65), tengo que quedarme con la más
%exigente entre la restricción de liquidez y la restricción a no morir
%endeudado, este es el cambio respecto al algoritmo de 1.1


% Preallocar
vt = NaN(length(A),T); %Aquí va la ValueFunction, cada columna es un periodo y cada fila corresponde a un nivel de activos inicial

% Ultimo periodo policy function ----------------------------------------------------------
% 1. Existencia a_66=0 por lo que cada celdita(entry) de esa columna es la policy de
% consumo (el consumo optimo es comerlo todo)
% 2. Suficiencia: Esto se da si y solo si se da solucion interna dada la
% restriccion de consumo y trabajo-ocio (l+n =1)
c_final=(((1+r).*A(rest_act:end)+y(T))/(1+varphi))'; % Restriccion consumo. Los activos a_66=0, y n= 1+l -- w(1+l)
c_final(c_final<0)=NaN; % No negatividad (mu1)
l_final=(varphi/y(T))*c_final; %Ocio cuando se está en solución interior.
l_final(l_final>1)=1; % Solucion interior
l_final(l_final<0)=0; % Wage retirement
%Volvemos a evaluar ahora que se han aplicado restricciones
c_final=(1+r)*A(rest_act:end)'+(y(T)*(1-l_final)); % se evalua el c_final y l_final
c_final(c_final<0)=NaN; % No negatividad (mu1)

vt(rest_act:end, T)=util(c_final, l_final, varphi); % value function para consumo y ocio final

Api = NaN(length(A),T); %Posición en la grilla donde encontramos el nivel de capital que maximiza
Api(rest_act:end,end)=sum(A<a_cota_inf(T+1))+1; %En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.
Apf = NaN(length(A),T); %Correspondencia entre posición en la grilla A con grilla A, del nivel de capital que maximiza.
Apf(rest_act:end,end)=A(Api(rest_act:end,end));%Policy de activos en t=65 es 0 por estructura del problema.
Cpf = NaN(length(A),T); %Política de consumo, derivada de la eq. (3) de la tarea. 
Cpf(rest_act:end, T)=c_final; %La policy de consumo en el último periodo queda definida también por el hecho de que a_66=0
Lpf = NaN(length(A),T);
Lpf(rest_act:end, T)=l_final;

%Loop para rellenar columnas 64 y hacia atrás.
tic
for t=T-1:-1:1
    ponzi_a=sum(A<a_cota_inf(t))+1;
    res_act_a=max([ponzi_a, sum(A<-h)+1]);%Posición en grilla de activos desde la cual está definida la VFunction
    %(heredada de ayer) y es la más estricta entre la restr. de liquidez y
    %la restricción de No_Ponzi(morir endeudado)

    c=(1/(1+varphi)).*((1+r)*A(res_act_a:end)'+y(t)-A(rest_act:end)); % lambda 1 y CPO22
    c(c<0)=NaN; %mu1
    l=(varphi/y(t)).*c; % Elección de ocio optima (CPO2)
    l(l>1)=1; % Solucion interior de trabajo (l+n=1) mu3
    l(l<0)=0; %Solucion esquina de trabajo (mu2)
   
    %Volver evaluar ahora con restricciones
    c=(1-l)*y(t)+(1+r)*A(res_act_a:end)'-A(rest_act:end); % se evalúa el l optimo para obtener c
    c(c<0)=NaN; % nonegatividad (mu1)

    Vaux= util(c,l,varphi)+beta*vt(rest_act:end,t+1)';
    
    [V0, api]=max(Vaux,[],2);
     
    vt(res_act_a:end,t)=V0; %Registramos Value Function
    Api(res_act_a:end,t)=api - 1 + rest_act; %Posición donde encontramos la policy de activos óptima.
    Apf(res_act_a:end,t)=A(Api(res_act_a:end,t)); %Activos optimos en la posicion optima (at+1)
    Cpf(res_act_a:end,t)=(y(t)+(1+r).*A(res_act_a:end)'- Apf(res_act_a:end,t))./(1+varphi); %restriccion lamda1 y CPO
    Lpf(res_act_a:end,t)= Cpf(res_act_a:end,t).*(varphi/y(t));
    % ((1+r)*at - at+1 + wt -ct)/wt 
    rest_act=res_act_a;  
end
toc

% Trayectorias -----------------------------------------------------------
% Activos - lt_act ------------------------------------------------------
% Trayectorias -----------------------------------------------------------
Pos_Act_Inic=sum(A<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
lt_activos=zeros(1,T+1);%Prealocamos la trayectoria
lt_activos(1)=A(Pos_Act_Inic);
for i=2:T
    Pos_Act_Corr=Api(Pos_Act_Inic,i-1);
    lt_activos(i)=A(Pos_Act_Corr);
    Pos_Act_Inic=Pos_Act_Corr;   
end

% Preallocate -------------------------------------------------------------
Pos_Act_Inic=sum(A<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
lt_labor=zeros(1,T+1);
lt_labor(1)=1-Lpf(Pos_Act_Inic,1);

for i=2:T
    Pos_Act_Corr=Api(Pos_Act_Inic,i-1);
    lt_labor(i)=1-Lpf(Pos_Act_Corr,i);
    Pos_Act_Inic=Pos_Act_Corr;   
end

% Consumo ---------------------------------------------------------------
lt_consumo=lt_activos(1:T)*(1+r)+y.*lt_labor(1:T)-lt_activos(2:T+1);

%Ahorro ------------------------------------------------------------------
lt_ahorro=y.*lt_labor(1:T)-lt_consumo;
end
