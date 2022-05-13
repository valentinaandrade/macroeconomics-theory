function figurelifetime(T, w,lt_activos, lt_ahorro, lt_consumo)
% Funcion que contiene opciones para hacer figuras
% Color grid
color= [linspace(0.0000, 0.4940, T)',...
        linspace(0.4470, 0.1840, T)',...
        linspace(0.7410, 0.5560, T)'];

% Calculos promedios
wage = w(1:T); % Se evalua desde 1 hasta t y se sobrescrible
wage_mean = mean(wage)*ones(1,T); % ones es para hacer un vector de la media y asi despues graficar

consumo_mean = mean(lt_consumo)*ones(1,T);


% Figuras

figure;
sgtitle('Equilibrio parcial','FontSize', 15)
subplot(2,2,1)
plot(1:T,wage,1:T,wage_mean);
xlabel('T')
title('Evolucion salario','FontSize', 12)
legend('Salario', 'Media'); 

subplot(2,2,2)
plot(1:T+1,lt_activos(1:end))
xlabel('T')
title('Trayectoria activos','FontSize', 12)

subplot(2,2,3)
plot(1:T,lt_consumo, 1:T, consumo_mean);
xlabel('T')
title('Trayectoria consumo','FontSize', 12)
legend('Consumo', 'Media'); 

subplot(2,2,4)
plot(1:T,lt_ahorro)
xlabel('T')
title('Trayectoria ahorro','FontSize', 12)


end