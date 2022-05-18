% Biseccion
T=65; 
beta = 0.96;
sigma = 2;
tol=10^(-2);
error=1;
a=-0.1;f=0.1;%Intervalo [a,b]

%Grilla para Restricciones de Liquidez
liq=linspace(0,7,8);
r_eq=zeros(1,15);

for i=1:15
r_0=a;r_1=f;
vt, Api, Apf, Cpf, lt_activos, lt_consumo, lt_ahorro,gamma, y
[~,~,~,~,Trayectoria_Activos_0,~,~,~]=fisher(T, sigma, beta,r_0,liq(i));
Of_Activos_0=sum(Trayectoria_Activos_0)/T;
[~,~,Trayectoria_Activos_1,~,~,~]=fisher(T, sigma, beta, r_1,  liq(i));
Of_Activos_1=sum(Trayectoria_Activos_1)/T;
    
    while  tol<error
    r_bar=(r_1+r_0)/2;

    [~,~,Trayectoria_Activos_bar,~,~,~]=fisher(T, sigma, beta, r_bar,   liq(i));
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

plot(liq,r_eq,'LineWidth',3),xlabel('Restricción al endeudamiento','FontSize',18);ylabel('Tasa de Equilibrio','FontSize',18);title('Tasa de interés y Restricciones de Liquidez','FontSize',23)

Trayect_Cons=zeros(15,T);

for i=1:15
    
    [~,~,~,~,Cons,~]=fisher(T, sigma, beta, r_eq(i),  liq(i));
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


