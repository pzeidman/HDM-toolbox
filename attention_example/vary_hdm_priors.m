% Demonstrates varying the priors in the HDM model. Note that
% run_hdm_demo.m needs to be run first to generate a model.

% Load exemplar model
load('HDM_attention.mat');

% Create figure
rows = 2; cols = 3;
spm_figure('GetWin','Model predictions');
spm_clf;

% Prepare template HDM
M = HDM.M;

% Get priors and default values
[pE,pC,D,is_logscale] = spm_hdm_priors_hdm2(1,M);

% Names of parameters in HDM.Ep
params = {'efficacy','decay', 'transit', 'V0', 'E0', 'alpha'};
    
% Descriptive names
labels = {'efficacy \beta','decay \kappa','transit 1/\tau_h','V0','E0','alpha'};

% Parameter values to set in HDM.M.De
scales{1} = [0.2 0.4];
scales{2} = [0.64 1.29];
scales{3} = [1.02 2.06];
scales{4} = [0.02 0.04 0.06];
scales{5} = [0.35 0.40 0.44];
scales{6} = [0.20 0.33 0.40];

% Legends
legends{1} = {'0.2Hz' '0.4Hz'};
legends{2} = {'0.64Hz' '1.29Hz'};
legends{3} = {'1.02Hz' '2.06Hz'};
legends{4} = {'2%' '4%' '6%'};
legends{5} = {'35%' '40%' '45%'};
legends{6} = {'0.2' '0.33' '0.4'};

% Plot colours
colours = [0 0 0
           0.4 0.4 0.4
           0.7 0.7 0.7;
           ];
       
ax = [];   
figure;
for i = 1:length(params)
    ax(i) = subplot(rows,cols,i);
    
    % Select order of line styles
    if length(scales{i}) == 2
        styles = {':','-'};
    else
        styles = {'-',':','-'};
    end
    
    % Loop over plots within a subplot
    for j = 1:length(scales{i})
                
        de = D;
        P = pE;
        
        % Set parameter
        de.(params{i}) = scales{i}(j);
        
        % Set efficacy      
        P.efficacy  = 1;
        if ~strcmp(params{i},'efficacy')
            de.efficacy = 0.2;
        end
        
        % re-generate kernels
        M.De = de;
        [M0,M1,L1,L2] = spm_bireduce(M,P);
        dt = M.dt;
        N  = M.N;
        [K0,K1,K2] = spm_kernels(M0,M1,L1,L2,N,dt);
        [H0,H1]    = spm_kernels(M0,M1,M.N,M.dt);    
        
        % Plot BOLD
        t = (1:M.N)*M.dt;    
        plot(t,K1,'LineWidth',3,'LineStyle',styles{j},'Color',colours(j,:)); 
        xlabel('Time (secs)');
        if mod(i-1,cols)==0
            ylabel('BOLD'); 
        end
        
        title('V0');
        hold on;            
    end
    
    % Decorate plot
    set(gca,'FontSize',12);
    title(labels{i},'FontSize',14);
    legend(legends{i},'FontSize',14);
    linkaxes(ax);
end