function v= vaux( z,k0, k1, beta,delta,alpha, utility,vpp )

    % Consumption: c>0
    c= z*k0^alpha + (1-delta)*k0  - k1;
    c= max( c, 1e-20 );
    
    % Utility 
    v= utility(c) + beta*ppval(vpp,k1);     
    
end