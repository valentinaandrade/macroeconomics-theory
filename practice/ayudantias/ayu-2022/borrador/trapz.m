function x=trapz(f,n,a,b)
ev=linspace(a,b,n);
fx=f(ev);
h=(b-a)/(n-1);
weightsTr=zeros(1,n);
for i=1:n
     if i==1 | i==n
         weightsTr(i)=h/2;
     else
         weightsTr(i)=h;
     end   
end
x=sum(fx.*weightsTr);

end