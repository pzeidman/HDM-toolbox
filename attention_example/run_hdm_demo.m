% demo files
%--------------------------------------------------------------------------
load('SPM.mat');
load('VOI_V1_1.mat');

% specify model
%--------------------------------------------------------------------------
u_idx  = 1;         % vector of experimental conditions to include

options = struct();
options.TE = 0.04;    % echo time (secs)

HDM = spm_hdm_specify(SPM,xY,u_idx,options);

% estimate
%--------------------------------------------------------------------------
HDM = spm_hdm_estimate(HDM);

% plot
%--------------------------------------------------------------------------
spm_hdm_review(HDM);
