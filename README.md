# HDM-toolbox
Spinoff toolbox from SPM for fitting and comparing haemodynamic models (HDMs).

## Instructions for running the demo
1. Download the toolbox and add the 'toolbox' directory to your Matlab path.
2. In Matlab, enter the attention_example directory and view / run spm_hdm_demo.m

## Development details
The code is arranged into a set of functions, mirroring the DCM framework:

|Function|Description|
|--------|-----------|
|spm_hdm_specify|Create an HDM from a subject's SPM.mat and a representative timeseries (VOI)|
|spm_hdm_estimate|Fits an HDM to the data|
|spm_hdm_review|GUI for inspecting an HDM|

The default model included is described in the following functions:

|Function|Description|
|--------|-----------|
|spm_fx_hdm2|Neurovascular / haemodynamic model|
|spm_gx_hdm2|Observation model|
|spm_hdm_priors_hdm2|Priors on log scaling parameters as well as the default values they scale|
