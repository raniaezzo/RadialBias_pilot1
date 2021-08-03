clc;
clear all; 
projectname = 'RadialBias_pilot1';

% define locationids
locationids = 1:8; locationdegrees = {315,135,225,45,270,90,180,0};
locationlabels = strcat('loc_',cellfun(@num2str,locationdegrees,'un',0));
maplocation = containers.Map(locationids,locationlabels);
mapdegree = containers.Map(locationlabels,locationdegrees);
b_iter = 1000; % # of iterations (0 = no bootstrap)

% ensure current directory is correct
checkdir(projectname)

% for each subject, separate data for per condition, per location
[subjectinfo] = getsubjinfo();
subjectinfo = subjectinfo(2); 
%subjectinfo = subjectinfo(4); 

analysis_type = {'RelativeMotion', 'AbsoluteMotion'};

% iterate for each subject
for si=1:length(subjectinfo)
    % create subject directory
    subjectdir = fullfile(pwd,subjectinfo(si).name);
    if ~exist(subjectdir, 'dir')
        mkdir(subjectdir)
    end
    relative_summarypath = sprintf('%s/%s/',subjectdir, analysis_type{1});
    if ~isfile(sprintf('%s/bootci.mat',relative_summarypath))
        initialize_summaryvars(relative_summarypath)
        % iterate for each session
        for bi=1:length(subjectinfo(si).sessionlist_all)
            filepath = char(subjectinfo(si).sessionlist_all(bi));
            M_raw = csvread(filepath);
            % determine motion ref for the session
            [~, filename, ~] = fileparts(filepath);
            splitStr = regexp(filename,'\_','split'); motionref = char(splitStr(end));
            % compute summary stats per condition, per location
            splitcondition(M_raw, motionref, maplocation, b_iter, relative_summarypath);
        end

        % compute params & save in subject dir
        compute_params(relative_summarypath, b_iter)
        
        % compute CI from bootsamples & save in subject dir
        compute_ci(relative_summarypath);
    end
    
    % also save in absolute coordinates
    organize_absolutedirs(relative_summarypath, sprintf('%s/%s/',subjectdir, analysis_type{2}), 'individual');
    
    for i=1:length(analysis_type)
        i = 2;
        analysis_path = sprintf('%s/%s/',subjectdir, analysis_type{i});
        
        % load all summary stats for figures
        load(fullfile(analysis_path,'summarydata.mat'))
        load(fullfile(analysis_path,'analyzeddata.mat'))
        load(fullfile(analysis_path,'bootci.mat'))

        figuresdir = fullfile(analysis_path, 'figures');
        if ~exist(figuresdir, 'dir')
            mkdir(fullfile(figuresdir,'pngs'));
            mkdir(fullfile(figuresdir,'figs'));
            mkdir(fullfile(figuresdir,'bmps'));
        end

        if strcmp(analysis_type{i}, 'AbsoluteMotion')
        
            % plot the polar angle plots for 8 absolute dirs
            eight_main_conditions = {params_upwards,params_downwards,params_leftwards,params_rightwards, ...
                params_lowerleftwards, params_lowerrightwards, params_upperleftwards, params_upperrightwards};
            eight_ci_values = {bootci_upwards,bootci_downwards,bootci_leftwards,bootci_rightwards, ...
                bootci_lowerleftwards, bootci_lowerrightwards, bootci_upperleftwards, bootci_upperrightwards};
            plotpolar(8, 'sensitivity', 'absolute', figuresdir, eight_main_conditions, mapdegree,...
                eight_ci_values)
            plotpolar(8, 'bias', 'absolute', figuresdir, eight_main_conditions, mapdegree,...
                eight_ci_values)
            
            % plot vector plot for 8 absolute dirs
            plot_VP(figuresdir,analysis_type{i})
            
        elseif strcmp(analysis_type{i}, 'RelativeMotion')
        
            % plot the polar angle plots for 4 conditions
            %four_main_conditions = {params_radialout,params_radialin,params_tangleft,params_tangright};
            %four_ci_values = {bootci_radialout,bootci_radialin,bootci_tangleft,bootci_tangright};
            %plotpolar(4, 'bias', 'relative', figuresdir, four_main_conditions, mapdegree,...
            %    four_ci_values)
            %plotpolar(4, 'sensitivity', 'relative', figuresdir, four_main_conditions, mapdegree,...
            %    four_ci_values)
            four_main_conditions = {params_radialout,params_radialin,params_tangleft,params_tangright};
            four_ci_values = {bootci_radialout,bootci_radialin,bootci_tangleft,bootci_tangright};
            plotpolar(4, 'bias', 'relative', figuresdir, four_main_conditions, mapdegree,...
                four_ci_values)
            plotpolar(4, 'sensitivity', 'relative', figuresdir, four_main_conditions, mapdegree,...
                four_ci_values)

            % plot the polar angle plots for 2 conditions
            two_main_conditions = {params_radial,params_tang};
            two_ci_values = {bootci_radial,bootci_tang};
            plotpolar(2, 'sensitivity', 'relative', figuresdir, two_main_conditions, mapdegree,...
                two_ci_values)
            plotpolar(2, 'bias', 'relative', figuresdir, two_main_conditions, mapdegree,...
                two_ci_values)

            four_cond = {summary_radialout,summary_radialin,summary_tangleft, ...
                summary_tangright};
            four_params = {params_radialout, params_radialin, params_tangleft, ...
                params_tangright};
            plot_PF(4, figuresdir, four_cond, four_params)

            two_cond = {summary_radial,summary_tang};
            two_params = {params_radial, params_tang};
            plot_PF(2, figuresdir, two_cond, two_params)

        end
    end
    
