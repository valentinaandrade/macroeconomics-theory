clear; close;

g =  linspace(0,0.01,11);
a=-0.06; b=0.1;
T=65; 
beta = 0.96;
sigma = 2;
tol=10^(-2);
mt = growth(T,g);
liq=100;

%Grilla para Restricciones de Liquidez
r_eq=zeros(1,length(g));

for i=1:length(mt)
error=1;    
r_0=a;r_1=b;

[~,~,~,~,lt_activos_0,~,~,~]=fisher(T, sigma, beta, r_0, liq);
oa_0=sum(lt_activos_0)*mt(i);

    while  tol<error
    r_bar=(r_1+r_0)/2;
    [~,~,~,~,lt_activos_bar,lt_consumo_bar,lt_laboral_bar,~,y_bar]=fisher(T, sigma, beta, r_bar, liq);
    oa_bar=sum(lt_activos_bar)*mt(i);
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
