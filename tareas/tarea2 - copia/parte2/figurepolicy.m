function figurepolicy(T, vt, Ap,Cp)
% Funcion que contiene opciones para hacer figuras
A = linspace(-15,25,1001); % Tienen como deuda maxima -15 y ahorro 25

% Graph font
set(groot,'DefaultTextInterpreter','Latex');
% Legend font
set(groot, 'DefaultLegendInterpreter', 'Latex');
% Line width
set(groot, 'DefaultAxesFontSize',12);

% Color grid
color= [linspace(0.0000, 0.4940, T)',...
        linspace(0.4470, 0.1840, T)',...
        linspace(0.7410, 0.5560, T)'];

% Value function
figure;
axes('ColorOrder',color,'NextPlot','replacechildren')
subplot(2,2,1)
plt= plot(A,vt(:,1:end));
lgd= legend([plt(1),plt(T)],'$V_0$','$V_T$'); lgd.Location= 'SouthEast';
title('Value function'); xlabel('Capital');
% Capital policy

subplot(2,2,2)
plt= plot(A,Ap(:,1:end));
lgd= legend([plt(1),plt(T)],'$A_1$','$A_{T+1}$'); lgd.Location= 'SouthEast';
title('Policy Capital'); xlabel('Capital');
% Consumption policy

subplot(2,1,2)
plt= plot(A,Cp(:,1:end));
lgd= legend([plt(1),plt(T)],'$C_1$','$C_{T+1}$'); lgd.Location= 'SouthEast';
title('Policy Consumption'); xlabel('Capital');
end