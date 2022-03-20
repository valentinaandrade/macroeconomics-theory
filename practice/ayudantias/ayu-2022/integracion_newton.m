f = input ('Enter function: ');
N = input('Enter number of nodes: ');
a = input('Enter lower limit: ');
b = input('Enter upper limit: ');
h = (b-a)/N;
sum = 0;

for i = 1:N-1
    sum = sum + f(a+ i*h);
end
TP = (h/2)*(f(a) + 2*sum + f(b)) ; 
fprintf('Result using trapezoidal rule is:  %.6f\n', TP)


sum1 = 0;
for j = 1:2:N-1
    sum1= sum1 + f(a + j*h);
end
sum2= 0 ;
for k =  2:2:N-2
    sum2 = sum2 + f(a + k*h);
end
SIM = (h/3)*(f(a) + 4*sum1 + 2*sum2 + f(b));
fprintf('Result using 1/3rd Simpson rule is:  %.6f\n', SIM)

%% Ahora si pones en consola newton_integration te va a pedir los parámetros

