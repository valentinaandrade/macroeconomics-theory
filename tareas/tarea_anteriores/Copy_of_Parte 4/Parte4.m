%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Tarea 2: 1.4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Equilibrio general, tasa endógena, oferta laboral.
%% Preliminaries
clc; clear all; close all;

%Parámetros 
T=65; 
beta = 0.96;
psi= 1.25;
r=0.047;

%Asset grid:
A=linspace(-15,25,1001);


%Salario exógeno

y=zeros(1,T);

for i=1:T
    
    y(i)=(1+0.07*i-0.001*i^2);
    
end


    
%%  Sección auxiliar: Construcción del algorirtmo en equilibrio parcial

b=8;%Restricción de liquidez


V1 = NaN(length(A),T); %Aquí va la ValueFunction, cada columna es un periodo y cada fila corresponde a un nivel de activos inicial

c_Final=(((1+r).*A+y(T))/(1+psi))';%En primer lugar partimos notando que a_66=0, por tanto cada entrada de esta columna es la policy de consumo cuando del nivel de activo al que está asociado.
%En segundo lugar hay que notar que ésta será la policy de consumo, si y
%solo si, se cumple la condición de solución interna que relaciona al
%consumo con el ocio. Por ende hay que corregir despúes para todos los l>1.
c_Final(c_Final<0)=NaN;

l_Final=(psi/y(T))*c_Final;%Computamos el ocio cuando se está en solución interior.

c_Final=(1+r)*A'+(y(T)*(1-l_Final));

V1(:, T)=utilitydef(c_Final, l_Final, psi);

Api = NaN(length(A),T); %Posición en la grilla donde encontramos el nivel de capital que maximiza
Api(:,T)=sum(A<0)+1; %En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.
Apf = NaN(length(A),T); %Correspondencia entre posición en la grilla A con grilla A, del nivel de capital que maximiza.
Apf(:,T)=A(Api(:,T));%Policy de activos en t=65 es 0 por estructura del problema.
Cpf = NaN(length(A),T); %Política de consumo, derivada de la eq. (3) de la tarea. 
Cpf(:, T)=c_Final; %La policy de consumo en el último periodo queda definida también por el hecho de que a_66=0
Lpf(:,T)=l_Final;

