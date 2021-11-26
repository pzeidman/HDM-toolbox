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

if ~isfield(M,'B0') || isempty(M.B0)
    B0 = 3;
else
    B0 = M.B0;
end

% Echo time (seconds)
TE = M(1).TE;

% resting venous volume (%)
V0 = P.V0;                           

% slope r0 of intravascular relaxation rate R_iv as a function of oxygen 
% saturation Y:  R_iv = r0*[(1-Y)-(1-Y0)]
% From: Uludag et al., 2009, Heinzle et al., 2016
switch B0
    case 0
        r0 = 25;
    case 1.5
        r0 = 25;
    case 3
        r0 = 110;
    case 7
        r0 = 325;
end

% frequency offset at the outer surface of magnetized vessels
% From: Uludag et al., 2009, Heinzle et al., 2016
switch B0
    case 0
        nu0 = 40.3;
    otherwise
        nu0 = 28.265 * B0;
end

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

% scale (in DCM this is rolled into V0)
scale = 100;

% BOLD signal
v = x(3);
q = x(4);
y = scale*V0*(k1.*(1 - q) + k2.*(1 - (q./v)) + k3.*(1 - v)); 