function [ct, at, s, v1,pos] = bellman(r,w,ee,tr)
% Iteracion sobre la funcion de valor
% Input
% ------------------------------------------------------------------------
% r = tasa de interes
% w = salario
% ee = estados de productividad
% tr = matriz de transicion
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
A = linspace(0,30,1001); % Grilla de activos

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



end