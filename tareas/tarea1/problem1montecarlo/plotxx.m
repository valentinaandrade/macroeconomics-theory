function [plotxx] = plotxx(mm, r,c)
% Graficar variables construidas en matriz de datos  donde
%mm = matriz de datos
% r = numero de filas
% c = numero de columnas
mm = xx(r,c);
figure(1)
subplot(3,2,1)
histogram(mm(:,1),100)
title('X1')
subplot(3,2,2)
histogram(mm(:,2),100)
title('X2')
subplot(3,2,3)
histogram(mm(:,3),100)
title('X3')
subplot(3,2,4)
histogram(mm(:,4),100)
title('X4')
subplot(3,2,5)
histogram(mm(:,5),100)
title('X5')
subplot(3,2,6)
histogram(mm(:,6),100)
title('X6')
hold off
end
