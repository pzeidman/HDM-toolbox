% Reproduces the analysis of Heinzle et al. (2016) deriving the appropriate
% prior density over epsilon given the review of T2* values from Donahue et
% al. 2011

for B0 = [1.5, 3.0, 7.0]
    % Range of intra-vascular and extra-vascular T2* relaxation rates per field
    % strength, as reviewed by Donahue et al. 2011.
    switch B0
        case 1.5
            T2i = 90:0.5:100; T2e = 55:0.5:65; % 1.5 Tesla
            TE  = 40; % ms
        case 3
            T2i = 15:0.5:25; T2e = 35:0.5:45; % 3 Tesla
            TE  = 30; % ms
        case 7
            T2i = 3:0.5:7; T2e = 25:0.5:30; % 7 Tesla
            TE  = 25; % ms
    end   

    % R2* (Hz)
    R2i = 1./T2i; R2e = 1./T2e;

    % Compute epsilon
    epsilon = [];
    for i = 1:length(T2i)
        for e = 1:length(T2e)
            epsilon(i,e) = exp(-R2i(i)*TE) / exp(-R2e(e)*TE);
        end
    end

    figure;hist(epsilon(:));

    % Fit a log-normal density
    [parmhat] = lognfit(epsilon(:));

    fprintf('B0: %1.1fT. Fitted epsilon: %2.2f, LogNormal Mu: %2.2f Variance: %2.2f\n', B0, exp(parmhat(1)), parmhat(1), parmhat(2).^2);
end