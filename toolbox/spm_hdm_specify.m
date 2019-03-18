function HDM = spm_hdm_specify(SPM,xY,u_idx,options)
% Specifies an HDM
% 
% SPM        - SPM structure
% xY         - VOI structure
% u_idx      - indices of the conditions from the SPM to include
% options.TE - echo time

% unpack options
%--------------------------------------------------------------------------
try delays = options.delays; catch, delays = []; end
try TE = options.TE; catch, TE = 0.04; end
try priorfun = options.priorfun; catch, priorfun = @spm_hdm_priors_hdm2; end

% prepare inputs
%--------------------------------------------------------------------------
Sess   = SPM.Sess(1);
U.name = {};
U.u    = [];
for i = 1:length(u_idx)
    u = u_idx(i);
    for  j = 1:length(Sess.U(u).name)
        U.u             = [U.u Sess.U(u).u(33:end,j)];
        U.name{end + 1} = Sess.U(u).name{j};
    end
end
U.dt   = Sess.U(1).dt;

% prepare data
%--------------------------------------------------------------------------
Y      = struct();
y      = xY.u;
Y.y    = y;
Y.dt   = SPM.xY.RT;
Y.X0   = xY.X0;

% priors and default values
%--------------------------------------------------------------------------
n_inputs = size(U.u,2);
%[pE,pC,D,is_logscale] = spm_hdm_priors_hdm2(n_inputs);
[pE,pC,D,is_logscale] = priorfun(n_inputs);

% model (see spm_nlsi_GN.m)
%--------------------------------------------------------------------------
M.f     = 'spm_fx_hdm2';
M.g     = 'spm_gx_hdm2';
M.IS    = 'spm_int';
M.x     = [0 0 0 0]'; 
M.pE    = pE;    
M.pC    = pC;
M.m     = n_inputs;
M.n     = 4;
M.l     = 1;
M.N     = 64;
M.dt    = 24/M.N;
M.ns    = size(Y.y,1);
M.TE    = TE;
M.De    = D;
M.delays = delays;
M.is_logscale = is_logscale;

% pack
%--------------------------------------------------------------------------
HDM = struct();
HDM.M = M;
HDM.Y = Y;
HDM.U = U;
HDM.options = options;