function v= vaux( z,k0, k1, beta,delta,alpha, utility,vpp )

% Vaux = u(c) + beta E(V(z',k')
% sa: (1) Y = C + I  /identidad macro
%     (2) Y = e^z*k^alpha  /funcion de produccion
%     (3) I = k' - (1-delta)k  /ley de movimientos del capital

% de (1) C = Y - I, reemplazo en (2) y (3) y obetengo:
% (4) c = e^z*k^alpha - k' - (1-delta)k

    % Consumption: c>0
    c= z*k0^alpha + (1-delta)*k0  - k1; % eq (4)
    c= max( c, 1e-20 );
    
    % Utility 
    v= utility(c) + beta*ppval(vpp,k1);     
    
end