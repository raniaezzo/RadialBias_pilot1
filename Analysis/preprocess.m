%% TO DO:
% also combine radialin-out, and tangr-l
% fit polar plots with error bars
    % for bias, add const & min for visualization
% polar plots for both 2 cond, and 4 cond
% plot PF for 2 cond, and 4 cond
% plot sensitivity per block
% plot error within block
% later: fit LME model

clc;
clear all; 
projectname = 'RadialBias_pilot1';

% define locationids
locationids = 1:8; locationdegrees = {315,135,225,45,270,90,180,0};
locationlabels = strcat('loc_',cellfun(@num2str,locationdegrees,'un',0));
maplocation = containers.Map(locationids,locationlabels);
mapdegree = containers.Map(locationlabels,locationdegrees);
b_iter = 5; %1000; % # of iterations (0 = no bootstrap)

% ensure current directory is correct
checkdir(projectname)

% for each subject, separate data for per condition, per location
[subjectinfo] = getsubjinfo();

% iterate for each subject
for si=1:length(subjectinfo)
    summary_radialout = []; summary_radialin = []; summary_tangleft = []; summary_tangright = [];
    bootsummary_radialout = []; bootsummary_radialin = []; bootsummary_tangleft = []; bootsummary_tangright = [];
    % iterate for each session
    for bi=1:length(subjectinfo(si).sessionlist_all)
        % create subject directory
        subjectdir = sprintf('%s',subjectinfo(si).name);
        if ~exist(subjectdir, 'dir')
            mkdir(subjectdir)
        end
        filepath = char(subjectinfo(si).sessionlist_all(bi));
        M_raw = csvread(filepath);
        % determine motion ref for the session
        [~, filename, ~] = fileparts(filepath);
        splitStr = regexp(filename,'\_','split'); motionref = char(splitStr(end));
        % compute summary stats per condition, per location
        [summary_radialout, summary_radialin, summary_tangleft, ...
            summary_tangright,bootsummary_radialout, ...
            bootsummary_radialin, bootsummary_tangleft, ...
            bootsummary_tangright] = splitcondition(M_raw, ... 
            motionref, maplocation, summary_radialout, summary_radialin, ...
            summary_tangleft, summary_tangright, bootsummary_radialout, ...
            bootsummary_radialin, bootsummary_tangleft, ...
            bootsummary_tangright, b_iter);
    end
    
    % save summarydata
    save(sprintf('%s/summarydata',subjectdir), 'summary_radialout',...
        'summary_radialin','summary_tangleft', 'summary_tangright',...
        'bootsummary_radialout','bootsummary_radialin', ...
        'bootsummary_tangleft','bootsummary_tangright')
    
    % fit each condition, per location
    [params_radialout, bootparams_radialout] = ...
        fit_PF(summary_radialout, bootsummary_radialout,b_iter);
    [params_radialin, bootparams_radialin] = ...
        fit_PF(summary_radialin, bootsummary_radialin,b_iter);
    [params_tangleft, bootparams_tangleft] = ...
        fit_PF(summary_tangleft, bootsummary_tangleft,b_iter);
    [params_tangright, bootparams_tangright] = ...
        fit_PF(summary_tangright, bootsummary_tangright,b_iter);
    
    % save analyzed data
    save(sprintf('%s/analyzeddata',subjectdir), 'params_radialout',...
        'bootparams_radialout','params_radialin', 'bootparams_radialin',...
        'params_tangleft','bootparams_tangleft', ...
        'params_tangright','bootparams_tangright')
    
    figuresdir = sprintf('%s/figures/',subjectdir);
    if ~exist(figuresdir, 'dir')
        mkdir(figuresdir)
    end
    % plot the polar angle plots for sensitivity
    plotpolar('sensitivity', subjectinfo(si).name, params_radialout, ...
        params_radialin, params_tangleft, params_tangright, mapdegree)
    plotpolar('bias', subjectinfo(si).name, params_radialout, ...
        params_radialin, params_tangleft, params_tangright, mapdegree)
end





