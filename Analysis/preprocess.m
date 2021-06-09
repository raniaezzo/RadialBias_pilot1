%% TO DO:
% also do across locations -- cardinal/oblique (later)
% plot sensitivity per block (later)
% plot error within block (later)
% later: fit LME model (later)
% make sure that bootstrapping method is ok (esp for 2 cond)

clc;
clear all; 
projectname = 'RadialBias_pilot1';

% define locationids
locationids = 1:8; locationdegrees = {315,135,225,45,270,90,180,0};
locationlabels = strcat('loc_',cellfun(@num2str,locationdegrees,'un',0));
maplocation = containers.Map(locationids,locationlabels);
mapdegree = containers.Map(locationlabels,locationdegrees);
b_iter = 5; %200; %1000; % # of iterations (0 = no bootstrap)

% ensure current directory is correct
checkdir(projectname)

% for each subject, separate data for per condition, per location
[subjectinfo] = getsubjinfo();
subjectinfo = subjectinfo(1); 
%subjectinfo = [subjectinfo(1),subjectinfo(3)]; % BB and RE

% iterate for each subject
for si=1:length(subjectinfo)
    % create subject directory
    subjectdir = fullfile(pwd,subjectinfo(si).name);
    if ~exist(subjectdir, 'dir')
        mkdir(subjectdir)
    end
    if ~isfile(sprintf('%s/bootci.mat',subjectdir))
        summary_radialout = []; summary_radialin = []; summary_tangleft = []; summary_tangright = [];
        bootsummary_radialout = []; bootsummary_radialin = []; bootsummary_tangleft = []; bootsummary_tangright = [];
        % iterate for each session
        for bi=1:length(subjectinfo(si).sessionlist_all)
            filepath = char(subjectinfo(si).sessionlist_all(bi));
            M_raw = csvread(filepath);
            % determine motion ref for the session
            [~, filename, ~] = fileparts(filepath);
            splitStr = regexp(filename,'\_','split'); motionref = char(splitStr(end));
            % compute summary stats per condition, per location
            [summary_radialout, summary_radialin, summary_tangleft, ...
                summary_tangright, bootsummary_radialout,bootsummary_radialin, ...
                bootsummary_tangleft, bootsummary_tangright] = splitcondition(M_raw, ... 
                motionref, maplocation, summary_radialout, summary_radialin, ...
                summary_tangleft, summary_tangright, bootsummary_radialout, ...
                bootsummary_radialin, bootsummary_tangleft, ...
                bootsummary_tangright, b_iter);
        end

        % create radial and tang (for analysis combining them)
        [summary_radial, summary_tang, bootsummary_radial, ...
        bootsummary_tang] = create2conditions(summary_radialout, summary_radialin, ...
            summary_tangleft, summary_tangright,bootsummary_radialout, ...
            bootsummary_radialin, bootsummary_tangleft, bootsummary_tangright);

        % save summarydata
        save(sprintf('%s/summarydata',subjectdir), 'summary_radialout',...
            'summary_radialin','summary_tangleft', 'summary_tangright',...
            'summary_radial','summary_tang', 'bootsummary_radialout', ...
            'bootsummary_radialin', 'bootsummary_tangleft', ...
            'bootsummary_tangright','bootsummary_radial','bootsummary_tang')

        % fit each condition, per location
        [params_radialout, bootparams_radialout] = ...
            fit_PF(summary_radialout, bootsummary_radialout,b_iter);
        [params_radialin, bootparams_radialin] = ...
            fit_PF(summary_radialin, bootsummary_radialin,b_iter);
        [params_tangleft, bootparams_tangleft] = ...
            fit_PF(summary_tangleft, bootsummary_tangleft,b_iter);
        [params_tangright, bootparams_tangright] = ...
            fit_PF(summary_tangright, bootsummary_tangright,b_iter);
        [params_radial, bootparams_radial] = ...
            fit_PF(summary_radial, bootsummary_radial,b_iter);
        [params_tang, bootparams_tang] = ...
            fit_PF(summary_tang, bootsummary_tang,b_iter);

        % save analyzed data
        save(sprintf('%s/analyzeddata',subjectdir), 'params_radialout',...
            'bootparams_radialout','params_radialin', 'bootparams_radialin',...
            'params_tangleft','bootparams_tangleft', ...
            'params_tangright','bootparams_tangright', 'params_radial', ...
            'bootparams_radial', 'params_tang', 'bootparams_tang')

    else
        load(sprintf('%s/summarydata.mat',subjectdir))
        load(sprintf('%s/analyzeddata.mat',subjectdir))
    end
    
    % compute CI froom bootsamples & save in subject dir
    compute_ci(subjectdir, bootparams_radialout, ...
    bootparams_radialin, bootparams_tangleft, bootparams_tangright, ...
    bootparams_radial,bootparams_tang);
    
    load(sprintf('%s/bootci.mat',subjectdir))
    
    figuresdir = fullfile(subjectdir, 'figures');
    if ~exist(figuresdir, 'dir')
        mkdir(fullfile(figuresdir,'pngs'));
        mkdir(fullfile(figuresdir,'figs'));
        mkdir(fullfile(figuresdir,'bmps'));
    end
    
    
    % plot the polar angle plots for 4 conditions
    four_main_conditions = {params_radialout,params_radialin,params_tangleft,params_tangright};
    four_ci_values = {bootci_radialout,bootci_radialin,bootci_tangleft,bootci_tangright};
    plotpolar(4, 'sensitivity', figuresdir, four_main_conditions, mapdegree,...
        four_ci_values)
    plotpolar(4, 'bias', figuresdir, four_main_conditions, mapdegree,...
        four_ci_values)
    
    % plot the polar angle plots for 2 conditions
    two_main_conditions = {params_radial,params_tang};
    two_ci_values = {bootci_radial,bootci_tang};
    plotpolar(2, 'sensitivity', figuresdir, two_main_conditions, mapdegree,...
        two_ci_values)
    plotpolar(2, 'bias', figuresdir, two_main_conditions, mapdegree,...
        two_ci_values)

    four_cond = {summary_radialout,summary_radialin,summary_tangleft, ...
        summary_tangright};
    four_params = {params_radialout, params_radialin, params_tangleft, ...
        params_tangright};
    plot_PF(4, figuresdir, four_cond, four_params)
    
    two_cond = {summary_radial,summary_tang};
    two_params = {params_radial, params_tang};
    plot_PF(2, figuresdir, two_cond, two_params)
    
    close all;
    
