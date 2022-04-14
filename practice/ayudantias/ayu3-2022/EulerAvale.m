function F = EulerA(Beta,Alpha, y_1, y_2, r ,p, S)

F = y_1-S-Alpha-Beta(1+r)*(p*y_21+(1-p)*y_22+(1+r)*S-Alpha);

end 

% Ecuacion de euler sustituida