function [V1, Api, Apf, Cpf, Trayectoria_Act, Trayectoria_Cons, Trayectoria_Laboral ,Trayectoria_Ahorro]=CicloVidaOfLaboralcRestricciones(T,psi,beta,r,b)

%Asset grid:
A=linspace(-15,25,1001);


%Salario exógeno
alpha = 1/3;
delta = 0.1;
%Salario exógeno
w= @(r,alpha,delta) (1-alpha).*((alpha)./(r+delta)).^(alpha/(1-alpha));
z =@ (t,mu,sig) 0.4 +40*exp(-((log(t)-mu)/sig).^2 /2)./ (t* sig*sqrt(2*pi));
y = z(1:T, log(32.5), 0.4)*w(r,alpha,delta);

%y=zeros(1,T);
%for i=1:T
%    y(i)=(1+0.07*i-0.001*i^2);
%end


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


end
