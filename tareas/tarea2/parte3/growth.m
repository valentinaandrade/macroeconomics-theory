function mt = growth(T,g)
%Pob evolution indicates the growth population 
g =  linspace(0,0.01,11);

sumpob = 0;
for j = 1:length(g)
    sumpob = 0;
for t = 1:T
    sumpob = sumpob + (1+g(j)).^(65-t);
    m = (1+g(j).^(65))./sumpob;
end
sumg(j,:) = sumpob;
mt(j,:) = m;
end

end