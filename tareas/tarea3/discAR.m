function [ee, tr] = discAR(n,rho,sigma_mu)
% Funcion que permite obtener una matriz de transición para los distintos
% estados de la produccion. La forma funcional que sigue el proceso AR(1) es
% log(x')= alpha + rho*log(x) + e, e~N(0,sigma).
% Input:
% ------------------------------------------------------------------------
% n = cantidad de puntos del estado
% rho = persistencia
% sigma_mu = volatilidad, medido en la varianza
% Output:
% -----------------------------------------------------------------------
% ee = estados de la productividad 
% tr= matriz de transicion desde un estadoo de productividad al otro

muX = 1;
if (n<=5), m= 1.5;  elseif (n<=7), m= 2;  else, m= 3;  end
    
% moments
sdY=   sigma_mu/sqrt(1-rho^2);
muY=   log(muX) - sdY^2/2;
c=     muY*(1-rho);

% grids
if (n>1)
    ymin=  muY - m*sdY; 
    ymax=  muY + m*sdY;
    ystep= (ymax-ymin)/(n-1);
    yg= zeros(1,n);
    for y= 1:n
       yg(y)= ymin + (y-1)*ystep;
    end
else
    yg=    muY;
end
ee=  exp(yg)';


% Transition Matrix
if (n>1)   
    tr= zeros(n,n);                             % pi{k,j}= Pr(y'=yj|y=yk)  
    
    % from y{k}
    for k= 1:n        
        
        % to y'{j}
        for j= 1:n
            tr(k,j)=  normcdf( (yg(j) + ystep/2 - c-rho*yg(k) )/sigma_mu ) ...
                    - normcdf( (yg(j) - ystep/2 - c-rho*yg(k) )/sigma_mu ); % ¿porque lo resta?
        end           
        tr(k,:) = tr(k,:)/sum(tr(k,:));
    end
    
else
    tr= 1;
end

