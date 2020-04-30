function [pE,pC,D,is_logscale] = spm_hdm_priors_hdm2(m,B0)
% returns priors for a hemodynamic dynamic causal model
% FORMAT [pE,pC] = spm_hdm_priors(m,[h])
% m   - number of inputs
% h   - number of hemodynamic modes (default = 3)
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


% set default values (to multiply by free parameters)
D = struct();
D.decay    = 0.64;
D.feedback = 0.41;
D.transit  = 1.02;
D.alpha    = 0.33;
D.E0       = 0.34;
D.epsilon  = 1; 
D.efficacy = ones(m, 1);

% Set which parameters are log scaling parameters
is_logscale = spm_ones(D);
is_logscale.efficacy = is_logscale.efficacy .* 0;

% Set prior expectations
pE = spm_zeros(D);
pE.epsilon = -0.78; % 3T (Heinzle et al.)

% Set prior variances
pC = struct();
pC.decay    = 1/32; 
pC.feedback = 1/32;
pC.transit  = 1/32;
pC.alpha    = 1/32;
pC.E0       = 1/32;
pC.epsilon  = 0.06; % 3T (Heinzle et al.)
pC.efficacy = ones(1, m);

pC = diag(spm_vec(pC));