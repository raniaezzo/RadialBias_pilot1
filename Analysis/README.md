Analysis Code Requires:

PsychToolbox
Matlab Optimization Toolbox from Mathworks

Running instructions:

In Matlab run Analysis/preprocess.m
(Either add Experimental directory and subdirectories to Matlab path, or run script anywhere within Experimental Directory)

Scripts

preprocess: main script that runs all functions to sort data, fit data to psychometric functions, and plot figures

checkdir: called by preprocess, ensures user is in correct directory, otherwise sets current directory

download_osf_data: downloads raw data, and the processed data, then organizes them in the correct directories

getsubjectinfo: creates a struct with all subject info and demographics

create_radialtang_dict: creates dictionary to convert absolute motion directions to radialin, radialout tangright, tangleft

splitconditions: called by preprocess, and sorts data based on condition/location. Returns directories with each location/direction
	compute_summary: creates the matrix needed to fit the psychometric function.

fit_PF: called by preprocess; defines parameters for psychometric fitting and fits using CumNormYN function
	FitCumNormYN_cg: cumulative normal psychometric fitting function. Modified from PsychoToolBox.

save_relative_params: copies and rearranges all files to relative motion directory

compute_ci: computes the confidence intervals from the bootstraps

select_mainconditions: defines which condition to plot

plotpolar: called by preprocess; plots the polar plot figures
	polarwitherrorbar: called by plotpolar to include error bars on polar plot

plot_VP: plots the vector plots in absolute motion condition

Output

$subject/AbsoluteMotion/$location/$absolutemotiondirection: 
	<contains all datafiles for absolute motion directions (upwards, downwards, leftwards, rightwards, upperleftwards, upperrightwards, lowerleftwards, lowerrightwards)>
	
	abs_bootci.mat: confidence intervals of bootstrapped parameters (absolute value is taken of the bias)
	abs_params.mat: paramters returned from the cumulative normal PF fit [bias slope 0 0] (absolute value is taken of the bias)
	abs_params_boot.mat: large matrix of paramters from N bootstrapped fits. Columns match abs_params.mat, row is for each bootstrap iteration (absolute value is taken of the bias)
	params.mat: paramters returned from the cumulative normal PF fit [bias slope 0 0] 
	params_boot.mat: large matrix of paramters from N bootstrapped fits. Columns match abs_params.mat, row is for each bootstrap iteration
	raw_data.mat: raw data file from the experimental code output, specific for this condition
	summarybootstraps.mat: large matrix of summary of the bootstrapped samples prior to fitting. Columns match those in summarytable.mat.
	summarytable.mat: summary of raw data. Labels provided in table.

$subject/RelativeMotion/RADIALTANG_2/$location/$motiondirection: 
	<contains rearranged files from directory above, but organized as radial_in, radial_out, tang_left, tang_right motion directions>

$subject/RelativeMotion/RADIALTANG_4/$location/$motiondirection: 
	<contains rearranged files from directory above, but as radial (mean of radial_in, radial_out) and tangential (mean of tang_left, tang_right)>

$subject/RelativeMotion/CARDINALOBLIQUE/$location/$motiondirection: 
	<contains rearranged files from directory above, but as cardinal (mean of upwards, downwards, leftwards, rightwards) and oblique (mean of upperleftwards, upperrightwards, lowerleftwards, lowerrightwards)>


