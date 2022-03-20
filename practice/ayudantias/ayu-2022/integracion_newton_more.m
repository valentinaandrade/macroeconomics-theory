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

%% Ahora si pones en consola newton_integration te va a pedir los parámetros

oddsum = 0;
for i = 1:2:N-1
    oddssum= oddsum + f(a + j*h);
end
evensum = 0 ;
for k =  2:2:N-2
    evensum = evensum + f(a + k*h);
end

SIM = (h/3)*(f(a) + 4*oddsum + 2*evensum + f(b));
fprintf('Result using 1/3rd Simpson rule is:  %.6f\n', SIM)

sum3 = 0;
for  l = 3:3:N-1
sum3 = sum3 + f(a+l*h);
end
sum4 = 0;
for m = 1:N-1
 sum4 = sum4 + f(a + m*h);
end
sumnot3 = sum4 - sum3;

SIM38 = (3*h/8) * (f(a) + 3*sumnot3 + 2*sum3 + f(b));
fprintf('Result using /3rd Simpson rule is:  %.6f\n', SIM38)


