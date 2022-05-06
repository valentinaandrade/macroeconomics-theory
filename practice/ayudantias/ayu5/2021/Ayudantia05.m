clear all ; close all ; clc

%Parameters
T=60;
beta = 0.96;
sigma = 2;
a_1 = 0;
alpha = 0.33;
delta = 0.1;

%Asset grid
A = linspace(-10,15,2001);

% Labor Income
z= @(x,mu,sig) 1 + 6 *exp(-( (log(x)-mu)/sig ).^2 /2 ) ./(x* sig*sqrt(2*pi));
y = z(1:T, log(20), 0.4);
%a
r = (1 - beta) / beta;
r = 1.3*r; %Inciso b
w = 1.02;


%Condición de acceso al crédito
a_credit = zeros(1,T+1);
for i = T:-1:1
    a_credit(i) = (a_credit(i+1)-w*y(i)) / (1+r);   
end
a_credit_pos_p = sum(A<a_credit(end)) + 1; %initial lower bound position

%Value function iteration
V1 = NaN(length(A),T+1); %saves value functions
V1(a_credit_pos_p:end,end)=0;
Api = NaN(length(A),T); %position of maximizing level of capital
Apt = Api; %maximizing level of capital
Cpt = Api; %maximizing level of consumption

for t = T:-1:1
    a_credit_pos = sum(A<a_credit(t)) + 1; %tomorrow's lower bound
    c = (1+r).*A(a_credit_pos:end)' + y(t)*w - A(a_credit_pos_p:end);
    c(c<=0)=NaN;
    
    V = utility(c,sigma) + beta*V1(a_credit_pos_p:end,t+1)';
    
    [V0,api] = max(V,[],2);
    
    V1(a_credit_pos:end,t) = V0;

    Api(a_credit_pos:end,t) = api - 1 + a_credit_pos_p; %position of 
    %maximizing level of asset
    
    Apt(a_credit_pos:end,t) = A(api - 1 + a_credit_pos_p);%Asset Policy
    Cpt(a_credit_pos:end,t) = (1+r).*A(a_credit_pos:end) + y(t)*w - ...
        A(api - 1 + a_credit_pos_p); %Consumption Policy
    a_credit_pos_p = a_credit_pos;
end

%Trayectoria
asset_positions = NaN(1,T+1);
asset_positions(1) = sum(A<0)+1;
for i = 2:T+1
    asset_positions(i) = Api(asset_positions(i-1),i-1);
end

At = A(asset_positions);
Ct = (1+r)*At(1:T) + w*y - At(2:T+1);

figure(1)
subplot(2,2,1)
plot(1:T,w*y)
xlabel('T')
ylabel('Income')
subplot(2,2,2)
plot(1:T,At(1:end-1))
xlabel('T')
ylabel('Assets')
subplot(2,2,3)
plot(1:T,Ct)
xlabel('T')
ylabel('Consumption')
%%
%b
clear all ; close all ; clc
%Parameters
T=60;
beta = 0.96;
sigma = 2;
a_1 = 0;
alpha = 0.33;
delta = 0.1;

%Asset grid
A = linspace(-10,15,2001);

% Labor Income
z= @(x,mu,sig) 1 + 6 *exp(-( (log(x)-mu)/sig ).^2 /2 ) ./(x* sig*sqrt(2*pi));
y = z(1:T, log(20), 0.4);

r = (1 - beta) / beta;
r = 1.3*r; %Inciso b
%w = 1.02;
w= (1-alpha)*( alpha/(r+delta) )^(alpha/(1-alpha)); %equi. general: c) y d)
%VFI function: Farmer
[V, At, Ct, Api, Apt, Cpt]=farmer(T, A, beta, r, w, y, sigma);

figure(1)
subplot(2,2,1)
plot(1:T,w*y)
xlabel('T')
ylabel('Income')
subplot(2,2,2)
plot(1:T,At(1:end-1))
xlabel('T')
ylabel('Assets')
subplot(2,2,3)
plot(1:T,Ct)
xlabel('T')
ylabel('Consumption')

%%

% Weights
mt= 1/T;
% Labor supply
Lbar= sum(mt.*y);


%----------------------
% Aggregate assets
%----------------------
rg= linspace(0,0.1,11);
AA= zeros(1,length(rg));
KK= zeros(1,length(rg));
for ir= 1:length(rg)
    
    % Interest rate
    r= rg(ir);
    % Wage
    w= (1-alpha)*( alpha/(r+delta) )^(alpha/(1-alpha));
    
    % Farmer's problem
    [V, At, Ct, Api, Apt, Cpt]=farmer(T, A, beta, r, w, y, sigma);
    % Aggregate asset supply
    AA(ir)= sum( mt.*At(2:end) );
    
    % Aggregate asset demand
    KK(ir)= (alpha/(r+delta))^(1/(1-alpha))*Lbar;
end

% Plot
figure; plot(rg,[AA;KK])
%plot([AA;KK], rg)
legend('A', 'K')
title('Capital Market'); xlabel('Interest rate: r'); ylabel('Capital')