end

%%
clc;
clear all;
analysis_type = {'RelativeMotion', 'AbsoluteMotion'};
[subjectinfo] = getsubjinfo();
% define locationids
locationids = 1:8; locationdegrees = {315,135,225,45,270,90,180,0};
locationlabels = strcat('loc_',cellfun(@num2str,locationdegrees,'un',0));
maplocation = containers.Map(locationids,locationlabels);
mapdegree = containers.Map(locationlabels,locationdegrees);

for si=1:length(subjectinfo)
    % create subject directory
    subjectdata = fullfile(pwd,subjectinfo(si).name,'RelativeMotion','analyzeddata.mat');
    init.(subjectinfo(si).name) = load(subjectdata);
end

data_radialin = []; data_radialout = []; data_tangright = [];
data_tangleft = []; data_radial = []; data_tang = [];
error_radialin = []; error_radialout = []; error_tangright = [];
error_tangleft = []; error_radial = []; error_tang = [];
for si=1:length(subjectinfo)
    data_radialin = [data_radialin init.(subjectinfo(si).name).params_radialin];
    error_radialin = [error_radialin init.(subjectinfo(si).name).bootparams_radialin];
    data_radialout = [data_radialout init.(subjectinfo(si).name).params_radialout];
    error_radialout = [error_radialout init.(subjectinfo(si).name).bootparams_radialout];
    data_tangright = [data_tangright init.(subjectinfo(si).name).params_tangright];
    error_tangright = [error_tangright init.(subjectinfo(si).name).bootparams_tangright];
    data_tangleft = [data_tangleft init.(subjectinfo(si).name).params_tangleft];
    error_tangleft = [error_tangleft init.(subjectinfo(si).name).bootparams_tangleft];
    
    data_radial = [data_radial init.(subjectinfo(si).name).params_radial];
    error_radial = [error_radial init.(subjectinfo(si).name).bootparams_radial];
    data_tang = [data_tang init.(subjectinfo(si).name).params_tang];
    error_tang = [error_tang init.(subjectinfo(si).name).bootparams_tang];
end

% find mean (sensitivity/bias) per location across subjects

% find SEM (sensitivity/bias) per location across subjects
% this is std(paramest)/sqrt(n) :: is paramest not of bootstrap?

allsubjectsdir = fullfile(pwd, 'ALLSUBJ');
relative_summarypath = sprintf('%s/%s/',allsubjectsdir, analysis_type{1});
figuresdir = fullfile(relative_summarypath,'figures');
if ~exist(figuresdir, 'dir')
    mkdir(fullfile(figuresdir,'pngs'));
    mkdir(fullfile(figuresdir,'figs'));
    mkdir(fullfile(figuresdir,'bmps'));
end


[params_radial, sem_radial] = MeanStructFields(data_radial);
[params_tang, sem_tang] = MeanStructFields(data_tang);
[params_radialin, sem_radialin] = MeanStructFields(data_radialin);
[params_radialout, sem_radialout] = MeanStructFields(data_radialout);
[params_tangright, sem_tangright] = MeanStructFields(data_tangright);
[params_tangleft, sem_tangleft] = MeanStructFields(data_tangleft);

% need to save this to relative directory for ALLSUBJ!
save(fullfile(relative_summarypath,'analyzeddata'), 'params_radialout',...
    'sem_radialout','params_radialin', 'sem_radialin',...
    'params_tangleft','sem_tangleft', ...
    'params_tangright','sem_tangright', 'params_radial', ...
    'sem_radial', 'params_tang', 'sem_tang')

% plot the polar angle plots for 2 conditions
two_main_conditions = {params_radial,params_tang};
two_sem_values = {sem_radial,sem_tang};
plotpolar(2, 'sensitivity', 'relative', figuresdir, two_main_conditions, mapdegree,...
    two_sem_values)
