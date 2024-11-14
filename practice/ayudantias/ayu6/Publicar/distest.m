function [panel_S_aux,dist_f,e_bar] = distest(N,T,tr,pro)

random = rand(N,T);%Matriz con distribución uniforme
tr_acum = cumsum(tr,2);%Matriz con distribución acumulada

%prealocación
panel_S_aux = zeros(N,T); %panel de shocks de productividad
dis_t1 = ones(N,1);%todos comienzan en el peor estado de productividad en t0
panel_S_aux(:,1) = dis_t1;

for i = 1 : N 
    for j = 1 : T-1
        
        current = panel_S_aux(i,j);%período corriente
        future = 1;
        
        while random(i,j) > tr_acum(current,future)
            future = future +1; 
            %mientras el valor de la celda de la matriz uniforme sea mayor
            %al valor de la celda de la matriz de transción acumulada, 
            %entonces irá subiendo de estado por cada iteración. 
        end 
        
        panel_S_aux(i,j+1) = future;%schock de productividad en t para n.
        
    end
end

dist_f = panel_S_aux(:,end);%Grilla de productividad en estado estacionario
e_bar = mean(pro(dist_f));%shock medio de productividad.

end