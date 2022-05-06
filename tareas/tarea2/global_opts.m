% Global options
% Graph font
set(groot,'DefaultTextInterpreter','Latex');
% Legend font
set(groot, 'DefaultLegendInterpreter', 'Latex');
set(groot, 'DefaultAxesFontSize',12);
% Line width
set(groot, 'DefaultLineLineWidth', 2.5);

% Color grid
color= [linspace(0.0000, 0.4940, T)',...
        linspace(0.4470, 0.1840, T)',...
        linspace(0.7410, 0.5560, T)'];