plotpolar(2, 'bias', 'relative', figuresdir, two_main_conditions, mapdegree,...
    two_sem_values)

% plot the polar angle plots for 4 conditions
four_main_conditions = {params_radialout,params_radialin,params_tangleft,params_tangright};
four_sem_values = {sem_radialout,sem_radialin,sem_tangleft,sem_tangright};
plotpolar(4, 'sensitivity', 'relative', figuresdir, four_main_conditions, mapdegree,...
    four_sem_values)
plotpolar(4, 'bias', 'relative', figuresdir, four_main_conditions, mapdegree,...
    four_sem_values)
    
%% transform to z-score
[output] = MeanStructFields_zscore({data_radial, data_tang});
zscore_data_radial = output{1}; zscore_data_tang = output{2};
[output] = MeanStructFields_zscore({data_radialin, data_radialout, ...
    data_tangright, data_tangleft});
zscore_data_radialin = output{1}; zscore_data_radialout = output{2}; 
zscore_data_tangright = output{3}; zscore_data_tangleft = output{4};

[zscore_params_radial, zscore_sem_radial] = MeanStructFields(zscore_data_radial);
[zscore_params_tang, zscore_sem_tang] = MeanStructFields(zscore_data_tang);
[zscore_params_radialin, zscore_sem_radialin] = MeanStructFields(zscore_data_radialin);
[zscore_params_radialout, zscore_sem_radialout] = MeanStructFields(zscore_data_radialout);
[zscore_params_tangright, zscore_sem_tangright] = MeanStructFields(zscore_data_tangright);
[zscore_params_tangleft, zscore_sem_tangleft] = MeanStructFields(zscore_data_tangleft);

% need to save this to relative directory for ALLSUBJ!
save(fullfile(relative_summarypath,'zscoredata'), 'zscore_params_radialout',...
    'zscore_sem_radialout','zscore_params_radialin', 'zscore_sem_radialin',...
    'zscore_params_tangleft','zscore_sem_tangleft', ...
    'zscore_params_tangright','zscore_sem_tangright', 'zscore_params_radial', ...
    'zscore_sem_radial', 'zscore_params_tang', 'zscore_sem_tang')

% plot the polar angle plots for 2 conditions
two_main_conditions = {zscore_params_radial,zscore_params_tang};
two_sem_values = {zscore_sem_radial,zscore_sem_tang};
plotpolar(2, 'z-score sensitivity', 'relative', figuresdir, two_main_conditions, mapdegree,...
    two_sem_values)
plotpolar(2, 'z-score bias', 'relative', figuresdir, two_main_conditions, mapdegree,...
    two_sem_values)

% plot the polar angle plots for 4 conditions
four_main_conditions = {zscore_params_radialout,zscore_params_radialin,zscore_params_tangleft,zscore_params_tangright};
four_sem_values = {zscore_sem_radialout,zscore_sem_radialin,zscore_sem_tangleft,zscore_sem_tangright};
plotpolar(4, 'z-score sensitivity', 'relative', figuresdir, four_main_conditions, mapdegree,...
    four_sem_values)
plotpolar(4, 'z-score bias', 'relative', figuresdir, four_main_conditions, mapdegree,...
    four_sem_values)

%%

% ABSOLUTE MOTION
% also save in absolute coordinates
absolute_summarypath = sprintf('%s/%s/',allsubjectsdir, analysis_type{2});
figuresdir = fullfile(absolute_summarypath,'figures');
if ~exist(figuresdir, 'dir')
    mkdir(fullfile(figuresdir,'pngs'));
    mkdir(fullfile(figuresdir,'figs'));
    mkdir(fullfile(figuresdir,'bmps'));
end

organize_absolutedirs(relative_summarypath, absolute_summarypath, 'group');

plot_VP(figuresdir,analysis_type{2})

% not create sem for polar plots

for si=1:length(subjectinfo)
    % create subject directory
    subjectdata = fullfile(pwd,subjectinfo(si).name,'AbsoluteMotion','analyzeddata.mat');
    init.(subjectinfo(si).name) = load(subjectdata);
end

data_downwards = []; data_upwards = []; data_rightwards = [];
data_leftwards = []; data_lowerleftwards = []; data_lowerrightwards = [];
data_upperleftwards = []; data_upperrightwards = [];

