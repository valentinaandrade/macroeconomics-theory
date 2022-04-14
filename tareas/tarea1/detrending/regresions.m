function [m1, m2] = regresions(data)

% Lag data
xx = data;
xx = table2timetable(data,'RowTimes','time'); % Transform table to time table
tail(xx); % Orden table
lags = [0 1]; % vector of lags 0 is without lag and 1 with -1 lag
xx = lagmatrix(xx,lags); % construct lag matrix
xx=timetable2table(xx); % transform to table
[rows, col] = size(xx); % rows to size ones to intercept

% Lagmatrixfunction
%function [ lagA] = lagmatrix(A,n)
% A matrix to lag
% n number of lags
% lagA output matrix
%lagA = NaN(size(A))
%lagA(n+1:end,:) = A(1:end-n,:)
%lagA = array2table(lagA) 
%end

% Regresion
%% Notice xx matrix starts in 2 beacause we lost 1 observation due the lag process
xx=xx{:,vartype("numeric")}; % extract table as numeric
X = [(ones(rows-1,1)) xx(2:end,:)]; %create matrix with ones and X matrix
pi =  X(:,4); % extract pi-lag0
m1 = (X(:,[1,7,3,6])\pi)'; %x ones, pi lag 1, cu, cu lag1
m2 = (X(:,[1,7,2,5])\pi)';
end 