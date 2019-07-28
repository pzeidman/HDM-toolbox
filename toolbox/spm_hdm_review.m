function spm_hdm_review(HDM)

% Unpack
% -------------------------------------------------------------------------
M  = HDM.M;
De = spm_vec(M.De);
Ep = spm_vec(HDM.Ep);
K1 = HDM.K1;
H1 = HDM.H1;
K2 = HDM.K2;
U  = HDM.U;

% Prepare posterior expected values
% -------------------------------------------------------------------------
D = M.De;
is_logscale = logical(spm_vec(M.is_logscale));

% Vectorize 
d = spm_vec(D);

% Multiply default values by estimated values (log scale)
k = is_logscale;
P(k) = d(k) .* exp(Ep(k));    

% Multiply default values by estimated values (non-log scale)
k = ~is_logscale;
P(k) = d(k) .* Ep(k);

% Compute explained variance (%)
% -------------------------------------------------------------------------
y = HDM.y;
R = HDM.R;

PSS = sum(y.^2);
RSS = sum(R.^2);
ev  = 100*PSS/(PSS + RSS);

% Create figure
% -------------------------------------------------------------------------
spm_figure('GetWin','HDM Review');
spm_clf;
rows = 3;
cols = 3;

% Prediction and residuals
subplot(rows,cols,1:3);
plot(HDM.y); hold on;
plot(HDM.y + HDM.R,':');
str = sprintf('Prediction and residuals (Explained var: %2.2f%%)',ev);
title(str,'FontSize',14);
xlabel('Volume');

% Posteriors
subplot(rows,cols,4);
spm_plot_ci(HDM.Ep,diag(HDM.Cp));
title('Log scaling parameters','FontSize',14); xlabel('Parameter');
axis square;

% Posterior expected values
subplot(rows,cols,5);
for i = 1:length(De)
    bar(i,P(i)); hold on;
end
hold off;
title('Expected values','FontSize',14); xlabel('Parameter');
axis square;
str = spm_fieldindices(HDM.Ep,1:numel(spm_vec(HDM.Ep)));
for i = 1:length(str)
    str{i} = sprintf('%d. %s', i, strrep(str{i},'(1)',''));
end
set(gca,'XTick',1:length(P));
legend(str);

% Posterior correlations
subplot(rows,cols,6);
imagesc(abs(spm_cov2corr(HDM.Cp)))
title('Posterior correlations');
axis square;
xlabel('Parameter');

% First order kernels for states (under the largest input condition)
subplot(rows,cols,7)
P     = HDM.Ep.efficacy;
[~,j] = max(abs(P));
t     = [1:M.N]*M.dt;
plot(t,exp(H1(:,:,j)));
axis square
title({['1st order kernels for ' U.name{j}];...
       'state variables'},'FontSize',14)
ylabel('normalized values')
legend({'s','f','v','q'}, 'Location','Best');
grid on
xlabel('Time (secs)');

% First order BOLD kernel
subplot(rows,cols,8)
plot(t,K1(:,j))
axis square
title({['1st order kernels for ' U.name{j}];...
       'BOLD'},'FontSize',14)
ylabel('normalized flow signal')
grid on
xlabel('Time (secs)');

% Second order BOLD kernel
subplot(rows,cols,9)
imagesc(t,t,K2(:,:,j,j))
axis square
title({'2nd order kernel';...
       'output: BOLD'},'FontSize',14)
xlabel({'time (secs) for'; U.name{j}})
grid on
