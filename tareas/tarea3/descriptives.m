function [tab_act, tab_consumo] = descriptives(sigma_mu,rho,lt_activos,lt_consumo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if size(sigma_mu,2) > 1 % si es un vector basicamente o escalar

    figure;
    for j= 1:length(sigma_mu)
    h(j) = subplot(2,5,j);
    histogram(lt_activos(:,end,j), 'FaceAlpha',0.5, 'EdgeColor','none','Normalization','pdf');
    sgtitle('Trayectoria activos');
    title(['$\sigma_\mu$: ', num2str(sigma_mu(j))]);
    hold on
    end
    linkaxes(h, 'xy');
    
    figure;
    for j= 1:length(sigma_mu)
    h(j) = subplot(2,5,j);
    histogram(lt_consumo(:,end,j), 'FaceAlpha',0.5, 'EdgeColor','none','Normalization','pdf');
    sgtitle('Trayectoria consumo');
    title(['$\sigma_\mu$: ', num2str(sigma_mu(j))]);
    hold on
    end
    linkaxes(h, 'xy');
    
    % Para ver mejor la compracion
    figure;
    histogram(lt_activos(:,end,1), 'Normalization','pdf');
    hold on
    histogram(lt_activos(:,end,10), 'Normalization','pdf');
    histogram(lt_activos(:,end,5), 'Normalization','pdf');
    legend('$\sigma_\mu$: 0.1','$\sigma_\mu$: 0.14', '$\sigma_\mu$: 0.19');
    title('Trayectoria de activos segun volatilidad')
    
    figure;
    histogram(lt_consumo(:,end,1), 'Normalization','pdf');
    hold on
    histogram(lt_consumo(:,end,10), 'Normalization','pdf');
    histogram(lt_consumo(:,end,5), 'Normalization','pdf');
    legend('$\sigma_\mu$: 0.1','$\sigma_\mu$: 0.14', '$\sigma_\mu$: 0.19');
    title('Trayectoria de consumo segun volatilidad')
    
    % Tabla estadisticos descriptivos
    for j= 1:length(sigma_mu)
        medias(:,j) = mean(lt_activos(:,end,j),'all');
        mediana(:,j) = median(lt_activos(:,end,j),'all');
        vari(:,j) = var(lt_activos(:,end,j));
        percentil(:,j) = prctile(lt_activos(:,end),10);
        tab_act = [medias' mediana' vari' percentil'];
    end
    
    for j= 1:length(sigma_mu)
        medias(:,j) = mean(lt_consumo(:,end,j),'all');
        mediana(:,j) = median(lt_consumo(:,end,j),'all');
        vari(:,j) = var(lt_consumo(:,end,j));
        percentil(:,j) = prctile(lt_consumo(:,end),10);
        tab_consumo = [medias' mediana' vari' percentil'];
    end

else

    figure;
    for j= 1:length(rho)
    h(j) = subplot(2,5,j);
    histogram(lt_activos(:,end,j), 'FaceAlpha',0.5, 'EdgeColor','none','Normalization','pdf');
    sgtitle('Trayectoria activos');
    title(['$\rho$: ', num2str(rho(j))]);
    hold on
    end
    linkaxes(h, 'xy')
    
    figure;
    for j= 1:length(rho)
    h(j) = subplot(2,5,j);
    histogram(lt_consumo(:,end,j), 'FaceAlpha',0.5, 'EdgeColor','none','Normalization','pdf');
    sgtitle('Trayectoria consumo');
    title(['$\rho$: ', num2str(rho(j))]);
    hold on
    end
    linkaxes(h, 'xy')
    
    % Para ver mejor la compracion
    figure;
    histogram(lt_activos(:,end,1), 'Normalization','pdf');
    hold on
    histogram(lt_activos(:,end,9), 'Normalization','pdf');
    histogram(lt_activos(:,end,4), 'Normalization','pdf');
    legend('$\rho$: 0.9','$\rho$: 0.93', '$\rho$: 0.98');
    title('Trayectoria de activos segun persistencia')
    
    figure;
    histogram(lt_consumo(:,end,1), 'Normalization','pdf');
    hold on
    histogram(lt_consumo(:,end,9), 'Normalization','pdf');
    histogram(lt_consumo(:,end,4), 'Normalization','pdf');
    legend('$\rho$: 0.9','$\rho$: 0.93', '$\rho$: 0.98');
    title('Trayectoria de consumo segun persistencia')
    
    % Tabla estadisticos descriptivos
    for j= 1:length(rho)
        medias(:,j) = mean(lt_activos(:,end,j),'all');
        mediana(:,j) = median(lt_activos(:,end,j),'all');
        vari(:,j) = var(lt_activos(:,end,j));
        percentil(:,j) = prctile(lt_activos(:,end),10);
        tab_act = [medias' mediana' vari' percentil'];
    end
    
    for j= 1:length(rho)
        medias(:,j) = mean(lt_consumo(:,end,j),'all');
        mediana(:,j) = median(lt_consumo(:,end,j),'all');
        vari(:,j) = var(lt_consumo(:,end,j));
        percentil(:,j) = prctile(lt_consumo(:,end),10);
        tab_consumo = [medias' mediana' vari' percentil'];
    end


end