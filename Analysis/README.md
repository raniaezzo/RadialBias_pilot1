Analysis Code Requires:

PsychToolbox
Matlab Optimization Toolbox from Mathworks
Palamedes Toolbox: http://www.palamedestoolbox.org (only uses plotting function PF, not used for fitting)
If not using Matlab_R2020a or later, you might get an error in the FitCumNormYN, not detecting optimation toolbox. To fix this, either (1) download R2020a or later, or (2)  change line in FitCumNormYN.m from if (exist('fmincon') == 2) to if (exist('fmincon') == 2) || (exist('fmincon') == 6)

Running instructions:

In Matlab run Analysis/preprocess.m
(Either add Experimental directory and subdirectories to Matlab path, or run script anywhere within Experimental Directory)

Scripts

preprocess: main script that runs all functions to sort data, fit data to psychometric functions, and plot figures

checkdir: called by preprocess, ensures user is in correct directory, otherwise sets current directory

splitcondition: called by preprocess, and sorts data based on condition/location

compute_summary: called by splitcondition; computes summary stats (# clockwise responses, # trials, percent correct)

fit_PF: called by preprocess; defines parameters for psychometric fitting and fits using Palamedes function

plotpolar: called by preprocess; plots the polar plot figures

Output

$subject/summarydata.mat: contains structs for each condition produced by compute_summary function; each location is organized within condition struct

	summary_radialin
	summary_radialout
	summary_tangleft
	summary_tangright
	bootsummary_radialin
	bootsummary_radialout
	bootsummary_tangleft
	bootsummary_tangright

$subject/analyzedata.mat: contains structs for each condition produced by fit_PF function; each location in organized within condition struct

	params_radialin
	params_radialout
	params_tangleft
	params_tangright
	bootparams_radialin
	bootparams_radialout
	bootparams_tangleft
	bootparams_tangright

$subject/figures: contains all figures analyzed by main script


