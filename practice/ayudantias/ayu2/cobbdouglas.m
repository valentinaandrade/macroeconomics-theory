function y = cobbdouglas(A,x)
%Cobb Douglas function production
%x1 = linspace(0,10,1000);
%x2 = linspace(0,10,1000);
alpha = 0.4;
beta = 1- alpha;
% This creates all possible combinations of the x1 and x2 vectors, fills up the grid
%[L,K] = meshgrid(x1, x2);
% Evaluate the utility function at all x1 and x2 combination points
y =A*x(1).^alpha.*x(2).^beta;
end

