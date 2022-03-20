%% Simulación mediante Montecarlo

% Punto 1

% Construya la matriz de datos a partir de las funciones entregadas. 
    
N=1000; % Tamaño de muestra
x1=unifrnd(1,4,N,1); % Serie x1 distribuida U(1,4). Tamaño vector N1 
x2=chi2rnd(100,N,1); % Serie x2 distribuida chi^2(100)
x3=trnd(2,N,1); % Serie x3 distribuida t(2)
x0=ones(N,1); % Intercepto
X_ols=[x0,x1,x2,x3]; % Matriz de datos



% Punto 2

y=exprnd(1/0.5,N,1); % Serie y distribuida exp(0.5) (Media 1/0.5)
Beta_ols=(X_ols'*X_ols)^(-1)*X_ols'*y; % Estimadores betas por OLS
Beta_ols2=X_ols\y; % Estimadores betas por OLS forma 2


% Más complejo
Modelo=fitlm(X_ols(:,2:end),y); % Ajustar modelo lineal con intercepto
Beta_ols3=table2array(Modelo.Coefficients(:,1)); % Estimadores betas por OLS forma 3


% Punto 3

M=1000; % Número de muestras
P=[1;4;100;2;0.5]; % Hyperparámetros de las distribuciones
Betas=Prueba(N,M,P); % Estimadores betas por OLS de cada muestra

%% Funciones

% Punto 1

Nc=101; % Número de valores de consumo
c=linspace(0,10,Nc)'; % Grilla de consumo
Sigma=[0,0.5,1,2]'; % Grilla de sigma
U = CRAA(c,Sigma); % Matriz de utilidad

% Punto 2

[U_max,Ind_max]=max(U); % Máximo de U y posición dentro de la grilla de consumo
C_max=c(Ind_max); % Consumo máximo




