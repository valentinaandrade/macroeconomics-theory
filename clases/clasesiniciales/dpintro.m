%% Clase 7 --------------------------------------------------------------
clear; close all;

%% Parámetros -----------------------------------------------------------
% Debo darle valores
rho = 2; % si mayor es rho más suavizo el consumo (concavidad) 
A = 1; % Es el W en el problema del cake
beta = .5; % 0.5 mas impaciente y 0.95 menos impaciente

%% 1. Caso con un A posible -------------------------------------------------

n = 10; % con 1000 parece logaritmica
Cgrid = linspace(A/n, 0.9*A,n)'; % El ultimo es el espaciado C = [ 0.1 x x x x xx 0.9]'

Ugrid = util2(Cgrid, rho, beta, A); % utilidad es ordinal U = [ x x x x x x x]' max(U)

figure(1)
plot(Cgrid,Ugrid), xlabel('c_2', 'FontSize',14), ylabel('utility', 'FontSize',14)

% Buscar maximo
[uopt, cell_opt] = max(Ugrid); %[utilidad, la fila donde se ubica el maximo y con eso puedo saber el consumo correcpondiente]
copt = Cgrid(cell_opt); 

%uopt = value function... la utilidad en el optimo
% cell_opt es la posicion, entonces puedo obtener la policy function

%% 2. V_1(S) --------------------------------------------------------------

nc = 1000; 
nA = 100;
Agrid = linspace(A/nA,A,nA);
Cgrid = linspace(A/nc, 0.999*A, nc)';

Ugrid= util2(Cgrid, rho, beta, Agrid);
size(Ugrid)
[uopt, cell_opt]=max(Ugrid);
copt = Agrid'-Cgrid(cell_opt); % consumo del primer periodo 

figure(2) % Policy function
plot(Agrid, copt), xlabel('Assets', 'FontSize',14), ylabel('c_1', 'FontSize',14), title('Policy function', 'FontSize',14)
figure(3) % Value function
plot(Agrid, uopt), xlabel('Assets', 'FontSize',14), ylabel('c_1', 'FontSize',14),  title('Value function', 'FontSize',14)

%% V_2(S) ---------------------------------------------------------------
%%% Value function iteration : one iteration 

Ap_grid = linspace(A/nc, 0.999*A, nc)';
%%% No evaluo todo en A para evitar consumir todo o nada
Vp =interp1(Agrid, uopt, Ap_grid); %% griddedInterpolant
%%% Interpolamos para que Vp tenga una misma dimension que la grila Ap_grid

% Plot del resultado
plot(Ap_grid,Vp)
%%% Vemos el valor de la value function de manana en funcion de S'

Ugrid = Vfun(Ap_grid, rho, beta, Agrid, Vp);

% Explorar resultados
size(Ugrid)
figure(6),plot(Ugrid(:, end/2))

% Buscar maximo en cada columna
[uopt, cell_opt] = max(Ugrid);
%uopt valor maximo
%cell_opt fila maximo --> decision del agente
copt = Agrid'-Ap_grid(cell_opt); % S' pero que esta en cell_opt

figure(5) % Policy function
plot(Agrid, copt), xlabel('Assets', 'FontSize',14), ylabel('c_1', 'FontSize',14), title('Policy function', 'FontSize',14)
figure(6) % Value function
plot(Agrid, uopt), xlabel('Assets', 'FontSize',14), ylabel('c_1', 'FontSize',14),  title('Value function', 'FontSize',14)

%% 4. V(S) ---------------------------------------------------------------
%%% Value function iteration: multiple iterations 

%%% Nota: se podria mejorar la policy functionen forma de "cerrucho" que obtienen
%%% usando un metodo de interpolacion no lineal que se adapte a la forma
%%% concava de la funcion valor

Dist = 10000;
while Dist> 0.000001; % algoritmo que se repite hasta que se cumple la condicion de la expresion
    Vp = interp1(Agrid, uopt, Ap_grid);
    V0 = uopt; % guardamos esta informacion para calcular la medida de distancia mas abajo
    Ugrid = Vfun(Ap_grid, rho, beta, Agrid, Vp);
    [uopt, cell_opt] = max(Ugrid);
    copt = Agrid'- Ap_grid(cell_opt);
    Dist = sum(abs(uopt-V0)); % ¿distancia de matrices en forma escalar? o expresion cuadratica 
end

figure(7) % Policy function
plot(Agrid, copt), xlabel('Assets', 'FontSize',14), ylabel('c_1', 'FontSize',14), title('Policy function', 'FontSize',14)
figure(8) % Value function
plot(Agrid, uopt), xlabel('Assets', 'FontSize',14), ylabel('c_1', 'FontSize',14),  title('Value function', 'FontSize',14)