%Loop para rellenar columnas 64 y hacia atrás.
tic
for t=T-1:-1:1 
    
           
    c=(1/(1+psi))*((1+r)*A'+y(t)-A);
    c(c<0)=NaN;
    l=(psi/y(t))*c;%Elección de ocio
    l(l>1)=1;
    c=(1-l)*y(t)+(1+r)*A'-A;
    c(c<0)=NaN;
    c(:,1:sum(A<-b))=NaN;%Restricción de liquidez en policy
    c(1:sum(A<-b),:)=NaN;
      
     
    Vaux= utilitydef(c,l,psi)+beta*V1(:,t+1)';
    
    [V0, api]=max(Vaux,[],2);
     
    V1(:,t)=V0; %Registramos Value Function
    
    Api(:,t)=api;%Posición donde encontramos la policy de activos óptima.
    Apf(:,t)=A(Api(:,t));
    
    Cpf(:,t)=(y(t)+(1+r).*A')/(1+psi)-(Apf(:,t)/(1+psi));
   
    Lpf(:,t)=((1+r)*A'-Apf(:,t)+y(t)-Cpf(:,t))./y(t);
      
    
end
toc

Pos_Act_Inic=sum(A<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
Trayectoria_Act=zeros(1,T+1);%Prealocamos la trayectoria
Trayectoria_Act(1)=A(Pos_Act_Inic);
for i=2:T
    Pos_Act_Corr=Api(Pos_Act_Inic,i-1);
    Trayectoria_Act(i)=A(Pos_Act_Corr);
    Pos_Act_Inic=Pos_Act_Corr;   
end


Pos_Act_Inic=sum(A<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
Trayectoria_Laboral=zeros(1,T+1);%Prealocamos la trayectoria
Trayectoria_Laboral(1)=1-Lpf(Pos_Act_Inic,1);

for i=2:T
    Pos_Act_Corr=Api(Pos_Act_Inic,i-1);
    Trayectoria_Laboral(i)=1-Lpf(Pos_Act_Corr,i);
    Pos_Act_Inic=Pos_Act_Corr;   
end


%Consumo
Trayectoria_Cons=Trayectoria_Act(1:T)*(1+r)+y.*Trayectoria_Laboral(1:65)-Trayectoria_Act(2:T+1);

%Ahorro
Trayectoria_Ahorro=y.*Trayectoria_Laboral(1:65)-Trayectoria_Cons;

%% (j) Ausencia de restricciones de liquidez:
clear all; close all; clc; 

T=65; 
beta = 0.96;
psi=1.2;

tol=10^(-1);
error=1;
a=0.04;b=0.07;%Intervalo [a,b]
r_0=a;r_1=b;

[~,~,~,~,Trayectoria_Activos_0,~,~,~]=CicloVidaOfLaboral(T, psi, beta, r_0);

Of_Activos_0=sum(Trayectoria_Activos_0)/T;

[~,~,~,~,Trayectoria_Activos_1,~,~,~]=CicloVidaOfLaboral(T, psi, beta, r_1);

Of_Activos_1=sum(Trayectoria_Activos_1)/T;


while  tol<error
r_bar=(r_1+r_0)/2;
 
[~,~,~,~,Trayectoria_Activos_bar,~,~,~]=CicloVidaOfLaboral(T, psi, beta, r_bar);
Of_Activos_bar=sum(Trayectoria_Activos_bar)/T;
error=abs(Of_Activos_bar);

if sign(Of_Activos_bar)~=sign(Of_Activos_0)
    r_1=r_bar;    
else
    r_0=r_bar;
end


end


[~,~,~,~,Trayectoria_Activos,Trayectoria_Consumo,Trayectoria_Laboral,~]=CicloVidaOfLaboral(T, psi, beta, r_bar);

figure
subplot(2,2,1)
plot(Trayectoria_Activos,'LineWidth',3),title('Stock de Activos','FontSize',16),ylabel('Nivel Activos','FontSize',13)

subplot(2,2,2)
plot(Trayectoria_Consumo,'LineWidth',3),title('Trayectoria del Consumo','FontSize',16),xlabel('Consumo','FontSize',13)

subplot(2,2,3:4)
plot(Trayectoria_Laboral,'LineWidth',3),title('Oferta Laboral','FontSize',16),ylabel('Oferta Laboral','FontSize',13)

%% (k) Efecto de las restricciones de liquidez en las trayectorias del agente

clear all; close all; clc;

T=65; 
beta = 0.96;
psi = 1.2;

tol=10^(-2);
error=1;
a=0;f=0.1;%Intervalo [a,b]
b=1;

r_0=a;r_1=f;


[~, ~, ~, ~, Trayectoria_Act_1, Trayectoria_Cons_1, Trayectoria_Laboral_1 ,~]=labor(T,psi,beta,r_1,b);

Of_Activos_1=sum(Trayectoria_Act_1)/T;

[~, ~, ~, ~, Trayectoria_Act_0, Trayectoria_Cons_0, Trayectoria_Laboral_0 ,~]=labor(T,psi,beta,r_0,b);

Of_Activos_0=sum(Trayectoria_Act_0)/T;



while  tol<error
r_bar=(r_1+r_0)/2;
 
[~,~,~,~,Trayectoria_Activos_bar,~,~,~]=labor(T, psi, beta, r_bar,b);
Of_Activos_bar=sum(Trayectoria_Activos_bar)/T;
error=abs(Of_Activos_bar);

if sign(Of_Activos_bar)~=sign(Of_Activos_0)
    r_1=r_bar;    
else
    r_0=r_bar;
end

end

%Evaluamos en tasa de equilibrio y recojemos trayectorias.
[~,~,~,~,Trayectoria_Activos_bar,Trayectoria_Cons_bar,Trayectoria_Laboral_bar,~]=labor(T, psi, beta, r_bar,b);
Of_Activos_bar=sum(Trayectoria_Activos_bar)/T;


figure
subplot(2,2,1)
plot(Trayectoria_Activos_bar,'LineWidth',3),title('Stock de Activos','FontSize',16),ylabel('Nivel Activos','FontSize',13)

subplot(2,2,2)
plot(Trayectoria_Cons_bar,'LineWidth',3),title('Trayectoria del Consumo','FontSize',16),xlabel('Consumo','FontSize',13)

subplot(2,2,3:4)
plot(Trayectoria_Laboral_bar(1:65),'LineWidth',3),title('Oferta Laboral','FontSize',16),ylabel('Oferta Laboral','FontSize',13)






%% (i)

close all;clc;clear;

T=65; 
beta = 0.96;
psi = 1.2;

tol=10^(-1);
error=1;
a=0;f=0.1;%Intervalo [a,b]




b=linspace(0,9,10);%Grilla de restricciones de liquidez
r_eq=zeros(1,10);%Grila de tasas de equilibrio.
Trayectoria_Laboral=zeros(10,66);
Trayectoria_Cons=zeros(10,65);

Correl=zeros(10,1);


for i=1:10

error=1;
    
r_0=a;r_1=f;

[~,~,~,~,Trayectoria_Activos_0,~,~,~]=labor(T, psi, beta, r_0, b(i));

Of_Activos_0=sum(Trayectoria_Activos_0)/T;

[~,~,~,~,Trayectoria_Activos_1,~,~]=labor(T, psi, beta, r_1, b(i));

Of_Activos_1=sum(Trayectoria_Activos_1)/T;





    while  tol<error

    r_bar=(r_1+r_0)/2;

    [~,~,~,~,Trayectoria_Activos_bar,Trayectoria_Cons_bar,Trayectoria_Laboral_bar,~]=labor(T, psi, beta, r_bar, b(i));
    Of_Activos_bar=sum(Trayectoria_Activos_bar)/T;
    error=abs(Of_Activos_bar);

        if sign(Of_Activos_bar)~=sign(Of_Activos_0)
            r_1=r_bar;    
        else
            r_0=r_bar;
        end

    end

disp('Terminado')

r_eq(1,i)=r_bar;
Trayectoria_Cons(i,1:65)=Trayectoria_Cons_bar;
Trayectoria_Laboral(i,:)=Trayectoria_Laboral_bar;


end

Oferta_Laboral_Agregada=sum(Trayectoria_Laboral,2)/T;


y=zeros(1,T);

for i=1:T
    
    y(i)=(1+0.07*i-0.001*i^2);
    
end
Trayec_Ingreso=zeros(10,65);
for i=1:10
    for j=1:65

Trayec_Ingreso(i,j)=Trayectoria_Laboral(i,j).*y(i);

    end
end

for i=1:10
    g=corrcoef(Trayectoria_Cons(i,:),Trayec_Ingreso(i,:));
    Correl(i)=g(1,2);
    
end

figure
plot(b,r_eq),xlabel('Restricción al endeudamiento','FontSize',15),ylabel('Tasa que equilibra','FontSize',15),title('Tasa de interés de equilibrio según restricción de liquidez','FontSize',23)
figure
plot(b,Oferta_Laboral_Agregada),xlabel('Restricción al endeudamiento','FontSize',15),ylabel('Oferta Laboral Agregada','FontSize',15),title('Oferta laboral agregada según restricción de liquidez','FontSize',23)
figure
plot(b,Correl),xlabel('Restricción al endeudamiento','FontSize',15),ylabel('Coeficiente de correlación entre consumo e ingreso','FontSize',15),title('Relación Consumo-Ingreso según restricción de liquidez','FontSize',23)

