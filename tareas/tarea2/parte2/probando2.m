clear; clc
%% Step 5. Return midpoint value r_n = (a_n + b_n) /2
% 0. Parametros-----------------------------------------------------------
beta = 0.96; % Impaciencia
liq = linspace(0,9,10);
a=-0.06; b=0.1;
T = 65; % Horizonte temporal
sigma = 2; % Elastic of intertermporal substitution (IES).
% Trayectoria por edad como handle function  y luego dentro de fischer se multiplica por salario ---------
mt = 1/T;
tol=10^(-5); % tolerancia

%Grilla para Restricciones de Liquidez
r_eq=zeros(1,length(liq));

for i=1:length(liq)
error=1;    
r_0=a;r_1=b;

[~,~,~,~,lt_activos_0,~,~,~]=fisher(T, sigma, beta, r_0, liq(i));
oa_0=sum(lt_activos_0)*mt;

    while  tol<error
    r_bar=(r_1+r_0)/2;
    [~,~,~,~,lt_activos_bar,lt_consumo_bar,lt_laboral_bar,~,y_bar]=fisher(T, sigma, beta, r_bar, liq(i));
    oa_bar=sum(lt_activos_bar)*mt;
    error=abs(oa_bar);

        if sign(oa_bar)~=sign(oa_0)
            r_1=r_bar;    
        else
            r_0=r_bar;
        end

    end

disp('Solución encontrada')

r_eq(1,i)=r_bar;

end
