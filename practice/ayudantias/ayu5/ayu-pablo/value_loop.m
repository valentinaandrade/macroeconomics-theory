function [Vt,At,Ct,Ap,Am,Cm] = value_loop(T,beta,sigma,r,A,Z,liq)

%Wage
w = Z(1:T);

%Access to credit
b = zeros(1,T+1);
for t = T:-1:1 
    b(t) = (b(t+1)-w(t))/(1+r);  
        if b(t) >= -liq % No activa
            b(t)=b(t);
        else 
            b(t) = -liq;% Activa
        end  
end
b_pos_p = sum(A<b(end)) + 1; 

% Preallocation
Vt = NaN(length(A),T+1); %Value matrix
Vt(b_pos_p:end,end) = 0; %Guess
Ap = NaN(length(A),T);   %Optimal asset position
Am = Ap;                 %Optimal asset    
Cm = Ap;                 %Optimal consumption

%Value function iteration
for t = T:-1:1   
    b_pos = sum(A<b(t)) + 1;

    for i = b_pos: length(A)
        c = w(t) + (1+r)*A(i) - A(b_pos_p:end)';
        c(c<=0)=NaN; 
        
        Vaux = util(c,sigma) + beta*Vt(b_pos_p:end,t+1)'; %Bellman equation 
        [V,P] = max(Vaux);  
        Vt(i,t) = V;
        Ap(i,t) = b_pos_p - 1 + P;  %Warning about rescaling position
        Am(i,t) = A(Ap(i,t));
        Cm(i,t) = w(t) + (1+r)*A(i) - A(b_pos_p - 1 + P);
        b_pos_p = b_pos;
    end
end

%Policies functions
Asset_life_pos = NaN(1,T);
Asset_life_pos(1) = sum(A<0)+1;
for t = 2:T+1
    Asset_life_pos(t) = Ap(Asset_life_pos(t-1),t-1);
end

At = A(Asset_life_pos)';
Ct = w(1:T) + (1+r)*At(1:T) - At(2:T+1);
end