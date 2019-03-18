% run the HDM toolbox on the SPM Attention dataset
%--------------------------------------------------------------------------
load('SPM.mat');
load('VOI_V1_1.mat');

% Specify HDM model
%--------------------------------------------------------------------------
TR = 3.22; % seconds

options        = struct();
options.TE     = 0.04;     % echo time (secs)
options.delays = TR/2;     % slice timing (half way through the volume)
u_idx          = 1;        % vector of experimental conditions to include

HDM = spm_hdm_specify(SPM,xY,u_idx,options);

% estimate
%--------------------------------------------------------------------------
HDM = spm_hdm_estimate(HDM);

% plot
%--------------------------------------------------------------------------
spm_hdm_review(HDM);
