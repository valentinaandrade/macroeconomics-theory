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
% Capital grid: [w x 1]
wgrid= linspace(0,wmax,gpw)';


tic
%----------------------
% Grid choice: matrix
%----------------------
% Utility matrix: [w x w']
Caux= wgrid*ones(1,gpw) + y - wgrid'/(1+r);
Caux= Caux.*(Caux>0) + (Caux<=0)*(1e-20);
Uaux= utility(Caux);

% Preallocation
Vt= zeros(gpw,T+1);  iWpt= zeros(gpw,T);

% Time recursion
for it= T:-1:1
    
    % Utility at time t
    Vaux= Uaux + beta*Vt(:,it+1)';
    % Utility maximization
    [v,iwp]= max(Vaux, [],2);
    % Value function
    Vt(:,it)= v;
    % Capital policy index
    iWpt(:,it)= iwp;
    
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
plt= plot(wgrid,Vt(:,1:end-1));
lgd= legend([plt(1),plt(T)],'$V_0$','$V_T$'); lgd.Location= 'SouthEast';
title('Value functions'); xlabel('Capital');
% Capital policy
figure;
axes('ColorOrder',color,'NextPlot','replacechildren')
plt= plot(wgrid,Wpt(:,1:end));
lgd= legend([plt(1),plt(T)],'$K_1$','$K_{T+1}$'); lgd.Location= 'SouthEast';
title('Capital policy'); xlabel('Capital');


