function [f] = spm_fx_hdm2(x,u,P,M)
% state equation for the hemodynamic model
% FORMAT [f] = spm_fx_hdm(x,u,P,M)
%
% x      - state vector
%   x(1) - vascular signal                                    s
%   x(2) - rCBF                                           log(f)
%   x(3) - venous volume                                  log(v)
%   x(4) - dHb                                            log(q)
%
% u      - input (neuronal activity)                      (u)
%
% P      - free parameter vector
%   P(1) - signal decay                                   d(ds/dt)/ds)
%   P(2) - feedback (autoregulation)                      d(ds/dt)/df)
%   P(3) - transit time                                   (t0)
%   P(4) - exponent for Fout(v)                           (alpha)
%   P(5) - resting oxygen extraction                      (E0)
%   P(6) - ratio of intra- to extra-vascular components   (epsilon)
%          of the gradient echo signal   
%
%   P(6 + 1:m)   - input efficacies                       d(ds/dt)/du)
%
% M      - model structure
%   M.De          - structure of default values corresponding to P
%   M.is_logscale - binary structure indicating log scaling parameters
%
%
% f      - dx/dt
%__________________________________________________________________________
%
% Ref Buxton RB, Wong EC & Frank LR. Dynamics of blood flow and oxygenation
% changes during brain activation: The Balloon model. MRM 39:855-864 (1998)
%__________________________________________________________________________
%
% Adapted from spm_fx_hdm.m by Karl Friston.

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
f = fx(x,u,P);

% Concatenate
f = f(:);

%--------------------------------------------------------------------------
function f = fx(x,u,P)
% Haemodynamic model (neurovascular coupling and venous Balloon)

% Unpack parameters
decay     = P.decay;
feedback  = P.feedback;
transit   = P.transit;
alpha     = P.alpha;
E0        = P.E0;
efficacy  = P.efficacy;

% Exponentiation of hemodynamic state variables
x(2:end) = exp(x(2:end)); 

% Unpack states
s   = x(1); % vascular signal
fin = x(2); % rCBF (inflow)
v   = x(3); % venous volume
q   = x(4); % dHb

% Fout = f(v) - outflow
fv = v^(1/alpha);

% e = f(f) - oxygen extraction
ff = (1 - (1 - E0)^(1/fin))/E0;

% implement differential state equations
f(1)     = efficacy'*u(:) - decay*s - feedback*(fin - 1);
f(2)     = s/fin;
f(3)     = transit*(fin - fv)/v;
f(4)     = transit*(ff*fin - fv*q/v)/q;
f        = f(:);