function [beta] = algoritmo2(t,m)
%Algoritmo que produce para cada muestra de tamaño (t) un subplot de distribuciones de cada
%estimador de beta (OLS). 
% t = tamaño de muestra
% m =  numero de muestras

for i= 1:5
for j = 1:m
    X = [(ones(t(i),1)) xx(t(i),1)];
    b = [1 2 3 4 5 6 7]';
    epsilon = randn(t(i),1);
    ols = strcat('ols_',num2str(t(i)));
    ye.(ols) = X*b + epsilon;
 beta.(ols)(j,:) = (X\ye.(ols))';
end
end


%for l=1:7
 %   figure(i + 6)
  %  subplot(3,3,l);
   % histogram(beta.ols_10(:,l),100);
    %title(['\beta_',num2str(l-1)])
    %sgtitle(['Distribución \beta_{OLS} para muestras de tamaño ', num2str(t(i))])
    %snapnow
    %disp(['Muestras repetidas ', num2str(j), ' veces'])
%end 

Fields = fieldnames(beta);
l = 1;
for i = 1:length(Fields)
  figure(6)  
  subplot(2,3,i);
  histogram(beta.(Fields{i})(:,l))
  title(['Muestras de tamaño  ',num2str(t(i))])  
  sgtitle(['Distribución \beta_', num2str(l-1)]) 
  hold off
end

l = 2;
for i = 1:length(Fields)
  figure(13)  
  subplot(2,3,i);
  histogram(beta.(Fields{i})(:,l))
  title(['Muestras de tamaño  ',num2str(t(i))])  
  sgtitle(['Distribución \beta_', num2str(l-1)]) 
  hold off
end

l = 3;
for i = 1:length(Fields)
  figure(14)  
  subplot(2,3,i);
  histogram(beta.(Fields{i})(:,l))
  title(['Muestras de tamaño  ',num2str(t(i))])  
  sgtitle(['Distribución \beta_', num2str(l-1)]) 
  hold off
end

l = 4;
for i = 1:length(Fields)
  figure(15)  
  subplot(2,3,i);
  histogram(beta.(Fields{i})(:,l))
  title(['Muestras de tamaño  ',num2str(t(i))])  
  sgtitle(['Distribución \beta_', num2str(l-1)]) 
  hold off
end

l = 5;
for i = 1:length(Fields)
  figure(16)  
  subplot(2,3,i);
  histogram(beta.(Fields{i})(:,l))
  title(['Muestras de tamaño  ',num2str(t(i))])  
  sgtitle(['Distribución \beta_', num2str(l-1)]) 
  hold off
end


l = 6;
for i = 1:length(Fields)
  figure(17)  
  subplot(2,3,i);
  histogram(beta.(Fields{i})(:,l))
  title(['Muestras de tamaño  ',num2str(t(i))])  
  sgtitle(['Distribución \beta_', num2str(l-1)]) 
  hold off
end

l = 7;
for i = 1:length(Fields)
  figure(18)  
  subplot(2,3,i);
  histogram(beta.(Fields{i})(:,l))
  title(['Muestras de tamaño  ',num2str(t(i))])  
  sgtitle(['Distribución \beta_', num2str(l-1)]) 
  hold off
end
end