function F = f_2(X, A, r)

% Define parameters
x = X(1);
y = X(2);
z = X(3);

% Define f(x)
F = [x -4*y*r + 6z*r - 1; -4*x + 5y + 18(2r-1)z - 2; x + 2(r-1)y + 2rz -  3];
end


