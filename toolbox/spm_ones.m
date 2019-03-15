function [X] = spm_ones(X)
% fills a cell or structure array with ones
% FORMAT [X] = spm_zeros(X)
% X  - numeric, cell or stucture array[s]
%__________________________________________________________________________
% Copyright (C) 2005-2013 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_zeros.m 6233 2014-10-12 09:43:50Z karl $


% create zeros structure
%--------------------------------------------------------------------------
X = spm_unvec(ones(spm_length(X),1),X);
