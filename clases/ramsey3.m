clear;
close all;

% Ramsey model with aggregate shocks and an employment margin

% Parameters
rho=0.979;
%rho=0;
stdev=.0072;
beta=0.984;
delta=.025;
alpha=1/3;
theta = 3.38;

nK  = 100;
nA  = 3;
devplus = .4;
devmin = .8;

% Deterministic steady state
rss = (1/beta)-1+delta; %interest rate
kss = (alpha/rss)^(1/(1-alpha)); %capital labor ratio
wss = (1-alpha).*(kss^alpha); % wage
yss = kss^alpha; %ouput per hour worked
iss = delta.*kss; %investment per hour worked
css = yss - iss; %consumption per hour worked
Nss = (1+theta.*css./wss)^(-1); % hours worked
Yss = yss.*Nss; % aggregate output
Css = css.*Nss; % aggregate consumption
Iss = iss.*Nss; % aggregate investment
Kss = kss.*Nss; % aggregate capital stock

% grilla endogena
Kgrid = linspace((1-devmin).*Kss,(1+devplus).*Kss,nK);
[A, Pi] = mytauchen(0,rho,stdev,nA);
Agrid = exp(A);

%solving last period employment and consumption:
Nlast = zeros(nA,nK);
Kmat = repmat(Kgrid,nA,1);
Amat = repmat(Agrid,1,nK);
for i=1:nA
    for j=1:nK
        n = fsolve(@(n) lastemp(n,Kgrid(j),Agrid(i),alpha,delta,theta),Nss);
        Nlast(i,j)=n;
    end
end
Ylast = Amat.*(Kmat.^alpha).*(Nlast.^(1-alpha));
Clast = Ylast + (1-delta).*Kmat;
Rlast = Amat.*alpha.*(Kmat.^(alpha-1)).*(Nlast.^(1-alpha))+1-delta;

%Moving to the before last period
X  = beta.*Rlast.*um(Clast,1);
X  = Pi*X;
C1 = X.^(-1);% current consumption as a function of current TFP and next capital stock

% From current cosumption and future capital, we recover current capital and current hours worked:
Res= Kmat+C1;
Ncurrent = zeros(nA,nK);
Kcurrent = zeros(nA,nK);
KK= [];
for i=1:nA
    for j=1:nK
            %k = fsolve(@(k) Kres3(k,Agrid(i),alpha,C1(i,j),theta,delta,Res(i,j)),Kss./Nss);
        kmin = (theta.*C1(i,j)./((1-alpha).*Agrid(i))).^(1/alpha);
        kmax = ((Kgrid(j)./Agrid(i)) + ((1-alpha+theta)/(1-alpha)).*(C1(i,j)./Agrid(i))).^(1/alpha);
        dist=1;
        while abs(dist)>.000000000001;
            kiter=(kmin+kmax)./2;
            KK = [KK kiter];
            y = Agrid(i).*(kiter.^alpha);
            w = (1-alpha)*y;
            dist = 1 - theta.*(C1(i,j)./w) - Res(i,j)./((1-delta).*kiter+y);
            if dist > 0
                kmax = kiter;
            elseif dist <0
                kmin = kiter;
            end
        end
        Ncurrent(i,j) = 1 - theta.*(C1(i,j)./w);% hours in terms of current TFP and future capital
        Kcurrent(i,j) = kiter.*Ncurrent(i,j);% current capital in terms of current TFP and future capital
    end
end

C2 = zeros(nA,nK);
N2 = zeros(nA,nK);
for i=1:nA;
    C2(i,:) = interp1(Kcurrent(i,:),C1(i,:),Kgrid,'linear','extrap');
    N2(i,:) = interp1(Kcurrent(i,:),Ncurrent(i,:),Kgrid,'linear','extrap');
end

dist=sum(sum(abs(C2-Clast)));
D=dist;
while dist>.0000001;
    Clast = C2;
    Nlast = N2;
    Rlast = Amat.*alpha.*(Kmat.^(alpha-1)).*(Nlast.^(1-alpha))+1-delta;
    X  = beta.*Rlast.*um(Clast,1);
    X  = Pi*X;
    C1 = X.^(-1);% current consumption as a function of current TFP and next capital stock
    Res= Kmat+C1;
    Ncurrent = zeros(nA,nK);
    Kcurrent = zeros(nA,nK);
    KK= [];
    for i=1:nA
        for j=1:nK
                %k = fsolve(@(k) Kres3(k,Agrid(i),alpha,C1(i,j),theta,delta,Res(i,j)),Kss./Nss);
            kmin = (theta.*C1(i,j)./((1-alpha).*Agrid(i))).^(1/alpha);
            kmax = ((Kgrid(j)./Agrid(i)) + ((1-alpha+theta)/(1-alpha)).*(C1(i,j)./Agrid(i))).^(1/alpha);
            dist=1;
            while abs(dist)>.000000000001;
                kiter=(kmin+kmax)./2;
                KK = [KK kiter];
                y = Agrid(i).*(kiter.^alpha);
                w = (1-alpha)*y;
                dist = 1 - theta.*(C1(i,j)./w) - Res(i,j)./((1-delta).*kiter+y);
                if dist > 0
                    kmax = kiter;
                elseif dist <0
                    kmin = kiter;
                end
            end
            Ncurrent(i,j) = 1 - theta.*(C1(i,j)./w);% hours in terms of current TFP and future capital
            Kcurrent(i,j) = kiter.*Ncurrent(i,j);% current capital in terms of current TFP and future capital
        end
    end
    C2 = zeros(nA,nK);
    N2 = zeros(nA,nK);
    for i=1:nA;
        C2(i,:) = interp1(Kcurrent(i,:),C1(i,:),Kgrid,'linear','extrap');
        N2(i,:) = interp1(Kcurrent(i,:),Ncurrent(i,:),Kgrid,'linear','extrap');
    end
    dist=sum(sum(abs(C2-Clast)));
    D = [D dist];
