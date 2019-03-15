function view_hdm_posteriors(HDM)
% Visualises HDM posteriors in the format of Friston et al. 2000

% Unpack
% -------------------------------------------------------------------------
Ep = spm_vec(HDM.Ep);
%Cp = full(diag(HDM.Cp));
Cp = full(HDM.Cp);
De = spm_vec(HDM.M.De);
is_logscale = logical(spm_vec(HDM.M.is_logscale));
pnames = fieldnames(HDM.Ep);
rng(1);

% Prepare plot
% -------------------------------------------------------------------------
spm_figure('GetWin','HDM2 Priors');
rows = 3;
cols = 2;

% Set order to match Friston 2000
plot_order = [7 1 2 3 4 5];

% Sample from posteriors
samples = spm_normrnd(Ep,Cp,1000);

for i = 1:length(plot_order)
    subplot(rows,cols,i);
    
    p = plot_order(i);
    
    % Multiply default values (exponentiated)
    if is_logscale(p)
        pr = De(p) .* exp(samples(p,:));    
    else
        pr = De(p) .* samples(p,:);
    end
        
    % Plot histogram
    hist(pr,20);
    axis square;
    title(pnames{p});
end