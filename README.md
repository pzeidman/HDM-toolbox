# HDM-toolbox
Spinoff toolbox from SPM for developing, fitting and comparing single region haemodynamic models (HDMs).

NB 1: This is intended for situations where only a single brain region is being modelled. If data from multiple regions are available, then DCM is recommended (which has both hidden neural and haemodynamic states).

NB 2: This work is unpublished.

## Instructions for running the demo
1. [Download the toolbox](https://github.com/pzeidman/HDM-toolbox/archive/master.zip), unzip it and add the 'toolbox' directory to your Matlab path.
2. In Matlab, go into the attention_example directory and run **spm_hdm_demo.m**

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
- The haemodynamic priors have been changed to be log scaling parameters that multiply default values. These default values come from Figure 7 of  [Friston et. al 2000](https://doi.org/10.1006/nimg.2000.0630). The resulting prior density over parameters can be viewed with the function attention_example/view_hdm_priors.m . This was also done for the driving input (efficacy) parameters, thereby encforcing them to be positive. Whether this is beneficial is yet to be evaluated.
- Parameters of the haemodynamic / observation models have been changed to be suitable for 3T data (parameters epsilon, r0, nu0), based on recommendations from [Heinzle et al. 2016](https://doi.org/10.1016/j.neuroimage.2015.10.025)

## Priors for the default model
The priors on parameters are as follows:

|Section|Parameter|Default|Variance|Notes|
|-------|---------|-----------|--------|-----|
|Neurovascular|Decay|0.64Hz|1/32|Half-life of vasoactive signal: 1/decay x log(2)|
|Neurovascular|Feedback|0.41Hz|1/32|Period of vasoactive signal: 1/(2 x pi x sqrt(1/feedback))|
|Vascular|Transit|1.02Hz|1/32|Vascular transit rate|
|Vascular|Alpha|0.33|1/32|Grubb's exponent|
|Vascular|E0|0.34|1/32|Resting oxygen extraction fraction|
|BOLD|Epsilon|1.28 (1.5T), 0.46 (3T), 0.01 (7T)|0|Ratio of intra-to extra-vascular signal contributions|