end

C_pol = C2;
N_pol = N2;
K_pol = repmat(Agrid,1,nK).*(repmat(Kgrid,nA,1).^alpha).*(N_pol.^(1-alpha))+(1-delta).*repmat(Kgrid,nA,1)-C_pol;


figure(1)
plot(Kgrid,C_pol),xlabel('Capital stock','FontSize',14),ylabel('Consumption','FontSize',14)

figure(2)
plot(Kgrid,N_pol),xlabel('Capital stock','FontSize',14),ylabel('Hours worked','FontSize',14)


figure(3)
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
Css2=interp2(Kgrid,Agrid,C_pol,Kss2,1);%interp1(Kgrid,C_pol(2,:),Kseries(1),'linear','extrap');
Nss2=interp2(Kgrid,Agrid,N_pol,Kss2,1);
Yss2=(Kss2.^alpha).*(Nss2.^(1-alpha));
Iss2=Yss2-Css2;
wss2=(1-alpha).*(Kss2.^(alpha)).*(Nss2.^(-alpha));
rss2=alpha.*(Kss2.^(alpha-1)).*(Nss2.^(1-alpha));

%IRF:
T=30;
Kseries=zeros(1,T);
Aseries=zeros(1,T);
Cseries=zeros(1,T);
Iseries=zeros(1,T);
Yseries=zeros(1,T);
rseries=zeros(1,T);
wseries=zeros(1,T);
Nseries=zeros(1,T);

Kseries(1)=Kss2;
Aseries(1)=1.01;
Cseries(1)=interp2(Kgrid,Agrid,C_pol,Kseries(1),Aseries(1));%interp1(Kgrid,C_pol(2,:),Kseries(1),'linear','extrap');
Nseries(1)=interp2(Kgrid,Agrid,N_pol,Kseries(1),Aseries(1));
Yseries(1)=Aseries(1).*(Kseries(1).^alpha).*(Nseries(1).^(1-alpha));
Iseries(1)=Yseries(1)-Cseries(1);
wseries(1)=Aseries(1).*(1-alpha).*(Kseries(1).^(alpha)).*(Nseries(1).^(-alpha));
rseries(1)=Aseries(1).*alpha.*(Kseries(1).^(alpha-1)).*(Nseries(1).^(1-alpha));
for t=2:T
    Kseries(t)=Kseries(t-1).*(1-delta)+Iseries(t-1);
    Aseries(t)=rho.*log(Aseries(t-1));
    Aseries(t)=exp(Aseries(t));    
    Cseries(t)=interp2(Kgrid,Agrid,C_pol,Kseries(t),Aseries(t));%interp1(Kgrid,C_pol(2,:),Kseries(1),'linear','extrap');
    Nseries(t)=interp2(Kgrid,Agrid,N_pol,Kseries(t),Aseries(t));
    Yseries(t)=Aseries(t).*(Kseries(t).^alpha).*(Nseries(t).^(1-alpha));
    Iseries(t)=Yseries(t)-Cseries(t);
    wseries(t)=Aseries(t).*(1-alpha).*(Kseries(t).^(alpha)).*(Nseries(t).^(-alpha));
    rseries(t)=Aseries(t).*alpha.*(Kseries(t).^(alpha-1)).*(Nseries(t).^(1-alpha));
end

Kseries=log(Kseries)-log(Kss2);
Cseries=log(Cseries)-log(Css2);
Nseries=log(Nseries)-log(Nss2);
Yseries=log(Yseries)-log(Yss2);
Iseries=log(Iseries)-log(Iss2);
Aseries=log(Aseries);
rseries=rseries-rss2;
wseries=log(wseries)-log(wss2);


figure(4)
subplot(2,4,1),plot(Yseries,'k','LineWidth',2),ylabel('Output'),xlabel('Time'),title('Impulse Response Functions','FontSize',14)
subplot(2,4,2),plot(Kseries,'k','LineWidth',2),ylabel('Capital'),xlabel('Time')
subplot(2,4,3),plot(Cseries,'k','LineWidth',2),ylabel('Consumption'),xlabel('Time')
subplot(2,4,4),plot(Nseries,'k','LineWidth',2),ylabel('Hours worked'),xlabel('Time')
subplot(2,4,5),plot(Iseries,'k','LineWidth',2),ylabel('Investment'),xlabel('Time')
subplot(2,4,6),plot(rseries,'k','LineWidth',2),ylabel('Interest rate'),xlabel('Time')
subplot(2,4,7),plot(wseries,'k','LineWidth',2),ylabel('Wage'),xlabel('Time')
subplot(2,4,8),plot(Aseries,'k','LineWidth',2),ylabel('TFP'),xlabel('Time')