function [Cti,Ati,S,Vf,Ap] = value_loop(beta,sigma,r,w,A,tol,pro,tr)
 
e = 1;
iter = 0;
Vf = zeros(length(A),length(pro));
printer = 200;

while e > tol
    Vp = NaN(length(A),length(pro));%función de valor
    Ap = NaN(length(A),length(pro));%política de activos
    
    for i = 1 : length(pro)
            for j = 1 : length(A)

                C = (1+r)*A(j) + w*pro(i) - A;%Consumption
                C(C<=0) = NaN;
                Vaux = Util(C,sigma) + beta*tr(i,:)*Vf';%Bellman  
                [v,p] = max(Vaux);
                Vp(j,i) = v;%Max value
                Ap(j,i) = p;%Max position
                
            end        
    end
    
    e = max(max(abs(Vf - Vp)));%error
    Vf = Vp;
    iter = iter + 1 ;
    
    if mod(iter,printer)==0
        fprintf('Diferencia: %0.3f \n',e);
    end
    
    if iter == 200 
        break
    end
      
end

fprintf('__________________________________________________________________\n');
fprintf('Convergencia en %d iteraciones para tolerancia de %0.0e \n',[iter,tol]);
fprintf('Diferencia: %0.2e \n',e);
fprintf('__________________________________________________________________\n');


Cti = (1+r)*A + w*pro -A(Ap');
Ati = A(Ap');
S = w*pro - Cti; 
Ap = Ap';
Vf = Vf';

end