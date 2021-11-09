% Visualises the HDM priors for comparison against Friston et al. 2000

% Get priors
% -------------------------------------------------------------------------
n_inputs = 1;
M.B0  = 3;
M.age = 18;
[pE,pC,D,is_logscale] = spm_hdm_priors_hdm2(n_inputs,M);

is_logscale = logical(spm_vec(is_logscale));

% Unpack
% -------------------------------------------------------------------------
pnames = fieldnames(pE);
pE     = spm_vec(pE);
pC     = diag(pC);
D      = spm_vec(D);
np     = length(pE) - 1; % We're not plotting epsilon

rng(1);

% Prepare plot
% -------------------------------------------------------------------------
spm_figure('GetWin','HDM2 Priors');
rows = 3;
cols = 2;

% Set order to match Friston 2000
plot_order = [7 1 2 3 4 5];

for i = 1:length(plot_order)
    subplot(rows,cols,i);
    
    p = plot_order(i);
    
    % Sample from priors
    mu = pE(p);
    v  = pC(p);
    samples = spm_normrnd(mu,v,1000);
    
    % Multiply default values (exponentiated)
    if is_logscale(p)
        pr = D(p) .* exp(samples);    
    else
        pr = D(p) .* samples;
    end
        
    % Plot histogram
    hist(pr,20);
    axis square;
    title(pnames{p});
end