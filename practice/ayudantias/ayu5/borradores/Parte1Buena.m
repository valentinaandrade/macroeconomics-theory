%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Tarea 2: 1.1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Equilibrio parcial, sin restricciones de liquidez
%% Preliminaries
clc; clear all; close all;

%Parámetros 
T=65; 
beta = 0.96;
sigma = 2;
r=0.04;

%Asset grid:
A=linspace(-15,25,2001);

%Income
y=zeros(1,T);
for i=1:T
    y(i)=1+0.07*i-0.001*i^2;
end

%% (a) Resolución numérica del problema del agente

%Última columna es caso especial, hacemos a mano:

V1 = NaN(length(A),T); %Aquí va la ValueFunction, cada columna es un periodo y cada fila corresponde a un nivel de activos inicial
c_65=y(65)+(1+r).*A;%Consumo admisibles en el último periodo. (Recordar que a_66=0)
c_65(c_65<0)=NaN;
V1(:, T)=utility(c_65, sigma);%Value function en último periodo.

Api = NaN(length(A),T); %Posición en la grilla donde encontramos el nivel de capital que maximiza
Api(:,end)=sum(A<0)+1; %En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.
Apf = NaN(length(A),T); %Correspondencia entre posición en la grilla A con grilla A, del nivel de capital que maximiza.
Apf(:,end)=A(Api(:,end));%Policy de activos en t=65 es 0 por estructura del problema.
Cpf = NaN(length(A),T); %Política de consumo, derivada de la eq. (3) de la tarea. 
Cpf(:, end)=c_65; %La policy de consumo en el último periodo queda definida también por el hecho de que a_66=0

%Loop para rellenar columnas 64 y hacia atrás.
tic
for t=T-1:-1:1 
    
    c=y(t)+(1+r)*A';%Consumo antes de policy de activos. 
    c=c-A;%Consumos posibles (columnas) para cada nivel inicial de capital (filas) permitido
    c(c<0)=NaN;%Condición de no negatividad sobre el consumo
    
    Vaux= utility(c,sigma)+beta*V1(:,t+1)';
    
    [V0, api]=max(Vaux,[],2);
     
    V1(:,t)=V0; %Registramos Value Function
    
    Api(:,t)=api;%Posición donde encontramos la policy de activos óptima.
    
    Apf(:,t)=A(Api(:,t));
    
    Cpf(:,t)=y(t)+(1+r)*A'-Apf(:,t);   
    
end
toc

%Trayectorias relevantes, sabemos que a_1=0.

%Activos
Pos_Act_Inic=sum(A<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
Trayectoria_Act=zeros(1,T+1);%Prealocamos la trayectoria
Trayectoria_Act(1)=A(Pos_Act_Inic);
for i=2:T
    Pos_Act_Corr=Api(Pos_Act_Inic,i-1);
    Trayectoria_Act(i)=A(Pos_Act_Corr);
    Pos_Act_Inic=Pos_Act_Corr;   
end

%Consumo
Trayectoria_Cons=Trayectoria_Act(1:65)*(1+r)+y-Trayectoria_Act(2:T+1);

%Ahorro
Trayectoria_Ahorro=y-Trayectoria_Cons;

%Subplots

figure
subplot(2,2,1)
plot(y)
subplot(2,2,2)
plot(Trayectoria_Act)
subplot(2,2,3)
plot(Trayectoria_Ahorro)
subplot(2,2,4)
plot(Trayectoria_Cons)

%% (b) Evaluando aproximaciones usando ec de Euler.
constant=(beta*(1+r))^(-1/sigma);
errors=zeros(1,64);
for k=1:T-1
    
    errors(k)=constant*Trayectoria_Cons(k+1)-Trayectoria_Cons(k);
    
      
end


%% (c) Cambio de parámetros: Utilizamos la función CicloVida
clear all;close all;clc;

%Caso 1: 
T=65; 
beta = 0.96;
sigma = 2;
r=0.07;

[V1_a, Api_a, Apf_a, Cpf_a, Trayectoria_Act_a, Trayectoria_Cons_a, Trayectoria_Ahorro_a]=...
    CicloVida(T, sigma, beta, r);
y=zeros(1,T);
for i=1:T
    y(i)=1+0.07*i-0.001*i^2;
end
figure
subplot(2,2,1)
plot(y)
subplot(2,2,2)
plot(Trayectoria_Act_a)
subplot(2,2,3)
plot(Trayectoria_Ahorro_a)
subplot(2,2,4)
plot(Trayectoria_Cons_a)




%Caso 2: 
T=65; 
beta = 0.96;
sigma = 5;
r=0.04;

[V1_b, Api_b, Apf_b, Cpf_b, Trayectoria_Act_b, Trayectoria_Cons_b, Trayectoria_Ahorro_b]=...
    CicloVida(T, sigma, beta, r);

figure
subplot(2,2,1)
plot(y)
subplot(2,2,2)
plot(Trayectoria_Act_a)
subplot(2,2,3)
plot(Trayectoria_Ahorro_a)
subplot(2,2,4)
plot(Trayectoria_Cons_a)


