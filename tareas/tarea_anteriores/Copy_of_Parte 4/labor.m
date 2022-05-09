function [vt, Api, Apf, Cpf, lt_activos, lt_consumo, lt_labor, lt_ahorro,y]=labor(T,varphi,beta,r,h)
% Funcion que resuelve el problema del agente para la decision del consumo
% y el trabajo-ocio. 
% [T]: ciclo de vida
% [varphi]: elasticidad oferta de trabajo (antes era inelastica)
% [beta]: impaciencia
% [r]: tasa de interes
% [h]: restriccion liquidez

% Parametros -------------------------------------------------------------
A=linspace(-15,25,1001); 
alpha = 1/3;
delta = 0.1;
%Salario exógeno
w= @(r,alpha,delta) (1-alpha).*((alpha)./(r+delta)).^(alpha/(1-alpha));
z =@ (t,mu,sig) 0.4 +40*exp(-((log(t)-mu)/sig).^2 /2)./ (t* sig*sqrt(2*pi));
y = z(1:T, log(32.5), 0.4)*w(r,alpha,delta);

% Preallocar
vt = NaN(length(A),T); %Aquí va la ValueFunction, cada columna es un periodo y cada fila corresponde a un nivel de activos inicial

% Ultimo periodo policy function ----------------------------------------------------------
% 1. Existencia a_66=0 por lo que cada celdita(entry) de esa columna es la policy de
% consumo (el consumo optimo es comerlo todo)
% 2. Suficiencia: Esto se da si y solo si se da solucion interna dada la
% restriccion de consumo y trabajo-ocio (l+n =1)
c_final=(((1+r).*A+y(T))/(1+varphi))'; % Restriccion consumo
c_final(c_final<0)=NaN; % No negatividad
l_final=(varphi/y(T))*c_final; %Ocio cuando se está en solución interior.
c_final=(1+r)*A'+(y(T)*(1-l_final));
vt(:, T)=util(c_final, l_final, varphi); % value function para consumo y ocio final

Api = NaN(length(A),T); %Posición en la grilla donde encontramos el nivel de capital que maximiza
Api(:,T)=sum(A<0)+1; %En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.
Apf = NaN(length(A),T); %Correspondencia entre posición en la grilla A con grilla A, del nivel de capital que maximiza.
Apf(:,T)=A(Api(:,T));%Policy de activos en t=65 es 0 por estructura del problema.
Cpf = NaN(length(A),T); %Política de consumo, derivada de la eq. (3) de la tarea. 
Cpf(:, T)=c_final; %La policy de consumo en el último periodo queda definida también por el hecho de que a_66=0
Lpf(:,T)=l_final;

%Loop para rellenar columnas 64 y hacia atrás.
tic
for t=T-1:-1:1      
    c=(1/(1+varphi))*((1+r)*A'+y(t)-A); % restriccion 
    c(c<0)=NaN; % nonegatividad
    l=(varphi/y(t))*c; % Elección de ocio
    l(l>1)=1; % Solucion interna de trabajo (l+n=1)
    c=(1-l)*y(t)+(1+r)*A'-A;
    c(c<0)=NaN;
    c(:,1:sum(A<-h))=NaN;%Restricción de liquidez en policy
    c(1:sum(A<-h),:)=NaN; 
    Vaux= util(c,l,varphi)+beta*vt(:,t+1)';
    
    [V0, api]=max(Vaux,[],2);
     
    vt(:,t)=V0; %Registramos Value Function
    
    Api(:,t)=api;%Posición donde encontramos la policy de activos óptima.
    Apf(:,t)=A(Api(:,t));
    
    Cpf(:,t)=(y(t)+(1+r).*A')/(1+varphi)-(Apf(:,t)/(1+varphi));
   
    Lpf(:,t)=((1+r)*A'-Apf(:,t)+y(t)-Cpf(:,t))./y(t);
    
end
toc

Pos_Act_Inic=sum(A<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
lt_activos=zeros(1,T+1);%Prealocamos la trayectoria
lt_activos(1)=A(Pos_Act_Inic);
for i=2:T
    Pos_Act_Corr=Api(Pos_Act_Inic,i-1);
    lt_activos(i)=A(Pos_Act_Corr);
    Pos_Act_Inic=Pos_Act_Corr;   
end

% Preallocate
Pos_Act_Inic=sum(A<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
lt_labor=zeros(1,T+1);
lt_labor(1)=1-Lpf(Pos_Act_Inic,1);

for i=2:T
    Pos_Act_Corr=Api(Pos_Act_Inic,i-1);
    lt_labor(i)=1-Lpf(Pos_Act_Corr,i);
    Pos_Act_Inic=Pos_Act_Corr;   
end


% Consumo
lt_consumo=lt_activos(1:T)*(1+r)+y.*lt_labor(1:T)-lt_activos(2:T+1);

%Ahorro
lt_ahorro=y.*lt_labor(1:T)-lt_consumo;


end
