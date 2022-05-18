function u= crra(c,sigma)
 % CRRA utilidad: parameter sigma
    if (sigma>0)
        if (sigma==1)
            u= log(c);
        else
            u= (c.^(1-sigma) -1)/(1-sigma);
        end
    else
        % Warning
        fprintf('Agente no averso al riesgo');
    end
end