function [V1, At, Ct, Api, Apt, Cpt]=farmer(T, A, beta, r, w, y, sigma,liq)
%Condición de acceso al crédito
a_credit = zeros(1,T+1);
for i = T:-1:1
    a_credit(i) = (a_credit(i+1)-w*y(i)) / (1+r);
    if a_credit >= -liq
        a_credit(i) = a_credit(i);
    else
        a_credit(i) = -liq;
    end
end
a_credit_pos_p = sum(A<a_credit(end)) + 1; %initial lower bound position

%Value function iteration
V1 = NaN(length(A),T+1);
V1(a_credit_pos_p:end,end)=0;
Api = NaN(length(A),T); %position of maximizing level of capital
Apt = Api; %maximizing level of capital
Cpt = Api; %maximizing level of consumption
tic
for t = T:-1:1
    a_credit_pos = sum(A<a_credit(t)) + 1; %tomorrow's lower bound
    c = (1+r).*A(a_credit_pos:end)' + y(t)*w - A(a_credit_pos_p:end);
    c(c<=0)=NaN;
    
    V = utility(c,sigma) + beta*V1(a_credit_pos_p:end,t+1)';
    
    [V0,api] = max(V,[],2);
    
    V1(a_credit_pos:end,t) = V0;

    Api(a_credit_pos:end,t) = api - 1 + a_credit_pos_p; %position of 
    %maximizing level of capital
    Apt(a_credit_pos:end,t) = A(api - 1 + a_credit_pos_p);%Asset Policy
    Cpt(a_credit_pos:end,t) = (1+r).*A(a_credit_pos:end) + y(t)*w - ...
        A(api - 1 + a_credit_pos_p); %Consumption Policy
    a_credit_pos_p = a_credit_pos;
end
toc
%Trayectoria
asset_positions = NaN(1,T+1);
asset_positions(1) = sum(A<0)+1;
for i = 2:T+1
    asset_positions(i) = Api(asset_positions(i-1),i-1);
end

At = A(asset_positions); %Asset Path
Ct = (1+r)*At(1:T) + w*y - At(2:T+1); %Consumption Path
