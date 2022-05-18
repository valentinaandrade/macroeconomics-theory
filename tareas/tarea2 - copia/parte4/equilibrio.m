function [r_eq, lt_consumo, lt_laboral, lt_activos, ol, correlacion]=equilibrio(a,b,liq)
T=65; 
beta = 0.96;
varphi = 1.2;

tol=10^(-1);
error=1;
r_eq=zeros(1,length(liq));%Grila de tasas de equilibrio.
lt_laboral=zeros(length(liq),T+1);
lt_consumo=zeros(length(liq),T);
lt_activos=zeros(length(liq),T+1);
y=zeros(length(liq),T);
correlacion=zeros(length(liq),1);

for i=1:length(liq)
error=1;    
r_0=a;r_1=b;

[~,~,~,~,lt_activos_0,~,~,~]=labor(T, varphi, beta, r_0, liq(i));
oa_0=sum(lt_activos_0)/T;

    while  tol<error
    r_bar=(r_1+r_0)/2;
    [~,~,~,~,lt_activos_bar,lt_consumo_bar,lt_laboral_bar,~,y_bar]=labor(T, varphi, beta, r_bar, liq(i));
    oa_bar=sum(lt_activos_bar)/T;
    error=abs(oa_bar);

        if sign(oa_bar)~=sign(oa_0)
            r_1=r_bar;    
        else
            r_0=r_bar;
        end

    end

disp('Solución encontrada')

r_eq(1,i)=r_bar;
% Trayectoria agente
lt_consumo(i,1:T)=lt_consumo_bar;
lt_laboral(i,:)=lt_laboral_bar;
lt_activos(i,:)=lt_activos_bar;
%Trayectoria ingresos
y(i,1:T)= y_bar;
lt_wages=zeros(10,T);

for i=1:length(liq)
    for j=1:T
lt_wages(i,j)=lt_laboral(i,j).*y(i,j);
    end
end

% Correlacion
for l=1:length(liq)
    cor=corrcoef(lt_consumo(l,:),lt_wages(l,:));
    correlacion(l)=cor(1,2);
end

% Agregados economia
ol = sum(lt_laboral,2)/T;

end
