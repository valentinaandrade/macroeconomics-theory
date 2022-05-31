function [ct, at, s, v1,pos, panel_shocks, lt_consumo,lt_activos] = bellman2(r,w, sigma_mu,rho)
% Iteracion sobre la funcion de valor
% Input
% ------------------------------------------------------------------------
% r = tasa de interes
% w = salario
% sigma_mu = volatilidad
% rho = persistencia
% Output
% ---------------------------------------------------------------------
% ct = policy consumo
% at = policy activos
% s = ahorros
% v1 = value function
% pos = Posicion optima de activos

% 0. Parametros ---------------------------------------------------------
beta = 0.96; % Impaciencia
sigma = 2; % IES
delta = 0.05; % Depreciacion
alpha = 0.33; % Complementariedad K y L
n_e = 5; % Numero de estados posibles de productividad
A = linspace(0,30,1001); % Grilla de activos

% Estados de productividad -----------------------------------------------
[ee, tr] = discAR(n_e,rho,sigma_mu);

% Preparando la iteracion ---------------------------------------------
tol = 10^-2; % tolerancia aceptada
error = 1; % error inicial para la iteracion
iter = 0; % contador de iteraciones
maxiter = 1000; %numero maximo de iteraciones, en caso contrario no hay convergencia
itershow = 10;

% Preallocar matrices relevantes en ecuacion de Bellman
v1 = ones(length(A), length(tr)); % guess de la funcion valor es una matriz de unos, y con este inicia la iteracion. Teorema mapeo contractante
% Nota sobre dimensiones: la primera es de dimension de la grilla de
% activos factibles. parte de 0 entonces no hay posibilidad de deuda. la
% segunda nos da la dimension segun estados de productividad posibles. Y
% desde esa combinacion voy decidiendo la opcion optima. 
v0 = NaN(length(A), length(tr)); % Value function en t-1
pos = NaN(length(A), length(tr)); % Posicion optima de activos

% Iteracion en la funcion de valor ----------------------------------------
tic
while error > tol
for  i = 1:length(ee) % Desde el primer nivel de productividad hasta el 5to nivel
        caux = (1+r)*A'+w*ee(i)-A; %Consumo en ausencia de gobierno y deuda, el periodo factible
        caux(caux<=0) = NaN; % Restriccion de no negatividad
        utilaux = crra(caux,sigma); % Utilidad de las distintas posibilidades de consumoo
        vaux =  utilaux+ beta*tr(i,:)*v1'; % Funcion de valor
        % tr logra obtener la esperanza o suma ponderada segun cada nivel
        % de produccion. 
        [v0(:,i), pos(:,i)] = max(vaux,[],2); % optimo value function. Se recupera para ingresar denuevo en la iteracion de la funcion de valor
        % se guarda la posicion optima de activos
end
    error = max(max(abs(v1-v0)));
    % Lo que tenemos aqui es verificar la maxima distancia entre v1 y v0 que es el
    % guess (por eso esta en valor absoluto). de esa maxima distancia entre
    % las funciones de valor obtenemos el maximo de las maximas distancias.
    % Teorema del mapeo contractante. Existencia de un punto fijo Tv = v.
    % Cuando este error es cero entonces se cumple la existencia de un
    % *unico* punto fijo. 
    v1 = v0; % volvemos a prealocar, la v0 maxima que encontramos ahora es la v1 del siguiente periodo (cuando nos devolvemos)
    
    iter = iter + 1; % Se suma una iteracion. Basicamente es como cuando descomponiamos Tv*b 
    if iter > maxiter, fprintf('No se ha encontrado solucion');% esto es en el caso que se demora mucho en converger. Nos ayuda a la eficiencia
        break % Con esto se acaba
    end
    if mod(iter,itershow) == 0
        fprintf('Iteration: %d  |  Error: %.2e \n', [iter,error])
    end
end
fprintf('__________________________________________________________________\n');
fprintf('Convergencia en %d iteraciones para tolerancia de %0.0e \n',[iter,tol]);
fprintf('Distancia: %0.2e \n',error);
fprintf('__________________________________________________________________\n');

toc

pos = pos'; 
ct = (1+r)*A + w*ee - A(pos); % Consumo optimo
at = A(pos); % Trayectoria optima de activos
s = w*ee - ct; % Trayectoria de ahorro 
% Esto es solo para presentarlas como vector y se vean bonitas
v1 = v1';

% Shocks de productividad ----------------------------------------------
n = 10000; % numero de individuos
t1= 2000; % periodos
t0= 1000; % periodos que descartare depsues, asique que son irrelevantes para el analisis mas adelante
[panel_shocks] = shocks(n,t1,tr,ee);

% Trayectorias de consumo y activos ante shocks --------------------------
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
fprintf('¡Trayectorias optimas estimadas!\n');


end