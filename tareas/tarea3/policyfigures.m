function policyfigures(ct, at, v1, ee)
% Figures
global_opts;
A = linspace(0,30,1001); % Grilla de activos


figure;
sgtitle('\textbf{Problema del agente}')
subplot (2,2,1)
d = plot(A,ct(:,:));
title('\textbf{Consumption}')
legend([d(1),d(length(ee))],'$\varepsilon_1 = 0.48$','$\varepsilon_5 = 1.74$','fontsize',10,'location','SE'); 
d(1).LineWidth = 2;
d(length(ee)).LineWidth = 2;

subplot(2,2,2)
p = plot(A,at(:,:));
title('\textbf{Assets}')
legend([p(1),p(length(ee))],'$\varepsilon_1$ = 0.48',...
    '$\varepsilon_5 = 1.74$','location','SE','fontsize',10); 
p(1).LineWidth = 2;
p(length(ee)).LineWidth = 2;

subplot(2,2,[3,4])
f = plot(A,v1(:,:));
title('\textbf{Value function}');
legend([f(1),f(length(ee))],'$\varepsilon_1 = 0.48$',...
    '$\varepsilon_5 = 1.74$','fontsize',10,'location','SE'); 
f(1).LineWidth = 2;
f(length(ee)).LineWidth = 2;

end