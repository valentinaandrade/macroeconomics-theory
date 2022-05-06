function figuremultiple(A,T, sigma, beta,r,w,liq)
%Function para graficar multiples trayectorias
% Graph font
set(groot,'DefaultTextInterpreter','Latex');
% Legend font
set(groot, 'DefaultLegendInterpreter', 'Latex');
% Line width
set(groot, 'DefaultAxesFontSize',12);

% Color grid
color= [linspace(0.0000, 0.4940, T)',...
        linspace(0.4470, 0.1840, T)',...
        linspace(0.7410, 0.5560, T)'];

% Calculos promedios
wage = w(1:T); % Se evalua desde 1 hasta t y se sobrescrible
wage_mean = mean(wage)*ones(1,T); % ones es para hacer un vector de la media y asi despues graficar


% Dado que no se recomienda renombrar dinámicamente en matlab se crea cada
% objeto a mano
[~,~, ~, ~,lt_activos11, lt_ahorro11, lt_consumo11]= lifetime(A,T, sigma(1), beta,r(1),w,liq);
[~,~, ~, ~,lt_activos12, lt_ahorro12, lt_consumo12]= lifetime(A,T, sigma(1), beta,r(2),w,liq);
[~,~, ~, ~,lt_activos21, lt_ahorro21, lt_consumo21]= lifetime(A,T, sigma(2), beta,r(1),w,liq);
[~,~, ~, ~,lt_activos22, lt_ahorro22, lt_consumo22]= lifetime(A,T, sigma(2), beta,r(2),w,liq);
graph_act = [lt_activos11' lt_activos12' lt_activos21' lt_activos22'];
graph_ahorro = [lt_ahorro11' lt_ahorro12' lt_ahorro21' lt_ahorro22'];
graph_consumo = [lt_consumo11' lt_consumo12' lt_consumo21' lt_consumo22'];

% Figuras
figure1 = figure('WindowState','maximized');

%Salarios
% Create subplot
X= [wage' wage_mean'];
subplot1 = subplot(2,2,1);
hold(subplot1,'on');
plot1 = plot(X);
set(plot1(1),'DisplayName','Salario');
set(plot1(2),'DisplayName','Media');
xlabel('T');
title('Evolucion salario');
box(subplot1,'on');
hold(subplot1,'off');
legend(subplot1,'show');


% Trayectoria activos
subplot2 = subplot(2,2,2,'Parent',figure1);
hold(subplot2,'on');
plot2 = plot(graph_act, 'Parent',subplot2);
set(plot2(1),'DisplayName','$r = 0.041 , \sigma =2$');
set(plot2(2),'DisplayName','$r = 0.05 , \sigma =2$');
set(plot2(3),'DisplayName','$r = 0.041 , \sigma =8$');
set(plot2(4),'DisplayName','$r = 0.05 , \sigma =8$');
xlabel('T')
title('Trayectoria activos','FontSize', 12)
box(subplot2,'on');
hold(subplot2,'off');

%Consumo
subplot3 = subplot(2,2,3,'Parent',figure1);
hold(subplot3,'on');
plot3 = plot(graph_consumo, 'Parent',subplot3);
set(plot3(1),'DisplayName','$r = 0.041 , \sigma =2$');
set(plot3(2),'DisplayName','$r = 0.05 , \sigma =2$');
set(plot3(3),'DisplayName','$r = 0.041 , \sigma =8$');
set(plot3(4),'DisplayName','$r = 0.05 , \sigma =8$');
xlabel('T')
title('Trayectoria consumo','FontSize', 12)
box(subplot3,'on');
hold(subplot3,'off');

%Ahorro
subplot4 = subplot(2,2,4,'Parent',figure1);
hold(subplot4,'on');
plot4=plot(graph_ahorro,'Parent',subplot4);
set(plot4(1),'DisplayName','$r = 0.041 , \sigma =2$');
set(plot4(2),'DisplayName','$r = 0.05 , \sigma =2$');
set(plot4(3),'DisplayName','$r = 0.041 , \sigma =8$');
set(plot4(4),'DisplayName','$r = 0.05 , \sigma =8$');
xlabel('T')
title('Trayectoria ahorro','FontSize', 12)
box(subplot4,'on');
hold(subplot4,'off');

% Create legend
legend1 = legend(subplot4,'show');
set(legend1,...
    'Position',[0.858694049715996 0.0168487668085206 0.11831362247467 0.122864983869567]);

end