function [pE,pC,D,is_logscale] = spm_hdm_priors_hdm2(m,M)
% returns priors for a hemodynamic dynamic causal model
% FORMAT [pE,pC] = spm_hdm_priors(m,[h])
% m    - number of inputs
% M.B0 - field strength (tesla)
%
% pE  - prior expectations
% pC  - prior covariances
%
% (5) biophysical parameters
%    P(1) - signal decay                  d(ds/dt)/ds)
%    P(2) - autoregulation                d(ds/dt)/df)
%    P(3) - transit time                  (t0)
%    P(4) - exponent for Fout(v)          (alpha)
%    P(5) - resting oxygen extraction     (E0)
%    P(6) - ratio of intra- to extra-     (epsilon)
%           vascular components of the
%           gradient echo signal   
%
% plus (m) efficacy priors
%    P(7) - ....
%
%___________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_hdm_priors.m 4579 2011-12-02 20:21:07Z karl $

B0 = M.B0;
age = M.age;

% Intra:extravascular signal contribution
% Table 1B of Havlicek et al., NeuroImage, 2015
switch B0
    case 1.5
        epsilon = 0.72; % mid point of 0.1263–1.3210
    case 3
        epsilon = 0.44; % mid point of 0.1291–0.5648
    case 7
        epsilon = 0;
    otherwise
        error('Unknown field strength');
end

% set default values (to multiply by free parameters)
D = struct();
D.decay    = 0.64;
D.feedback = 0.41;
D.transit  = 1.02;
D.alpha    = 0.33;
D.E0       = (32.2 + 0.13 * age) / 100;
D.V0       = (7.3 - 0.046 * age) / 100;
D.epsilon  = epsilon;
D.efficacy = ones(m, 1);

% Set which parameters are log scaling parameters
is_logscale = spm_ones(D);
is_logscale.efficacy = is_logscale.efficacy .* 0;

% Set prior expectations
pE = spm_zeros(D);

% Set prior variances
pC = struct();
pC.decay    = 1/32; 
pC.feedback = 0;
pC.transit  = 1/32;
pC.alpha    = 1/512;
pC.E0       = 0;
pC.V0       = 0;
pC.epsilon  = 0;
pC.efficacy = ones(1, m);

pC = diag(spm_vec(pC));