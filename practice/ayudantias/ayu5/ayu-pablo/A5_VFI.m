%% Deudas en el ciclo de vida - item (a)
clc; clear; close all;

%Parameters
T =65; 
beta = 0.96; 
sigma = 2; 
r = (1-beta)/beta; 
liq = 100;
A = linspace(-15,25,1001)'; % Tienen como deuda maxima -15 y ahorro 25
% Si mi restriccion de liquidez es b = 100 no es activo

%Wage as function and vector
Z  = @(t) -10^(-3)*t.^2 + 5*10^(-2)*t + 1 ; % se multiplica escalar, entonces voy a ocupar vectores
w = Z(1:T); % evaluar desde 1 hasta t
w_mean = mean(w)*ones(1,T); % ones es para hacer un vector de la media

%Value function iteration
tic
[Vt,At,Ct,Ap,Am,Cm] = value_matriz(T,beta,sigma,r,A,Z,liq);
toc


%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(6)
sgtitle('Partial Equilibrium - Matrix',tx{:},'FontSize', 20)
subplot(2,2,1)
plot(1:T,w,1:T,w_mean);
xlabel('T',tx{:})
title('Wage evolution',tx{:},'FontSize', 15)
legend('Wage', 'Mean',tx{:});

subplot(2,2,2)
plot(1:T+1,At(1:end))
xlabel('T',tx{:})
title('Assets',tx{:},'FontSize', 15)

subplot(2,2,[3,4])
plot(1:T,Ct)
xlabel('T',tx{:})
title('Consumption',tx{:},'FontSize', 15)

%% Equilibrio parcial con loop

% tic
% [Vt,At,Ct,Ap,Am,Cm] = value_loop(T,beta,sigma,r,A,Z,liq);
% toc

%Plot 
tx= {'Interpreter','Latex','FontSize', 15};

figure(2)
sgtitle('Partial Equilibrium - Loop',tx{:},'FontSize', 20)
subplot(2,2,1)
plot(1:T,w,1:T,w_mean);
xlabel('T',tx{:})
title('Wage evolution',tx{:},'FontSize', 15)
legend('Wage', 'Mean',tx{:});

subplot(2,2,2)
plot(1:T+1,At(1:end))
xlabel('T',tx{:})
title('Assets',tx{:},'FontSize', 15)

subplot(2,2,[3,4])
plot(1:T,Ct)
xlabel('T',tx{:})
title('Consumption',tx{:},'FontSize', 15)




%% Equilibrio general 

r = linspace(0.02,0.08,10);
Atp = NaN(length(r),T+1);   %Optimal asset path for each r
Aas = NaN(1,length(r));     %Aggregate asset supply 

tic
for i = 1: length(r)
[~,Atp(i,:)] = value_matriz(T,beta,sigma,r(i),A,Z,liq);
%when you use [~,palette], that means that you just want the second output of your function, and do not care the first one.

Aas(i) = (1/T)*sum(Atp(i,:));
end
toc

figure(3)
sgtitle('General Equilibrium',tx{:},'FontSize', 20)
subplot(1,2,1)
p = plot(1:T+1,Atp(:,1:end));
xlabel('T',tx{:})
title('Optimal asset path',tx{:})
lgd= legend([p(1),p(length(r))],'$r = 2\%$','$r = 8\%$',tx{:}); 
lgd.Location= 'SouthEast';
 
subplot(1,2,2)
plot(r,Aas)
xlabel('$r$',tx{:})
title('Aggregate asset supply ',tx{:})

% Obtenga un valor aproximado de la tasa de equilibrio de mercado de capitales sin hacer calculos
% tasa de interes que hace 0 los acitivos

figure;
plot(r,Aas)
yline(0,'LineStyle','-.','Label','Equilibrium','Color','red','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','LineWidth',1)
xlabel('$r$',tx{:})
title('Aggregate asset supply ',tx{:})

