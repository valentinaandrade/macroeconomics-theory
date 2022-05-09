function [vt, Api, Apf, Cpf, lt_activos, lt_consumo, lt_ahorro,gamma, y]=fisher(T,sigma,beta,r,b)


%Asset grid:
A=linspace(-15,25,1001);
alpha=1/3;
delta=0.1;
w=@(r) (1- alpha).*((alpha)./(r+delta)).^(alpha/(1-alpha));

% Income
y=zeros(1,T);
for i=1:T
  gamma(i) = (1+(40/(0.4*i*(2*pi).^(1/2)))*exp((-1/2)*((log(i)-log(32.5))/0.4).^2));
  y(i) = gamma(i)*w(r);
end

%%Resolución numérica del problema del agente
%Condición sobre el crédito impuesta por el hecho de que no puede morir
%endeudado. Visto de otra manera, es una cota inferior a la policy de
%activos que puede tomar el agente y corresponde al valor presente de los
%ingresos futuros del individuo. 
a_cota_inf=zeros(1,T+1);
for j=T:-1:1
    a_cota_inf(j)=(a_cota_inf(j+1)-y(j))/(1+r);
end



%Última columna es caso especial (sabemos que se consume todo), hacemos a mano:

No_Ponzi=sum(A<a_cota_inf(T))+1; 
Restr_Act=max([No_Ponzi, sum(A<-b)+1]);%Posiciones en la grilla de activos desde la cual
%está definida la VFunction_65 (a raíz de restricciones anteriores
%enfrentadas en t=64 sobre la policy a_65), tengo que quedarme con la más
%exigente entre la restricción de liquidez y la restricción a no morir
%endeudado, este es el cambio respecto al algoritmo de 1.1

vt = NaN(length(A),T); %Aquí va la ValueFunction, cada columna es un periodo y cada fila corresponde a un nivel de activos inicial
c_Final=y(T)+(1+r).*A(Restr_Act:end);%Consumo admisibles (es solo una opción, por ende también es un óptimo para cada nivel de activo) en el último periodo. (Recordar que a_66=0)
vt(Restr_Act:end, T)=crra(c_Final, sigma);%Value function en último periodo.


Api = NaN(length(A),T); %Posición en la grilla donde encontramos el nivel de capital que maximiza (columna-periodo y fila-nivel de activo inicial).
Api(Restr_Act:end,end)=sum(A<a_cota_inf(T+1))+1; %En último periodo la elección optima es siempre el menor nivel de capital posible, esto es 0.
Apf = NaN(length(A),T); %Correspondencia entre posición en la grilla A con grilla A, del nivel de capital que maximiza.
Apf(Restr_Act:end,end)=A(Api(Restr_Act:end,end));%Policy de activos en t=65 es 0 por estructura del problema.
Cpf = NaN(length(A),T); %Política de consumo, derivada de la eq. (3) de la tarea. 
Cpf(Restr_Act:end, T)=y(T)+(1+r)*A(Restr_Act:end)'-Apf(Restr_Act:end,end); %La policy de consumo en el último periodo queda definida también por el hecho de que a_66=0

%Loop para rellenar columnas T-1 y hacia atrás.
tic
for t=T-1:-1:1
    
    No_Ponzi_a=sum(A<a_cota_inf(t))+1;
    Restr_Act_a=max([No_Ponzi_a, sum(A<-b)+1]);%Posición en grilla de activos desde la cual está definida la VFunction
    %(heredada de ayer) y es la más estricta entre la restr. de liquidez y
    %la restricción de No_Ponzi(morir endeudado)
    c=y(t)+(1+r)*A(Restr_Act_a:end)';%Consumo antes de policy de activos. 
    c=c-A(Restr_Act:end);%Consumos posibles (columnas) para cada nivel inicial de capital (filas) permitido
    c(c<=0)=NaN;%Condición de no negatividad sobre el consumo
    
    Vaux= crra(c,sigma)+beta*vt(Restr_Act:end,t+1)';
    
    [V0, api]=max(Vaux,[],2);
    
    vt(Restr_Act_a:end,t)=V0; %Registramos Value Function
    
    Api(Restr_Act_a:end,t) = api - 1 + Restr_Act; %Posición donde encontramos la policy de activos óptima.
    Apf(Restr_Act_a:end,t)=A(api - 1 + Restr_Act);%PolicyFunction de activos
    Cpf(Restr_Act_a:end,t)=y(t)+(1+r)*A(Restr_Act_a:end)'-Apf(Restr_Act_a:end,t);%Policy function de consumo
    Restr_Act=Restr_Act_a;  
    
end
toc


%Trayectorias relevantes, sabemos que a_1=0.

%Activos
Pos_Act_Inic=sum(A<0)+1;%Posición en grilla activos donde encontramos el nivel de activos inicial.
lt_activos=zeros(1,T+1);
lt_activos(1)=A(Pos_Act_Inic);

for i=2:T
    Pos_Act_Corr=Api(Pos_Act_Inic,i-1);
    lt_activos(i)=A(Pos_Act_Corr);
    Pos_Act_Inic=Pos_Act_Corr;   
end

%Consumo
lt_consumo=lt_activos(1:T)*(1+r)+y-lt_activos(2:T+1);

%Ahorro
lt_ahorro=y-lt_consumo;

end


