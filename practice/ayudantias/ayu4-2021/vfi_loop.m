clear variables; close all; clc

%--------------------------------------------------------------------------
% Grid choice: loop method
%--------------------------------------------------------------------------

% Parameters
parameters;

% State space
wmin= 0; wmax= 10; gpw= 3001;
% Capital grid: [w x 1]
wgrid= linspace(wmin,wmax,gpw)';


tic

% Preallocation
Vaux= zeros(gpw,gpw);
% Initialization
err= 1;  iter= 0;  v1= zeros(gpw,1);

% VFI
while err>tolvalue
    
    % Loop over w
    for iw= 1:gpw  
        % Loop over w'
        for iwp= 1:gpw
            % Consumption
            c= wgrid(iw) + y - wgrid(iwp)/(1+r);
            % Utility
            if c>0
                Vaux(iw,iwp)= utility(c) + beta*v1(iwp);
            else
                Vaux(iw,iwp)= NaN;
            end
        end      
    end
    
    % Utility maximization
    [v0,iwp]= max(Vaux, [],2);
    % Norm
    err= max(abs(v0-v1));
    % Value update
    v1= v0;
    
    % Loop exit
    iter= iter+1;
    if iter>maxiter, fprintf('ERROR VFI'); break, end
    % Display
    if mod(iter,showiters)==0
        fprintf('Iteration: %d  |  Err: %.2e \n', [iter,err])
    end
    
end
toc

% Capital policy function
wpf= wgrid(iwp);
% Consumption policy function
cpf= wgrid + y - 1/(1+r)*wpf;


%----------------------
% Plots
%----------------------
% Graph options
graph_opt();

% Value function
figure;
plot(wgrid,v0);
title('Value function'); xlabel('Capital');

% Policy functions
figure;
subplot(2,1,1); plot(wgrid,cpf);
title('Consumption policy');
subplot(2,1,2); plot(wgrid,wpf);
title('Capital policy'); xlabel('Capital');