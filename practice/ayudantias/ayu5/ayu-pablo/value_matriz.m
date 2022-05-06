function [Vt,At,Ct,Ap,Am,Cm] = value_matriz(T,beta,sigma,r,A,Z,liq)

%Wage
w = Z(1:T); % se repitio el mismo paso de antes

%Access to credit - vector de puros zeros
b = zeros(1,T+1); %vector de deuda maxima. En el último periodo 
% y +1 morir sin deuda (no ponzi) y no pueda acceder a deuda en el ultimo periodo
% at+1 parte con cero y termina con cero
for t = T:-1:1 % t entre -1 a 1
    b(t) = (b(t+1)-w(t))/(1+r); % ct = 0 no va a consumir nada. Deuda maxima en cada periodo  
        if b(t) >= -liq % No activa
            b(t) = b(t);
        else 
            b(t) = -liq;% Activa
        end  
end

b_pos_p = sum(A<b(end)) + 1; % Semilla para echar a correr el algoritmo
% Posición donde en la grilla de activos esta el cero se suma 1 por la
% posición

% Preallocation
Vt = NaN(length(A),T+1); %Value matrix
Vt(b_pos_p:end,end) = 0; % en esa posicion estará el cero
Ap = NaN(length(A),T);   %Asset matrix position
Am = Ap;                 %Asset matrix value
Cm = Ap;                 %Consumption matrix


%Value function iteration
for t = T:-1:1   
        b_pos = sum(A<b(t)) + 1; % posicion de la deuda maxima en el periodo t de tal modo que muera sin deduda
        c = w(t) + (1+r).*A(b_pos:end) - A(b_pos_p:end)'; % consumo fatible no es óptimo
        c(c<=0)=NaN; % la matriz resultante no es de 1001x1001 y es pirque condicioné su deuda
        % esto lo hice por b_pos para descartar la deuda que no es factible
        % y no morir endeudado 
        % 1001 -376+2 (2 de los bordes). 
        % se descartan consumos negativos

        Vaux = util(c,sigma) + beta*Vt(b_pos_p:end,t+1)';  % b_pos_p:end, t+1 (solo la parte factible)
        % [  ] x*y  + [ ] 1*y
        [V,P] = max(Vaux,[],2); % entregar vector columna ese 2  donde v es el valor y p es la posicion de la value funcion 
        Vt(b_pos:end,t) = V; 
        Ap(b_pos:end,t) = b_pos_p - 1 + P;    % al sumar b_pos_p -1 es rescalar a la matriz pequeña 
        Am(b_pos:end,t) = A(b_pos_p - 1 + P);
        Cm(b_pos:end,t) = w(t) + (1+r).*A(b_pos:end) - A(b_pos_p - 1 + P);
        b_pos_p = b_pos;
end


%Policies functions
Asset_life_pos = NaN(1,T);
Asset_life_pos(1) = sum(A<0)+1;

for t = 2:T+1
    Asset_life_pos(t) = Ap(Asset_life_pos(t-1),t-1);
end

At = A(Asset_life_pos)'; %Policy function assets
Ct = w(1:T) + (1+r)*At(1:T) - At(2:T+1); %Policy function consumption
end