end

%%
clc;
clear all;
[subjectinfo] = getsubjinfo();
% define locationids
locationids = 1:8; locationdegrees = {315,135,225,45,270,90,180,0};
locationlabels = strcat('loc_',cellfun(@num2str,locationdegrees,'un',0));
maplocation = containers.Map(locationids,locationlabels);
mapdegree = containers.Map(locationlabels,locationdegrees);

for si=1:length(subjectinfo)
    % create subject directory
    subjectdata = fullfile(pwd,subjectinfo(si).name,'analyzeddata.mat');
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
figuresdir = fullfile(allsubjectsdir, 'figures');
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


% plot the polar angle plots for 4 conditions
four_main_conditions = {params_radialout,params_radialin,params_tangleft,params_tangright};
four_sem_values = {sem_radialout,sem_radialin,sem_tangleft,sem_tangright};
plotpolar(4, 'sensitivity', figuresdir, four_main_conditions, mapdegree,...
    four_sem_values)
plotpolar(4, 'bias', figuresdir, four_main_conditions, mapdegree,...
    four_sem_values)
    
% plot the polar angle plots for 2 conditions
two_main_conditions = {params_radial,params_tang};
two_sem_values = {sem_radial,sem_tang};
plotpolar(2, 'sensitivity', figuresdir, two_main_conditions, mapdegree,...
    two_sem_values)
plotpolar(2, 'bias', figuresdir, two_main_conditions, mapdegree,...
    two_sem_values)


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




