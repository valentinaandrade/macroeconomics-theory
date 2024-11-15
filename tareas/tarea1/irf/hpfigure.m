function hpfigure(YMatrix1)
%HP figura

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple line objects using matrix input to plot
plot1 = plot(YMatrix1,'Parent',axes1);
set(plot1(1),'DisplayName','Datos' );
set(plot1(2),'DisplayName','$\lambda$ 6.25');
set(plot1(3),'DisplayName','$\lambda$ 1600' );
set(plot1(4),'DisplayName','$\lambda$ 129000');

% Create ylabel
ylabel({'GDP per capita (constant LCU)'});

% Create xlabel
xlabel({'Series'});

% Create title
title({'Figura 6. HP -Filtering'});

box(axes1,'on');
hold(axes1,'off');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Interpreter','Latex');

