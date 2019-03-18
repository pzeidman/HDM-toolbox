# HDM-toolbox
Spinoff toolbox from SPM for fitting and comparing single region haemodynamic models (HDMs).

NB: This work is unpublished.

## Instructions for running the demo
1. Download the toolbox and add the 'toolbox' directory to your Matlab path.
2. In Matlab, enter the attention_example directory and view / run spm_hdm_demo.m

## Function details
The code is arranged into a set of functions, mirroring the DCM framework:

|Function|Description|
|--------|-----------|
|spm_hdm_specify|Create an HDM from a subject's SPM.mat and a representative timeseries (VOI)|
|spm_hdm_estimate|Fits an HDM to the data|
|spm_hdm_review|GUI for inspecting an HDM|

## Default model
A default model is included, specified in the following Matlab functions:

|Function|Description|
|--------|-----------|
|spm_fx_hdm2|Neurovascular / haemodynamic model|
|spm_gx_hdm2|Observation model|
|spm_hdm_priors_hdm2|Priors on log scaling parameters as well as the default values they scale|

Notes:
- This is the same forward model as introduced in [Friston et. al 2000](https://doi.org/10.1006/nimg.2000.0630) and [Stephan et al. 2007](https://doi.org/10.1016/j.neuroimage.2007.07.040).
- The priors have been changed to be log scaling parameters that multiply default values. These default values come from Figure 7 of  [Friston et. al 2000](https://doi.org/10.1006/nimg.2000.0630). The resulting prior density over parameters can be viewed with the function attention_example/view_hdm_priors.m
- Parameters of the haemodynamic / observation models have been changed to be suitable for 3T data (parameters epsilon, r0, nu0), based on recommendations from [Heinzle et al. 2016](https://doi.org/10.1016/j.neuroimage.2015.10.025)