for si=1:length(subjectinfo)
    data_downwards = [data_downwards init.(subjectinfo(si).name).params_downwards];
    data_upwards = [data_upwards init.(subjectinfo(si).name).params_upwards];
    data_rightwards = [data_rightwards init.(subjectinfo(si).name).params_rightwards];
    data_leftwards = [data_leftwards init.(subjectinfo(si).name).params_leftwards];
    data_lowerleftwards = [data_lowerleftwards init.(subjectinfo(si).name).params_lowerleftwards];
    data_lowerrightwards = [data_lowerrightwards init.(subjectinfo(si).name).params_lowerrightwards];
    data_upperleftwards = [data_upperleftwards init.(subjectinfo(si).name).params_upperleftwards];
    data_upperrightwards = [data_upperrightwards init.(subjectinfo(si).name).params_upperrightwards];
end

[params_downwards, sem_downwards] = MeanStructFields(data_downwards);
[params_upwards, sem_upwards] = MeanStructFields(data_upwards);
[params_rightwards, sem_rightwards] = MeanStructFields(data_rightwards);
[params_leftwards, sem_leftwards] = MeanStructFields(data_leftwards);
[params_lowerleftwards, sem_lowerleftwards] = MeanStructFields(data_lowerleftwards);
[params_lowerrightwards, sem_lowerrightwards] = MeanStructFields(data_lowerrightwards);
[params_upperleftwards, sem_upperleftwards] = MeanStructFields(data_upperleftwards);
[params_upperrightwards, sem_upperrightwards] = MeanStructFields(data_upperrightwards);

% add other abs plots
eight_main_conditions = {params_upwards,params_downwards,params_leftwards,params_rightwards, ...
    params_lowerleftwards, params_lowerrightwards, params_upperleftwards, params_upperrightwards};
eight_ci_values = {sem_upwards,sem_downwards,sem_leftwards,sem_rightwards, ...
    sem_lowerleftwards, sem_lowerrightwards, sem_upperleftwards, sem_upperrightwards};
plotpolar(8, 'sensitivity', 'absolute', figuresdir, eight_main_conditions, mapdegree,...
    eight_ci_values)
plotpolar(8, 'bias', 'absolute', figuresdir, eight_main_conditions, mapdegree,...
    eight_ci_values)

%%

% need to include all conditions
function [output] = MeanStructFields_zscore(conditionarray)
    S = conditionarray{1};
    init_zscore = conditionarray; % to return identical conds in input
    fields = fieldnames(S);
    allsubj_bias = []; allsubj_sensitivity = []; 
    for ss = 1:length(S) % # of subj = # of rows
        bias_vector = []; sensitivity_vector = [];
        for cc = 1:length(conditionarray)
            C = conditionarray{cc};
            for k = 1:numel(fields)
                fieldname = fields(k); fieldname = fieldname{1};
                bias_vector = [bias_vector, C(ss).(fieldname)(1)];
                sensitivity_vector = [sensitivity_vector, C(ss).(fieldname)(2)];
            end
        end
        subjmean_bias = mean(bias_vector); 
        subjstd_bias = std(bias_vector);
        subjmean_sensitivity = mean(sensitivity_vector); 
        subjstd_sensitivity = std(sensitivity_vector);
        % calculate z-score
        for cc = 1:length(init_zscore)
            for k = 1:numel(fields)
                fieldname = fields(k); fieldname = fieldname{1};
                %bias_vector = [bias_vector, C(ss).(fieldname)(1)];
                init_zscore{cc}(ss).(fieldname)(1) = (init_zscore{cc}(ss).(fieldname)(1) - subjmean_bias)/subjstd_bias;
                %sensitivity_vector = [sensitivity_vector, C(ss).(fieldname)(2)];
                init_zscore{cc}(ss).(fieldname)(2) = (init_zscore{cc}(ss).(fieldname)(2) - subjmean_sensitivity)/subjstd_sensitivity;
            end
        end
        %allloc_bias = [allsubj_bias, zscore(bias_vector, 0, 'all')];
        %allloc_sensitivity = [allsubj_sensitivity, zscore(sensitivity_vector, 0, 'all')];
    end
    output = init_zscore
end

% https://statquest.org/the-standard-error-and-a-bootstrapping-bonus/

function [average,sem] = MeanStructFields(S)
    fields = fieldnames(S);
    for k = 1:numel(fields)
      ave = mean(cat(1,S.(fields{k})));
      average.(fields{k}) = ave;
      disp(ave)
      sem_temp = std(cat(1,S.(fields{k})))/sqrt(length(S));
      sem_temp = sem_temp./2;
      disp(sem_temp)
      param_cis = nan(2,2,2);
      param_cis(:,1,1) = [ave(1)-sem_temp(1);ave(1)+sem_temp(1)]; % sem bias
      param_cis(:,2,1) = [ave(2)-sem_temp(2);ave(2)+sem_temp(2)]; % sem sensitivity
      disp(param_cis)
      sem.(fields{k}) = param_cis;
    end
end




