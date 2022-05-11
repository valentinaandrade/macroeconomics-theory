function u= utilitydef(c, l,varphi)
% Utility function for consumption and labor choice
% [c]: consumption
% [l]: leisure (1-n), where n is leisure
% [varphi]: elasticity of labor supply
u= log(c) + varphi.*log(l);

end