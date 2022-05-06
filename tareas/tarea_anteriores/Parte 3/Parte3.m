%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Tarea 2: 1.3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Bienestar. 
%% Preliminares
close all;clc;clear;

T=65; 
beta = 0.96;
sigma = 2;

%Primero buscamos las tasas de equilibrio para estas restricciones
b_0=1;
b_1=5;

tol=10^(-2);
error=1;
a=-0.05;b=0.07;%Intervalo [a,b]
r_0=a;r_1=b;


[~,~,~,~,Trayectoria_Activos_0,~,~]=CicloVidaCRestricciones(T, sigma, beta, r_0,b_0);

Of_Activos_0=sum(Trayectoria_Activos_0)/T;

[~,~,~,~,Trayectoria_Activos_1,~,~]=CicloVidaCRestricciones(T, sigma, beta, r_1,b_0);

Of_Activos_1=sum(Trayectoria_Activos_1)/T;

while  tol<error
r_bar=(r_1+r_0)/2;
 
[~,~,~,~,Trayectoria_Activos_bar,~,~]=CicloVidaCRestricciones(T, sigma, beta, r_bar,b_0);
Of_Activos_bar=sum(Trayectoria_Activos_bar)/T;
error=abs(Of_Activos_bar);

if sign(Of_Activos_bar)~=sign(Of_Activos_0)
    r_1=r_bar;    
else
    r_0=r_bar;
end


end

r_eq=zeros(1,2);
r_eq(1)=r_bar;

%Para el caso de b_1=5 sabemos que la tasa es 0.0541, incluso sabemos que
%en este caso la restricción no es activa.

r_eq(2)=0.0541;

%% (h) Recuperamos nuestra función de valor.

[V1_0, Api_0, ~, ~, Trayectoria_Act_0, Trayectoria_Cons_0, Trayectoria_Ahorro_0]=CicloVidaCRestricciones(T,sigma,beta,r_eq(1),b_0);

[V1_1, Api_1, ~, ~, Trayectoria_Act_1, Trayectoria_Cons_1, Trayectoria_Ahorro_1]=CicloVidaCRestricciones(T,sigma,beta,r_eq(2),b_1);



%Computamos el vector de constantes chi que se suma

beta_aux=zeros(1,65);
for k=1:65
    beta_aux(k)=beta^(k-1);  
end

cons=zeros(1,65);
cons(65)=1;

for j=64:-1:1
    
    cons(j)=cons(j+1)+beta^(65-j)
    
    
end
cons=cons./(1-sigma); %Vector de la constante x_t

A=linspace(-15,25,3001);


%Prealocamos g

g=zeros(1,65);

%El primero a mano

pos_inic_0=sum(A<0)+1;
pos_inic_1=pos_inic_0;
g(1)=((V1_1(pos_inic,1)+cons(1))/(V1_0(pos_inic,1)+cons(1)))^(1/(1-sigma))-1;



for i=2:65
pos_corr_0=Api_0(pos_inic_0,i-1);
pos_corr_1=Api_1(pos_inic_1,i-1);
g(i)=((V1_1(pos_corr_1,i)+cons(i))/(V1_0(pos_corr_0,i)+cons(i)))^(1/(1-sigma))-1;
pos_inic_1=pos_corr_1;
pos_inic_0=pos_corr_0;

end

plot(g,'LineWidth',3),xlabel('t=1,2,..,65','FontSize',15),ylabel('g(t)','FontSize',15),title('Trayectoria de g','FontSize',23);