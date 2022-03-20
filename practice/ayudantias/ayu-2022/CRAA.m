function U = CRAA(c,Sigma)
    
    Ns=size(Sigma,1); % Posibles valores de sigma
    Nc=size(c,1); % Posibles valores de consumo
    U=NaN(Nc,Ns); % Inicializando la matriz de utilidad

    for i=1:Ns
        if Sigma(i,1)==1
            U(:,i)=log(c); % CRRA si sigma=1
        else
            U(:,i)=(c.^(1-Sigma(i,1))-1)/(1-Sigma(i,1)); % CRRA si sigma~=1
        end
    end

end