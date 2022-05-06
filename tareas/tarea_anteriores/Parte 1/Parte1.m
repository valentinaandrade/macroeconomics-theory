%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Tarea 2: 1.1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Equilibrio parcial, sin restricciones de liquidez

%% Preliminares
clc; clear all; close all;

%Parámetros 
T=65; 
beta = 0.96;
sigma = 2;
r=0.04;

%Grilla de Activos:
A=linspace(-15,25,3001);%Sugiero correr con menos puntos en la grilla por tiempo.

%Salario Exógeno
y=zeros(1,T);
for i=1:T
    y(i)=1+0.07*i-0.001*i^2;
end

%% (a) Resolución numérica del problema del agente

%Condición sobre el crédito impuesta por el hecho de que no puede morir
%endeudado. Visto de otra manera, es una cota inferior a la policy de
%activos que puede tomar el agente y corresponde al valor presente de los
%ingresos futuros del individuo.(Se puede prescindir de esto y utilizar que
%la restricción presupuestaria se cumpla con consumos mayores o iguales a 0
%pero esta manera permite más eficiencia al indicar exactamente en que
%partes de la matriz operar).

a_cota_inf=zeros(1,T+1);
for j=T:-1:1
    a_cota_inf(j)=(a_cota_inf(j+1)-y(j))/(1+r);
end

%Última columna es caso especial, hacemos a mano:

No_Ponzi=sum(A<a_cota_inf(T))+1; %Posiciones en la grilla de activos desde la cual
%está definida la VFunction_65 (a raíz de restricciones anteriores
%enfrentadas en t=T-1 sobre la policy a_T con el propósito de no morir endeudado)

V1 = NaN(length(A),T); %Aquí va la ValueFunction, cada columna es un periodo y cada fila corresponde a un nivel de activos inicial
c_65=y(65)+(1+r).*A(No_Ponzi:end);%Consumo admisibles en el último periodo. (Recordar que a_66=0)

V1(No_Ponzi:end, T)=utility(c_65, sigma);%Value function en último periodo.

Api = NaN(length(A),T); %Posición en la grilla donde encontramos el nivel de capital que maximiza
Api(No_Ponzi:end,end)=sum(A<a_cota_inf(66))+1; %En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.
Apf = NaN(length(A),T); %Correspondencia entre posición en la grilla A con grilla A, del nivel de capital que maximiza.
Apf(No_Ponzi:end,end)=A(Api(No_Ponzi:end,end));%Policy de activos en t=65 es 0 por estructura del problema.
Cpf = NaN(length(A),T); %Política de consumo, derivada de la eq. (3) de la tarea. 
Cpf(No_Ponzi:end, end)=y(T)+(1+r)*A(No_Ponzi:end)'-Apf(No_Ponzi:end,end); %La policy de consumo en el último periodo queda definida también por el hecho de que a_66=0

%Loop para rellenar columnas 64 y hacia atrás.
tic
for t=T-1:-1:1
    

    No_Ponzi_a=sum(A<a_cota_inf(t))+1;%Posición en grilla de activos desde la cual está definida la VFunction
    %(heredada de ayer con el propósito de cumplir restricción de presupuesto balanceado al final de la vida)
    
    c=y(t)+(1+r)*A(No_Ponzi_a:end)';%Consumo antes de policy de activos. 
    c=c-A(No_Ponzi:end);%Consumos posibles (columnas) para cada nivel inicial de capital (filas) permitido
    c(c<=0)=NaN;%Condición de no negatividad sobre el consumo
    
    Vaux= utility(c,sigma)+beta*V1(No_Ponzi:end,t+1)';
    
    [V0, api]=max(Vaux,[],2);
    
    V1(No_Ponzi_a:end,t)=V0; %Registramos Value Function
    
    Api(No_Ponzi_a:end,t) = No_Ponzi+api-1; %Posición donde encontramos la policy de activos óptima.
    Apf(No_Ponzi_a:end,t)=A(Api(No_Ponzi_a:end,t));%PolicyFunction de activos
    Cpf(No_Ponzi_a:end,t)=y(t)+(1+r)*A(No_Ponzi_a:end)'-Apf(No_Ponzi_a:end,t);%Policy function de consumo   
    No_Ponzi=No_Ponzi_a;  %Actualización de la condición sobre activos
    
end
toc

%Trayectorias relevantes, sabemos que a_1=0.

