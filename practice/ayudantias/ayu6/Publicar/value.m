function [Cti,Ati,S,Vf,Ap] = value(beta,sigma,r,w,A,tol,pro,tr)

e = 1;
iter = 0;
Vf = zeros(length(A),length(tr)); %Guess 


while e > tol
    
    %Prealocation
    Vp = NaN(length(A),length(tr));%Value function 
    Ap = NaN(length(A),length(tr));%Optimal asset 
    
    for i = 1 : length(pro)
        
            Caux = (1+r).*A' + w*pro(i) - A; %Consumption
            Caux(Caux<=0) = NaN;  
            Vaux= Util(Caux,sigma) + beta*tr(i,:)*Vf';%Bellman
            [Vp(:,i),Ap(:,i)]= max(Vaux,[],2);%Policy
   
    end  
    
     
    e = max(max(abs(Vf-Vp)));%Error
                              
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
S = w*pro - Cti; 
Ap = Ap';
Vf = Vf'; %value function

end