function F = myfunction(x)
% Esta funcion construye los valores del sistema de ecuaciones
F = [2*x(1) - x(2) - exp(-x(1));       -(1) - 2*x(2) - exp(-x(2))];
