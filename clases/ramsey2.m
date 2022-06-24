clear;
close all;

% Ramsey model with aggregate shocks. No employment margin

% Parameters
%rho=.5;
rho=0;
stdev=.02;
sigma=1;
beta=.96;
delta=.025;
alpha=1/3;

nK  = 100;
nA  = 3;
devplus = .4;
devmin = .8;

% Deterministic steady state
Kss = (alpha/(1/beta-1+delta)).^(1/(1-alpha));
Iss = delta.*Kss;
Yss = Kss.^alpha;
Css = Yss-delta.*Kss;

% grilla endogena
Kgrid = linspace((1-devmin).*Kss,(1+devplus).*Kss,nK);
[A, Pi] = mytauchen(0,rho,stdev,nA);
Agrid = exp(A);
Ygrid = repmat(Agrid,1,nK).*repmat(Kgrid.^alpha,nA,1);

C0 = Ygrid+(1-delta).*repmat(Kgrid,nA,1);
r  = repmat(Agrid,1,nK).*repmat(alpha.*(Kgrid.^(alpha-1)),nA,1);
R  = r +1-delta;
X  = beta.*R.*um(C0,sigma);
X  = Pi*X;
C1 = X.^(-(1/sigma));

% From current cosumption and future capital, we recover current capital:
Res= repmat(Kgrid,nA,1)+C1;
k_new=zeros(nA,nK);
for i=1:nA;
    k = fsolve(@(k) KRes2(k,alpha,delta,Agrid(i),Res(i,:)),Kss.*ones(1,nK));
    k_new(i,:)=k;
end

C2 = zeros(nA,nK);
for i=1:nA;
    C2(i,:) = interp1(k_new(i,:),C1(i,:),Kgrid,'linear','extrap');
end

dist=sum(sum(abs(C2-C0)));
D=dist;
i=1;
while dist>.0000001;
    i=i+1;
    C0 = C2;
    X  = beta.*R.*um(C0,sigma);
    X  = Pi*X;
    C1 = X.^(-(1/sigma));
    Res= repmat(Kgrid,nA,1)+C1;
    k_new=zeros(nA,nK);
    for i=1:nA;
        k = fsolve(@(k) KRes2(k,alpha,delta,Agrid(i),Res(i,:)),Kss.*ones(1,nK));
        k_new(i,:)=k;
    end
    C2 = zeros(nA,nK);
    for i=1:nA;
        C2(i,:) = interp1(k_new(i,:),C1(i,:),Kgrid,'linear','extrap');
    end
    dist=sum(sum(abs(C2-C0)));
    D = [D dist];
end

C_pol = C2;
K_pol = repmat(Agrid,1,nK).*(repmat(Kgrid,nA,1).^alpha)+(1-delta).*repmat(Kgrid,nA,1)-C_pol;

figure(1)
plot(Kgrid,C_pol),xlabel('Capital stock','FontSize',14),ylabel('Consumption','FontSize',14)

figure(2)
plot(Kgrid,Kgrid,'--'),hold on
plot(Kgrid,K_pol,'k'),xlabel('Current capital stock','FontSize',14),ylabel('Next capital stock','FontSize',14),legend('45 degreee line','policy function','Location','NorthWest'),hold off

%stochastic steady state:
T=500;
Kseries=zeros(1,T);
Kseries(1)=Kss;
for t=2:T
    Kseries(t) = interp1(Kgrid,K_pol(2,:),Kseries(t-1),'linear','extrap');
end
Kss2=Kseries(end);

%IRF:
T=30;
Kseries=zeros(1,T);
Aseries=zeros(1,T);
Cseries=zeros(1,T);
Iseries=zeros(1,T);
Yseries=zeros(1,T);
rseries=zeros(1,T);

Kseries(1)=Kss2;
Aseries(1)=1.01;
Cseries(1)=interp2(Kgrid,Agrid,C_pol,Kseries(1),Aseries(1));%interp1(Kgrid,C_pol(2,:),Kseries(1),'linear','extrap');
Yseries(1)=Aseries(1).*(Kseries(1).^alpha);
Iseries(1)=Yseries(1)-Cseries(1);
rseries(1)=Aseries(1).*alpha.*(Kseries(1).^(alpha-1));
for t=2:T
    Kseries(t)=Kseries(t-1).*(1-delta)+Iseries(t-1);
    Aseries(t)=rho.*log(Aseries(t-1));
    Aseries(t)=exp(Aseries(t));
    Cseries(t)=interp2(Kgrid,Agrid,C_pol,Kseries(t),Aseries(t));
    Yseries(t)=Aseries(t).*(Kseries(t).^alpha);
    Iseries(t)=Yseries(t)-Cseries(t);
    rseries(t)=Aseries(t).*alpha.*(Kseries(t).^(alpha-1));
end

Kseries=log(Kseries)-log(Kseries(1));
Cseries=log(Cseries)-log(Cseries(end));
Yseries=log(Yseries)-log(Yseries(end));
Iseries=log(Iseries)-log(Iseries(end));
Aseries=log(Aseries)-log(Aseries(end));
rseries=rseries-rseries(end);

figure(3)
subplot(3,2,1),plot(Yseries,'k','LineWidth',2),ylabel('Output'),xlabel('Time')
subplot(3,2,2),plot(Kseries,'k','LineWidth',2),ylabel('Capital'),xlabel('Time')
subplot(3,2,3),plot(Cseries,'k','LineWidth',2),ylabel('Consumption'),xlabel('Time')
subplot(3,2,4),plot(Iseries,'k','LineWidth',2),ylabel('Investment'),xlabel('Time')
subplot(3,2,5),plot(rseries,'k','LineWidth',2),ylabel('Interest rate'),xlabel('Time')
subplot(3,2,6),plot(Aseries,'k','LineWidth',2),ylabel('TFP'),xlabel('Time')