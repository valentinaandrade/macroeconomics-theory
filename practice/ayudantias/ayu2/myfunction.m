function F = myfunction(x)
F = [2*x(1) - x(2) - exp(-x(1));       -(1) - 2*x(2) - exp(-x(2))];
% Esta funcion construye los valores del sistema de ecuaciones