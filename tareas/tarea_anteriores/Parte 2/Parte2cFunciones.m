%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Tarea 2: 1.2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rol de restricciones de liquidez en contexto de equilibrio general.

%% (d.1): Gráfico
clc; clear all; close all;
%Parámetros 

T=65; 
beta = 0.96;
sigma = 2;



%Asset grid:
A=linspace(-15,25,3001);
r=linspace(0.035,0.07,15);

%Registramos en esta matriz las trayectorias de activos
Trayectoria_Act=zeros(length(r),T+1);

for i=1:15
    
    [~,~,~,~,Trayectoria_Activos,~,~]=CicloVida(T, sigma, beta, r(i));
    Trayectoria_Act(i,:)=Trayectoria_Activos;
    
end

%Oferta capital:
Of_K=sum(Trayectoria_Act,2)/T;

%Graficamos: Enchular

plot(r,Of_K,'LineWidth',2.5);title('Oferta Neta de Activos para distintas tasas de interés','FontSize',18);xlabel('Tasa de Interés','FontSize',18);ylabel('Oferta de activos','FontSize',18);


%% (d.2) Algoritmo de bisección.
%Algoritmos Bisección
close all; clc; clear all;

T=65; 
beta = 0.96;
sigma = 2;

tol=10^(-2);
error=1;
a=0.04;b=0.07;%Intervalo [a,b]
r_0=a;r_1=b;


[~,~,~,~,Trayectoria_Activos_0,~,~]=CicloVida(T, sigma, beta, r_0);

Of_Activos_0=sum(Trayectoria_Activos_0)/T;

[~,~,~,~,Trayectoria_Activos_1,~,~]=CicloVida(T, sigma, beta, r_1);

Of_Activos_1=sum(Trayectoria_Activos_1)/T;

while  tol<error
r_bar=(r_1+r_0)/2;
 
[~,~,~,~,Trayectoria_Activos_bar,~,~]=CicloVida(T, sigma, beta, r_bar);
Of_Activos_bar=sum(Trayectoria_Activos_bar)/T;
error=abs(Of_Activos_bar);

if sign(Of_Activos_bar)~=sign(Of_Activos_0)
    r_1=r_bar;    
else
    r_0=r_bar;
end


end


%% (e) En informe

%% (f) Tasa de Equilibrio, usando algoritmo de bisección para diferentes restricciones de liquidez

clear ; close all; clc;

T=65; 
beta = 0.96;
sigma = 2;

tol=10^(-2);
error=1;
a=-0.1;f=0.1;%Intervalo [a,b]



%Grilla para Restricciones de Liquidez
b=linspace(0,5,15);
r_eq=zeros(1,15);

for i=1:15

error=1;
    
r_0=a;r_1=f;

[~,~,~,~,Trayectoria_Activos_0,~,~]=CicloVidaCRestricciones(T, sigma, beta, r_0, b(i));

Of_Activos_0=sum(Trayectoria_Activos_0)/T;

[~,~,~,~,Trayectoria_Activos_1,~,~]=CicloVidaCRestricciones(T, sigma, beta, r_1, b(i));

Of_Activos_1=sum(Trayectoria_Activos_1)/T;





    while  tol<error

    r_bar=(r_1+r_0)/2;

    [~,~,~,~,Trayectoria_Activos_bar,~,~]=CicloVidaCRestricciones(T, sigma, beta, r_bar, b(i));
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

end

plot(b,r_eq,'LineWidth',3),xlabel('Restricción al endeudamiento','FontSize',18);ylabel('Tasa de Equilibrio','FontSize',18);title('Tasa de interés y Restricciones de Liquidez','FontSize',23)

Trayect_Cons=zeros(15,T);

for i=1:15
    
    [~,~,~,~,~,Cons,~]=CicloVidaCRestricciones(T, sigma, beta, r_eq(i), b(i));
    Trayect_Cons(i,:)=Cons;
    
end

%Exogen Income
y=zeros(1,T);
for i=1:T
    y(i)=1+0.07*i-0.001*i^2;
end

Correl=zeros(15,1);
for i=1:15
    aux=corrcoef(y,Trayect_Cons(i,:));
    Correl(i)=aux(2,1);
end

plot(b,Correl,'LineWidth',3);xlabel('Restricción al endeudamiento','FontSize',18);ylabel('Correlación entre consumo e ingreso','FontSize',18);title('Relación entre Consumo e Ingreso frente a las restricciones de Liquidez','FontSize',22)


