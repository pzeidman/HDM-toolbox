function HDM = spm_hdm_estimate(HDM)

% Unpack
M = HDM.M;
U = HDM.U;
Y = HDM.Y;

% Estimate
[Ep,Cp,Eh,F] = spm_nlsi(M,U,Y);

% prediction and residuals
y      = feval(M.IS,Ep,M,U);
R      = Y.y - y;
R      = R - Y.X0*spm_inv(Y.X0'*Y.X0)*(Y.X0'*R);
Ce     = exp(-Eh);  

% generate kernels
[M0,M1,L1,L2] = spm_bireduce(M,Ep);
dt = M.dt;
N  = M.N;
[K0,K1,K2] = spm_kernels(M0,M1,L1,L2,N,dt);
[H0,H1]    = spm_kernels(M0,M1,M.N,M.dt);

% save
%--------------------------------------------------------------------------
HDM.Ep = Ep;
HDM.Cp = Cp;
HDM.Ce = Ce;
HDM.F  = F;
HDM.H1 = squeeze(H1);
HDM.K1 = squeeze(K1);
HDM.K2 = squeeze(K2);
HDM.y  = y;
HDM.R  = R;
HDM.n  = 1;