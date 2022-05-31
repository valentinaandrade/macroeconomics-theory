%% Parte 1 ---------------------------------------------------------------
% Ausencia de gobierno ---------------------------------------------------
clear; close all; clc
rng; % Controlar reproducibilidad
% 0. Parametros ---------------------------------------------------------
rho = 0.96; % Persistencia
sigma_mu = 0.12; % Volatilidad
delta = 0.05; % Depreciacion
alpha = 0.33; % Complementariedad K y L
n_e = 5; % Numero de estados posibles de productividad
A = linspace(0,30,1001); % Grilla de activos, parte de cero, sin endeudamiento

% Especificos del problema
r = 0.03;
w = 1;

% Estados de productividad -----------------------------------------------
% Para poder resolver el problema necesitamos obtener los distintos estados
% posibles de productividad, dado que la funcion de valor depende de estos.
% Para ello ocuparemos la funcion discAR que entrega como output los
% estados posibles y la matriz de transicion, segun los parametros de
% persistencia y volatilidad entregados

[ee, tr] = discAR(n_e,rho,sigma_mu);

%% (a) Resolver el problema del agente: sin incertidumbre ni posibilidad de endeudarse
[ct, at, ~, v1,pos] = bellman(r,w,ee,tr);

%% (b) Figuras de politica 
policyfigures(ct, at, v1, ee)

% Adicional ahorro precautorio

%% (c) Simule las trayectorias de shocks de productividad
%para  individuos durante  periodos. Grafique la trayectoria del 1 agente
n = 10000; % numero de individuos
t1= 2000; % periodos
t0= 1000; % periodos que descartare depsues, asique que son irrelevantes para el analisis mas adelante
[panel_shocks] = shocks(n,t1,tr,ee);

figure
subplot (1,2,1)
plot(linspace(1,t1,t1),[mean(panel_shocks);mean(panel_shocks(:,t0+1:end),'all')*ones(1,t1)])
title('Trayectoria media de los shocks')
legend('Medias segun periodo','Media para $t>1000$');
subplot (1,2,2)
plot((1:t1), panel_shocks(1,:))
title('Simulacion para un agente')


%% (d) Trayectorias de consumo y activos ante shocks
% Si el individuo tiene shocks en su productividad, y queremos saber que
% pasa con su consumo y ahorro, en el fondo necesitaremos saber como eso
% afecta a la trayectoria de productividad. 
% Entonces simularemos como siempre la trayectoria de activos y consumo
% pero condicional al shock
% Preallocar trayectorias y transponer dimension de posicion optima
lt_activos=zeros(n,t1-t0+1);
lt_consumo=zeros(n,t1-t0+1);%Prealocamos trayectoria del consumo
position=pos';

tic 
for k=0:9 % Se ira rellenando lt_activos para cada 1000 individuos, asi es mas rapido
        for t=2:t1-t0+2
            for i=(k*n/10)+1:(k+1)*(n/10) % Aqui se ve la segmentacion de la poblacion
            pos_act=sum(A<(lt_activos(i,t-1)))+1; % Registramos la posicion optima de la grilla en el pasado
                for j=1:length(ee) % Para cada nivel de productividad
                    if panel_shocks(i,t-1)==ee(j) % Si el shock en el periodo anterior es igual al nivel de productividad
                    lt_activos(i,t)=A(position(pos_act,j));  % Entonces la posicion optima de activos es la donde ocurre el shock
                    end
                end
            end   
        end
end
toc 


for t=1:t1-t0+1
    for i=1:n
        lt_consumo(i,t)=(1+r)*lt_activos(i,t)+w*panel_shocks(i,t)-lt_activos(i,t+1);        
    end
end

