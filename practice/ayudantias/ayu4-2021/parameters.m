%------------------------------------------------------------------------------%
% Parameters
%------------------------------------------------------------------------------%

% Preferences
beta= 0.9; rho= 2;
% Income
r= 0.05; y= 1;
% Horizon
tend= 12;

% Value function
showiters= 10; maxiter= 1000; tolvalue= 1e-6;


%----------------------
% Consumer's problem
%----------------------
% Utility function
utility= @(c)  crra(c,rho);
