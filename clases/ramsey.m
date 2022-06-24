clear;
close all;

% Parameters
sigma=1;
beta=.96;
delta=.025;
alpha=1/3;

nn  = 500;
devplus = .4;
devmin = .8;

%steady state
Kss = (alpha/(1/beta-1+delta)).^(1/(1-alpha));
Iss = delta.*Kss;
Yss = Kss.^alpha;
Css = Yss-delta.*Kss;

% grilla endogena
Kgrid = linspace((1-devmin).*Kss,(1+devplus).*Kss,nn);
Ygrid = Kgrid.^alpha;

C0 = Ygrid+(1-delta).*Kgrid;
r  = alpha.*(Kgrid.^(alpha-1));
R  = r +1-delta;
X  = beta.*R.*um(C0,sigma);
C1 = X.^(-(1/sigma));% this is current cosumption as a function of future capital

% From current consumption and future capital, we recover current capital:
Res= Kgrid+C1;
k = fsolve(@(k) KRes(k,alpha,delta,Res),Kss.*ones(1,nn));

C2 = interp1(k,C1,Kgrid,'linear','extrap');

dist=sum(abs(C2-C0));
D=dist;
i=1;
while dist>.0000001;
    i=i+1;
    C0 = C2;
    X  = beta.*R.*um(C0,sigma);
    C1 = X.^(-(1/sigma));
    Res= Kgrid+C1;

    k = fsolve(@(k) KRes(k,alpha,delta,Res),Kss.*ones(1,nn));
    C2 = interp1(k,C1,Kgrid,'linear','extrap');
    dist=sum(abs(C2-C0));
    D = [D dist];
end

C_pol = C2;
K_pol = Kgrid.^alpha+(1-delta).*Kgrid-C_pol;

figure(1)
plot(Kgrid,C_pol,'k','LineWidth',2),xlabel('Capital stock','FontSize',14),ylabel('Consumption','FontSize',14)

figure(2)
plot(Kgrid,K_pol,'k','LineWidth',2),xlabel('Current capital stock','FontSize',14),ylabel('Next capital stock','FontSize',14),hold on
plot(Kgrid,Kgrid,'--'),legend('policy function','45 degreee line','Location','NorthWest'),hold off

% simulation
% starting with capital stock 5% below steady state

T=20;
Kseries=zeros(1,T);
Cseries=zeros(1,T);
Iseries=zeros(1,T);
Yseries=zeros(1,T);
rseries=zeros(1,T);

Kseries(1) = .95.*Kss;
Yseries(1) = Kseries(1).^alpha;
Cseries(1) = interp1(Kgrid,C_pol,Kseries(1),'linear','extrap');
Iseries(1) = Yseries(1)-Cseries(1);
for t=2:T
    Kseries(t) = interp1(Kgrid,K_pol,Kseries(t-1),'linear','extrap');
    Yseries(t) = Kseries(t).^alpha;
    Cseries(t) = interp1(Kgrid,C_pol,Kseries(t),'linear','extrap');
    Iseries(t) = Yseries(t)-Cseries(t);
end
rseries=alpha.*(Kseries.^(alpha-1));

figure(3)
subplot(3,2,1),plot(Yseries),ylabel('Output'),xlabel('Time')
subplot(3,2,2),plot(Kseries),ylabel('Capital'),xlabel('Time')
subplot(3,2,3),plot(Cseries),ylabel('Consumption'),xlabel('Time')
subplot(3,2,4),plot(Iseries),ylabel('Investment'),xlabel('Time')
subplot(3,2,5),plot(rseries),ylabel('Interest rate'),xlabel('Time')