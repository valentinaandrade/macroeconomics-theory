function [panel_shocks] =shocks(n,t1,tr,ee)
% Funcion que permite obtener la distribucion de los shocks. Tenemos 10000
% individuos en la economia durante 20000 periodos. Cada uno de ellos puede
% enfrentar shocks en algun momento de su vida (ese es el panel). 

% Prealocamos trayectorias: 1/5 de los individuos con cada shock inicial
panel_shocks=zeros(n,t1);
for i=1:length(ee)
    panel_shocks(1+(n/length(ee))*(i-1):(n/length(ee))*(i),1)=ee(i);    
end

aux=cumsum(tr,2); % Matriz con fdp acumulada
for t=2:t1         
    for i=1:n 
          random=rand(1); % Se genera una realización de una fdp uniforme
       for j=1:length(ee) % Se verifica el estado anterior del individuo
        
           if panel_shocks(i,t-1)==ee(j) %Está condición será verdadera para algún j=1,2,3,4,5.            
           % mientras el valor de la celda de la matriz uniforme sea mayor
            %al valor de la celda de la matriz de transción acumulada, 
            %entonces irá subiendo de estado por cada iteración. 
               
               if random<aux(j,1) 
                   panel_shocks(i,t)=ee(1);                      
               end
               if random>aux(j,1) && random<aux(j,2)
                  panel_shocks(i,t)=ee(2); 
               end
               if random>aux(j,2) && random<aux(j,3) 
                   panel_shocks(i,t)=ee(3);
               end
               if  random>aux(j,3) && random<aux(j,4)
                   panel_shocks(i,t)=ee(4);
               end
               if  random>aux(j,4)
                   panel_shocks(i,t)=ee(5);
               end  
           end    
       end    
    end   
end



end