%Activos
Pos_Act_Inic=sum(A<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
Trayectoria_Act=zeros(1,T+1);
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

%Ingreso medio
y_mean=zeros(1,65);
y_mean(1,:)=mean(y);

%Subplots

figure
subplot(2,2,1)
plot(linspace(1,65,65),[y;y_mean],'LineWidth',3);ylim([1,2.5]);title('Trayectoria del Ingreso','FontSize',23,'Interpreter','Latex');
subtitle('En naranjo el ingreso promedio','FontSize',15,'Interpreter','Latex');
subplot(2,2,2)
plot(Trayectoria_Act,'LineWidth',3);ylim([-7.5,2]);title('Trayectoria del Stock de Activos','FontSize',23,'Interpreter','Latex')
subplot(2,2,3)
plot(Trayectoria_Ahorro,'LineWidth',3);ylim([-1,1]);title('Trayectoria del Flujo de Ahorros','FontSize',23,'Interpreter','Latex')
subplot(2,2,4)
plot(Trayectoria_Cons,'LineWidth',3);ylim([1,2]);title('Trayectoria del Consumo','FontSize',23,'Interpreter','Latex')

%Correlaciones solicitadas:

corr_y_cons=corrcoef(y,Trayectoria_Cons);
corr_y_cons=corr_y_cons(1,2);

%% (b) Evaluando aproximaciones usando ec de Euler.
constant=(beta*(1+r))^(-1/sigma);
errors=zeros(1,64);
for k=1:T-1
    
    errors(k)=(constant*Trayectoria_Cons(k+1)-Trayectoria_Cons(k))/Trayectoria_Cons(k);
    
      
end

plot(errors,'LineWidth',2),ylim([-0.1,0.1]),title('Errores de Aproximacion','FontSize',18,'Interpreter','Latex')

%% (c) Cambio de parámetros: Utilizamos la función CicloVida
clear all;close all;clc;

%Caso 1: 
T=65; 
beta = 0.96;
sigma = 2;
r=0.07;

%Salario Exógeno
y=zeros(1,T);
for i=1:T
    y(i)=1+0.07*i-0.001*i^2;
end

%Ingreso medio
y_mean=zeros(1,65);
y_mean(1,:)=mean(y);

[V1_a, Api_a, Apf_a, Cpf_a, Trayectoria_Act_a, Trayectoria_Cons_a, Trayectoria_Ahorro_a]=...
    CicloVida(T, sigma, beta, r);

figure
subplot(2,2,1)
plot(linspace(1,65,65),[y;y_mean],'LineWidth',3);ylim([1,2.5]);title('Trayectoria del Ingreso','FontSize',23,'Interpreter','Latex');
subtitle('En naranjo el ingreso promedio','FontSize',15,'Interpreter','Latex');
subplot(2,2,2)
plot(Trayectoria_Act_a,'LineWidth',3);ylim([-2,11]);title('Trayectoria del Stock de Activos','FontSize',23,'Interpreter','Latex')
subplot(2,2,3)
plot(Trayectoria_Ahorro_a,'LineWidth',3);ylim([-2,2]);title('Trayectoria del Flujo de Ahorros','FontSize',23,'Interpreter','Latex')
subplot(2,2,4)
plot(Trayectoria_Cons_a,'LineWidth',3);ylim([1,4]);title('Trayectoria del Consumo','FontSize',23,'Interpreter','Latex')




%Caso 2: 
T=65; 
beta = 0.96;
sigma = 5;
r=0.04;

[V1_b, Api_b, Apf_b, Cpf_b, Trayectoria_Act_b, Trayectoria_Cons_b, Trayectoria_Ahorro_b]=...
    CicloVida(T, sigma, beta, r);


figure
subplot(2,2,1)
plot(linspace(1,65,65),[y;y_mean],'LineWidth',3);ylim([1,2.5]);title('Trayectoria del Ingreso','FontSize',23,'Interpreter','Latex');
subtitle('En naranjo el ingreso promedio','FontSize',15,'Interpreter','Latex');
subplot(2,2,2)
plot(Trayectoria_Act_b,'LineWidth',3);ylim([-7,4]);title('Trayectoria del Stock de Activos','FontSize',23,'Interpreter','Latex')
subplot(2,2,3)
plot(Trayectoria_Ahorro_b,'LineWidth',3);ylim([-2,2]);title('Trayectoria del Flujo de Ahorros','FontSize',23,'Interpreter','Latex')
subplot(2,2,4)
plot(Trayectoria_Cons_b,'LineWidth',3);ylim([1,4]);title('Trayectoria del Consumo','FontSize',23,'Interpreter','Latex')



