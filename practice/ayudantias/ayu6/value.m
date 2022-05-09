function [Cti,Ati,S,Vf,Ap] = value(beta,sigma,r,w,A,tol,pro,tr)

e = 1; % error 
iter = 0; % contador antes de converger a la solucion numerica
Vf = zeros(length(A),length(tr)); % Guess de que la funcion valor es 0 para iniciar la iteracion de funcion valor 


while e > tol
    
    %Prealocation
    Vp = NaN(length(A),length(tr));%Value function pero evaluada en el periodo anterior. El algoritmo se trata de igualar ambas funciones
    Ap = NaN(length(A),length(tr));%Optimal asset policys optimas
    
    for i = 1 : length(pro) % desde el nivel de productividad mas bajo al mas alto
        
            Caux = (1+r).*A' + w*pro(i) - A; %Consumption en ausencia de gobierno, factible
            Caux(Caux<=0) = NaN;  % Consumo no negativo
            Vaux= Util(Caux,sigma) + beta*tr(i,:)*Vf';%Bellman
            [Vp(:,i),Ap(:,i)]= max(Vaux,[],2);%Policy- aqui estan los optimos
   
    end  
    
     
    e = max(max(abs(Vf-Vp)));%Error % primer max vf -  vp (con el guess), absoluto, y el valor maximo de ese max es el valor maximo. con ese escalar
                             % es la esencia del punto fijo Tv = v 
    iter = iter + 1 ;
    Vf = Vp;
    
    if iter == 200 
         break
    end
    
end


fprintf('____________________________________________________________\n');
fprintf(...
'Convergencia de la función de Valor en %d iteraciones para tolerancia de %0.0e \n',...
[iter,tol]);
fprintf('Error de aproximación: %0.2f \n',e);
fprintf('_____________________________________________________________\n');


Cti = (1+r)*A + w*pro - A(Ap'); %Optimal consumption
Ati = A(Ap'); %Optimal assets
S = w*pro - Cti; % Ahorro
Ap = Ap';
Vf = Vf'; %value function

end