function x=midp(f,n,a,b)
h=(b-a)/n;%El "h" en este caso no se calcula dividiendo en "n-1".
ev=zeros(1,n);
for i=1:n
    if i==1
    ev(i)=a+(h*i)/2;
    else
    ev(i)=ev(i-1)+h;
    end
end

fx=f(ev);

x=sum(h*fx);

end