function mt = growth(T,g)
%Pob evolution indicates the growth population 

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