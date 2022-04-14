function figuredescriptive(XMatrix1, YMatrix1)
%CREATEFIGURE(XMatrix1, YMatrix1)
%  XMATRIX1:  matrix of plot x data
%  YMATRIX1:  matrix of plot y data

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple line objects using matrix input to plot
plot1 = plot(XMatrix1,YMatrix1,'Parent',axes1);
set(plot1(1),'DisplayName','Petróleo Brent (dólares/barril)');
set(plot1(2),'DisplayName','Cobre refinado BML (dólares/libra)');
set(plot1(3),'DisplayName','IPC');

% Create ylabel
ylabel({'Precio (promedio)'});

% Create xlabel
xlabel({'Tiempo (mensual)'});

% Create title
title('Serie petróleo, cobre e inflación');

box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontName','Cambria Math','FontSize',8);
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.55185480107474 0.832680016167055 0.35297619047619 0.0976190476190474]);

