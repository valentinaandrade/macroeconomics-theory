function Betas_ols = Prueba(N,M,P)


  % Hiperparametros son los que se repiten
  % P(1) , P(2) generalizacion (ojo)

    x1=unifrnd(P(1),P(2),N,M); % Serie x1 diribuida U(P(1),P(2))
    x2=chi2rnd(P(3),N,M); % Serie x2 distribuida chi^2(P(3))
    x3=trnd(P(4),N,M); % Serie x3 distribuida t(P(4))
    x0=ones(N,M); % Intercepto
    y=exprnd(1/P(5),N,M); % Serie y distribuida exp(P(5)) (Media 1/P(5))
    Betas_ols=NaN(4,M); % Inicialización de matriz
   % Beta_ols2=ones(4,M);
   %Beta_ols3=zeros(4,M);
    for i=1:M
        X_ols=[x0(:,i),x1(:,i),x2(:,i),x3(:,i)]; % Matriz de datos

        Betas_ols(:,i)=X_ols\y(:,i); % Estimadores betas por OLS forma 2
    end


    figure('Name','Distribuciones Betas','Color','w');%Cambio figura para que se vea blanco el fondo, se ve más limpio/elegante/prolijo etc 
    subplot(2,2,1);%divdo figura en 4 partes. (tenemos 4 estimadores)
    histogram(Betas_ols(1,:)); %estimador x1 de todas las muestras
    title('\beta_0','Interpreter','Tex','FontSize',14,'FontWeight','bold'); %Hagamos cosas bonitas!!
    xlabel('$\hat{\beta}$','Interpreter','laTex','FontSize',12);
    ylabel('frecuencia','FontSize',12,'FontWeight','bold')



    subplot(2,2,2);
    histogram(Betas_ols(2,:));
    title('\beta_1','Interpreter','Tex','FontSize',14,'FontWeight','bold');
    xlabel('$\hat{\beta}$','Interpreter','laTex','FontSize',12);
    ylabel('frecuencia','FontSize',12,'FontWeight','bold')
    subplot(2,2,3);
    histogram(Betas_ols(3,:));
    title('\beta_2','Interpreter','Tex','FontSize',14,'FontWeight','bold');
    xlabel('$\hat{\beta}$','Interpreter','laTex','FontSize',12);
    ylabel('frecuencia','FontSize',12,'FontWeight','bold')
    subplot(2,2,4);
    histogram(Betas_ols(4,:));
    title('\beta_3','Interpreter','Tex','FontSize',14,'FontWeight','bold');
    xlabel('$\hat{\beta}$','Interpreter','laTex','FontSize',12);
    ylabel('frecuencia','FontSize',12,'FontWeight','bold')

end