clear variables; close all; clc

% Parameters
beta= 0.9; rho= 2;
% Income
r= 0.05; y= 1;
% State space
wmin= 0; wmax= 10; gpw= 3001;
% Horizon
T= 12;

%----------------------
% Consumer's problem
%----------------------
utility= @(c)  crra(c,rho);
% Capital grid: [W x 1]
wgrid= linspace(wmin,wmax,gpw)';


tic
%----------------------
% Grid choice: loop
%----------------------

% Preallocation
Vt= zeros(gpw,T+1);
Vaux= zeros(gpw,1);
iWpt= zeros(gpw,T);


% Time recursion
for it= T:-1:1
    
    % Loop over w
    for iw= 1:gpw
        
        % Loop over w'
        for iwp= 1:gpw
            % Consumption
            c= wgrid(iw) + y - wgrid(iwp)/(1+r);
            % Utility
            if c>0
                Vaux(iw,iwp)= utility(c) + beta*Vt(iwp,it+1);
            else
                Vaux(iw,iwp)= NaN;
            end
        end      
    end
    
    % Utility maximization
    [v,ikps]= max(Vaux, [],2);
    % Value function
    Vt(:,it)= v;
    % Capital policy index
    iWpt(:,it)= ikps;
    
end
toc

% Capital policy
Wpt= zeros(gpw,T);
for it= 1:T
   Wpt(:,it)= wgrid(iWpt(:,it)); 
end


%----------------------
% Plots
%----------------------
% Graph options
graph_opt();

% Color grid
color= [linspace(0.0000, 0.4940, T)',...
        linspace(0.4470, 0.1840, T)',...
        linspace(0.7410, 0.5560, T)'];
    
% Value function
figure;
axes('ColorOrder',color,'NextPlot','replacechildren')
plt= plot(wgrid,Vt(:,1:end));
lgd= legend([plt(1),plt(T)],'$V_0$','$V_T$'); lgd.Location= 'SouthEast';
title('Value functions'); xlabel('Capital');
% Capital policy
figure;
axes('ColorOrder',color,'NextPlot','replacechildren')
plt= plot(wgrid,Wpt(:,1:end));
lgd= legend([plt(1),plt(T)],'$W_1$','$W_{T+1}$'); lgd.Location= 'SouthEast';
title('Capital policy'); xlabel('Capital');