% Figuras ----------------------------------------------------------------
figure
subplot(2,1,1);
histogram(lt_activos(:,end),'Normalization','pdf'),xlim([0,27]);title('Distribucion del stock de activos','FontSize',20);
ylim([0,0.5]);
dim = [.3 .5 .4 .4];
str = ['media:',num2str(mean(lt_activos(:,end),'all')),'  mediana:',num2str(median(lt_activos(:,end),'all')),'  \sigma:',num2str(var(lt_activos(:,end))), '  percentil:', num2str(prctile(lt_activos(:,end),10)), '(10);', num2str(prctile(lt_activos(:,end),90)), '(90); ', num2str(prctile(lt_activos(:,end),99)), '(99)'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

subplot(2,1,2);
histogram(lt_consumo(:,end),'Normalization','pdf'),xlim([0.3,3]);
title('Distribucion del consumo','FontSize',20);
ylim([0,3])
dim = [.3 .2 .2 .2];
str = ['media:',num2str(mean(lt_consumo(:,end),'all')),'  mediana:',num2str(median(lt_consumo(:,end),'all')),'  \sigma:',num2str(var(lt_consumo(:,end))), '  percentil:', num2str(prctile(lt_consumo(:,end),10)), '(10);', num2str(prctile(lt_consumo(:,end),90)), '(90); ', num2str(prctile(lt_consumo(:,end),99)), '(99)'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');



%% (e) Efecto de la volatilidad
% Utilice el vector de volatilidad  y compute nuevamente la estadísica descriptiva solicitidada en el ítem anterior. 
% Explique cómo y por qué cambian sus resultados e interprete económicamente.
sigma_mu = linspace(0.10, 0.19,10);
for i = 1:length(sigma_mu)
[ct, at, s, v1,pos, panel_shocks, lt_consumo(:,:,i),lt_activos(:,:,i)] = bellman2(r,w, sigma_mu(i),rho);
end

figure;
for j= 1:length(sigma_mu)
subplot(2,5,j)
histogram(lt_activos(:,end,j), 'FaceAlpha',0.5, 'EdgeColor','none','Normalization','pdf');
sgtitle('Trayectoria activos');
title(['$\sigma_\mu$: ', num2str(sigma_mu(j))]);
hold on
end

figure;
for j= 1:length(sigma_mu)
subplot(2,5,j)
histogram(lt_consumo(:,end,j), 'FaceAlpha',0.5, 'EdgeColor','none','Normalization','pdf');
sgtitle('Trayectoria consumo');
title(['$\sigma_\mu$: ', num2str(sigma_mu(j))]);
hold on
end

% Para ver mejor la compracion
figure;
histogram(lt_activos(:,end,1), 'Normalization','pdf');
hold on
histogram(lt_activos(:,end,10), 'Normalization','pdf');
histogram(lt_activos(:,end,5), 'Normalization','pdf');
legend('$\sigma_\mu$: 0.1','$\sigma_\mu$: 0.14', '$\sigma_\mu$: 0.19');
title('Trayectoria de activos segun volatilidad')

figure;
histogram(lt_consumo(:,end,1), 'Normalization','pdf');
hold on
histogram(lt_consumo(:,end,10), 'Normalization','pdf');
histogram(lt_consumo(:,end,5), 'Normalization','pdf');
legend('$\sigma_\mu$: 0.1','$\sigma_\mu$: 0.14', '$\sigma_\mu$: 0.19');
title('Trayectoria de consumo segun volatilidad')

% Tabla estadisticos descriptivos
for j= 1:length(sigma_mu)
    medias(:,j) = mean(lt_activos(:,end,j),'all');
    mediana(:,j) = median(lt_activos(:,end,j),'all');
    vari(:,j) = var(lt_activos(:,end,j));
    percentil(:,j) = prctile(lt_activos(:,end),10);
    tab_act = [medias' mediana' vari' percentil'];
end

for j= 1:length(sigma_mu)
    medias(:,j) = mean(lt_consumo(:,end,j),'all');
    mediana(:,j) = median(lt_consumo(:,end,j),'all');
    vari(:,j) = var(lt_consumo(:,end,j));
    percentil(:,j) = prctile(lt_consumo(:,end),10);
    tab_consumo = [medias' mediana' vari' percentil'];
end

