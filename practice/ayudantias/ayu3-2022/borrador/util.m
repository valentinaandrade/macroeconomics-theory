function util = util(rho,c)

if rho == 1
util = log(c);
else
util =(c.^(1-rho))./(1-rho);
end

end