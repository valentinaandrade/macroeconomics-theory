%function [r_eq, lt_activos_bar, lt_consumo,lt_labor] = bisection(a,b,liq)
% Este codigo permite obtener la resolucion del problema del agente en
% a partir de la tasa de interes de equilibrio que varia segun
% restricciones de liquidez

%0. Parametros -----------------------------------------------------------
% Del problema
beta = 0.96; % Impaciencia 
liq=linspace(0,9,10);% Restricciones de liquidez
varphi = 1.2; % Elasticidad
T=65; % Horizonte
% Del algortimo
tol=10^(-1); % Tolerancia
error=1;
a=0.034;f=0.1;%Intervalo [a,b]

% Preallocar
r_eq=zeros(1,length(liq));%Grila de tasas de equilibrio.
lt_labor=zeros(length(liq),T+1);
lt_consumo=zeros(length(liq),T);
correlation=zeros(length(liq),1);


% Loop que permite obtener la resolucion de r_eq para cada i en liq(i)
for i=1:length(liq)
error=1;
r_0=a;r_1=f;

[~, ~, ~, ~, lt_activos_0, ~, ~, ~,~]=labor(T, varphi, beta, r_0, liq(i));
oa_0=sum(lt_activos_0)/T;

[~, ~, ~, ~, lt_activos_1, ~, ~, ~,~]=labor(T, varphi, beta, r_0, liq(i));
oa_1=sum(lt_activos_1)/T;

    while  tol<error
    r_bar=(r_1+r_0)/2;

    [~, ~, ~, ~, lt_activos_bar, lt_consumo_bar, lt_labor_bar, ~,y]=labor(T, varphi, beta, r_0, liq(i));
    oa_bar=sum(lt_activos_bar)/T;
    error=abs(oa_bar);

        if sign(oa_bar)~=sign(oa_0)
            r_1=r_bar;    
        else
            r_0=r_bar;
        end

    end
disp('Solucion encontrada')

r_eq(1,i)=r_bar; % Tasa interes equilibrio
lt_consumo(i,1:T)=lt_consumo_bar; % Trayectoria de consumo para cada liq(i)
lt_labor(i,:)=lt_labor_bar; % Trayectoria laboral para cada liq(i)
end

% Oferta laboral agregada ----------------------------------------------
ol_a=sum(lt_labor,2)/T;

% Trayectoria salarios, con y en el equilibrio (linea 31) ---------------
lt_wages=zeros(length(liq),T);
for i=1:length(liq)
    for j=1:T
lt_wages(i,j)=lt_labor(i,j).*y(i);
    end
end

% Correlacion ingreso con trayectoria consumo ---------------------------
for i=1:10
    cor=corrcoef(lt_consumo(i,:),lt_wages(i,:));
    correlation(i)=cor(1,2);
    
end
