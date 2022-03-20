clc; clear all; close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Tarea 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Problema1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Problema 1, parte (a)
%%Nodos
n=11;
%%Primera función
a=-1;
b=3;
h=(b-a)/n;%El "h" en este caso no se calcula dividiendo en "n-1".
x =zeros(1,n);
for i=1:n
    if i==1
    x(i)=a+(h*i)/2;
    else
    x(i)=x(i-1)+h;
    end
end
f1x=x.^3-x.^2-x+1;
%Punto medio
PMedioF1 = sum(h*f1x);

%%Desde ahora aplican la correspondencia "n" nodos, "n-1" interválos.
%Trapezoide
x=linspace(a,b,n);
f1x=x.^3-x.^2-x+1;
h=(b-a)/(n-1);
weightsTr=zeros(1,n);
for i=1:n
     if i==1 | i==n
         weightsTr(i)=h/2;
     else
         weightsTr(i)=h;
     end   
end

TrapezoideF1=sum(f1x.*weightsTr);
%Simpson
weightsSimp=zeros(1,n);
for i=1:n
    if i==1 | i==n
        weightsSimp(i)=h/3;
    else
        if mod(i,2)~=0
            weightsSimp(i)=2*h/3;
        else
            weightsSimp(i)=4*h/3;            
        end    
    end
end
SimpsF1=sum(f1x.*weightsSimp);

Regla={'Punto Medio','Trapezoide','Simpson'};
%%Segunda función
a=-1;
b=1;
h=(b-a)/n;%El "h" en este caso no se calcula dividiendo en "n-1".
x =zeros(1,n);
for i=1:n
    if i==1
    x(i)=a+(h*i)/2;
    else
    x(i)=x(i-1)+h;
    end
end
f2x=sin(abs(pi*x));
%Punto medio
PMedioF2 = sum(h*f2x);
%Trapezoide
x=linspace(a,b,n);
f2x=sin(abs(pi*x));
h=(b-a)/(n-1);
weightsTr=zeros(1,n);
for i=1:n
     if i==1 | i==n
         weightsTr(i)=h/2;
     else
         weightsTr(i)=h;
     end   
end
TrapezoideF2=sum(f2x.*weightsTr);
%Simpson
weightsSimp=zeros(1,n);
for i=1:n
    if i==1 | i==n
        weightsSimp(i)=h/3;
    else
        if mod(i,2)~=0
            weightsSimp(i)=2*h/3;
        else
            weightsSimp(i)=4*h/3;            
        end    
    end
end
SimpsF2=sum(f2x.*weightsSimp);

%%Tabla
Regla={'Punto Medio';'Trapezoide';'Simpson'};
ErrorF1=zeros(3,1);ErrorF1(1,1)=PMedioF1-32/3;ErrorF1(2,1)=TrapezoideF1-32/3;ErrorF1(3,1)=SimpsF1-32/3;
ErrorF2=zeros(3,1);ErrorF2(1,1)=PMedioF2-4/pi;ErrorF2(2,1)=TrapezoideF2-4/pi;ErrorF2(3,1)=SimpsF2-4/pi;
T=table(Regla,ErrorF1,ErrorF2);

%% Problema 1, parte (b): Funciones en otros códigos, aquí gráficos.
clear all;
errores_f1=zeros(31,3); %Prealocamos, 1 columna por regla
f=@(x) x.^3-x.^2-x+1;a=-1;b=3;I1=32/3; %Argumentos y valor real de la integral 1
for i=1:31
    n=2*(i)+1; %Nodos impares del 3 al 61.
   errores_f1(i,1)=abs(I1-midp(f,n,a,b));
   errores_f1(i,2)=abs(I1-trapz(f,n,a,b));
   errores_f1(i,3)=abs(I1-simps(f,n,a,b));    
end

errores_f2=zeros(31,3);%Prealocamos, 1 columna por regla
g=@(x) sin(abs(x.*pi));a=-1;b=1;I2=4/pi;%Argumentos y valor real de la integral 2
for i=1:31
    n=2*(i)+1; %Nodos impares del 3 al 63.
   errores_f2(i,1)=abs(I2-midp(g,n,a,b));
   errores_f2(i,2)=abs(I2-trapz(g,n,a,b));
   errores_f2(i,3)=abs(I2-simps(g,n,a,b));    
end
lgd={'q1: Pto Medio','q2: Trapezoide','q3: Simpson'};
subplot(2,1,1); plot(linspace(3,31,15),errores_f1(1:15,1:3)),ylim([0,2]),
legend(lgd,'FontSize',15,'interpreter','latex');ylabel('Error al Aproximar I1','FontSize',13,'interpreter','latex');
title('Aproximación I1 según 3 métodos distintos','FontSize',17,'interpreter','latex');
subplot(2,1,2); plot(linspace(3,31,15),errores_f2(1:15,1:3)),ylim([0,1.3]),
legend(lgd,'FontSize',15,'interpreter','latex');ylabel('Error al Aproximar I2','FontSize',13,'interpreter','latex');
title('Aproximación I2 según 3 métodos distintos','FontSize',17,'interpreter','latex');


%% Problema 1, parte (c): Convergencia de la Integral 3
clear all;
error=1 ;tolvalue=0.0001; x0=0; %Error y semilla inicial
g=@(x)((x.^(-1))*((2*pi)^(-1/2))).*exp(-(log(x).^2)/2); %Definimos la función

%Regla 1
n_1=3;a=1;b=3;
while error>tolvalue   
x=midp(g,n_1,a,b);
error=x-x0;
x0=x;
n_1=2*n_1-1;
end
%Regla 2
n_2=3; x0=0; error=1;
while error>tolvalue   
x=trapz(g,n_2,a,b);
error=x-x0;
x0=x;
n_2=2*n_2-1;
end
%Regla 3
n_3=3; x0=0; error=1;
while error>tolvalue   
x=trapz(g,n_3,a,b);
error=x-x0;
x0=x;
n_3=2*n_3-1;
end

