function x=simps(f,n,a,b)
ev=linspace(a,b,n);
fx=f(ev);
h=(b-a)/(n-1);
weightsSimp=zeros(1,n);
for i=1:n
    if i==1 | i==n
        weightsSimp(i)=h/3;
    else
        if mod(i,2)~=0
            weightsSimp(i)=2*h/3;
        else
            weightsSimp(i)=4*h/3;            
        end    
    end
end
x=sum(fx.*weightsSimp);
end