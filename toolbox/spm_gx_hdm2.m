function [y] = spm_gx_hdm2(x,u,P,M)
% Simulated BOLD response to input.
% FORMAT [y] = spm_gx_hdm(x,u,P,M)
% y    - BOLD response (%)
% x    - state vector     (see spm_fx_hdm2)
% P    - Parameter vector (see spm_fx_hdm2)
%__________________________________________________________________________
%
% This function implements the BOLD signal model described in: 
%
% Stephan KE, Weiskopf N, Drysdale PM, Robinson PA, Friston KJ (2007)
% Comparing hemodynamic models with DCM. NeuroImage 38: 387-401.
%__________________________________________________________________________
%
% Adapted from spm_gx_hdm.m by Karl Friston & Klaas Enno Stephan

% Set default values to multiply by the estimated values
D = M.De;
is_logscale = logical(spm_vec(M.is_logscale));

% Vectorize 
d = spm_vec(D);
p = spm_vec(P);

% Multiply default values by estimated values (log scale)
k = is_logscale;
p(k) = d(k) .* exp(p(k));    

% Multiply default values by estimated values (non-log scale)
k = ~is_logscale;
p(k) = d(k) .* p(k);

% Pack
P = spm_unvec(p,D);

% Run model
y = gx(x,u,P,M);

%--------------------------------------------------------------------------
function y = gx(x,u,P,M)
% BOLD signal model

% Echo time (seconds)
TE = M(1).TE;

% resting venous volume
V0 = 100*0.08;                                

% slope r0 of intravascular relaxation rate R_iv as a function of oxygen 
% saturation Y:  R_iv = r0*[(1-Y)-(1-Y0)]
r0 = 110; % 3T

% frequency offset at the outer surface of magnetized vessels
nu0 = 28.265 * 3; % 3T

% resting oxygen extraction fraction
E0 = P.E0;

% ratio of intra- to extravascular components of the gradient echo signal
epsi = P.epsilon;
 
% coefficients in BOLD signal model
k1 = 4.3.*nu0.*E0.*TE;
k2 = epsi.*r0.*E0.*TE;
k3 = 1 - epsi;
 
% exponentiation of hemodynamic state variables
x = exp(x); 

% BOLD signal
v = x(3);
q = x(4);
y = V0*(k1.*(1 - q) + k2.*(1 - (q./v)) + k3.*(1 - v)); 