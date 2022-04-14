clear; close all;

%% Parámetros -----------------------------------------------------------

rho = 1;
A = 1;
beta = .96;
r = 0.03;

%% Caso con un A posible -------------------------------------------------

n = 10;
Cgrid = linspace(A/n, 0.9*A,n)'; % El de la mitad es el espaciado

Ugrid = util2(Cgrid, rho, beta, A); % utilidad es ordinal

figure(1)
plot(Cgrid,Ugrid), xlabel('c_2', 'FontSize',14), ylabel('utility', 'FontSize',14)

% Buscar maximo
[uopt, cell_opt] = max(Ugrid); %[utilidad, la fila donde se ubica el maximo y con eso puedo saber el consumo correcpondiente]
copt = Cgrid(cell_opt);
