function F = f_2(X, A, r)

% Define parameters
x = X(1);
y = X(2);
z = X(3);

% Define f(x)
F = [x -4*y*r + 6z*r - 1; -4*x + 5y + 18(2r-1)z - 2; x + 2(r-1)y + 2rz -  3];
end


syms x y z r 
eqn1 = x -4*y*r + 6*z*r == 1;
eqn2 = -4*x + 5*y + 18*(2*r-1)*z == 2;
eqn3 = x + 2*(r-1)*y + 2*r*z  ==  3;

[A,B] = equationsToMatrix([eqn1, eqn2, eqn3], [x, y, z,r])

rank(A)

X = linsolve(A,B)