function [yg,Pr]= tauchen(rho,sde,m,ny)
%-------------------------------------------------------------------------%
% Process: y'= rho*y + e, e~N(0,sde^2).
%
% Discretizise space for Y with n equidistant points in [-m*sdy , m*sdy].
% Transition probabilities from state yk to state yj Pr[ y'=yj | y=yk ] are
% defined by:
%   pi(k,j) =  Pr[ yj - d(j,j-1)/2  < y'= rho*yk + e <  yj + d(j+1,j)/2 ]
% where d(i,j) denotes the distance between grid points yi and yj.
%
% Y conditional mean: E[Y'|Y]= c + rho*Y. 
% Y unconditional mean & variance: E[Y]= 0, V[Y]= sde^2/(1-rho^2)
%-------------------------------------------------------------------------%


%------------------------------%
% I. Moments
%------------------------------%
% Mean
meanY= 0;
% Standard Deviation
sdY= sde/sqrt(1-rho^2);

%------------------------------%
% II. Grid
%------------------------------%
if (ny==1)
    % Grid
    yg= meanY;
else
    % Bounds
    ymin= meanY - m*sdY;
    ymax= meanY + m*sdY;
    % Step
    step= (ymax-ymin)/(ny-1);
    % Grid
    yg= zeros(1,ny);
    for y= 1:ny
        yg(y)= ymin + (y-1)*step;
    end
end

%------------------------------%
% III. Transition Matrix
%------------------------------%
if (ny==1)
    % Non-Stochastic Problem
    Pr= 1;
else
    
    % Transition matrix preallocation
    Pr= zeros(ny,ny);     % Pr(y'=y{j}|y=y{k})
        
    % Transition from state yk
    for ik= 1:ny           
        % Transition to y'{1}
        Pr(ik,1)= normcdf( (yg(1) + step/2  -rho*yg(ik) )/sde );           
        % Transition to y'{1<j<n}
        if (ny>2)
            for ij= 2:ny-1
                Pr(ik,ij)= normcdf( (yg(ij) + step/2  -rho*yg(ik) )/sde ) ...
                         - normcdf( (yg(ij) - step/2  -rho*yg(ik) )/sde );
            end
        end          
        % Transition to y'{n}
        Pr(ik,ny)= 1 - normcdf( (yg(ny) - step/2  -rho*yg(ik) )/sde );
    end       
end
