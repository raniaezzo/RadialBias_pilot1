clc;
clear all; 
rng('default'); rng(1);
projectname = 'RadialBias_pilot1';

% define locationids
locationids = 1:8; locationdegrees = {315,135,225,45,270,90,180,0};
locationlabels = strcat('loc_',cellfun(@num2str,locationdegrees,'un',0));
maplocation = containers.Map(locationids,locationlabels);
mapdegree = containers.Map(locationlabels,locationdegrees);
directionids = 1:8; directiondegrees = {45,225,135,315,90,270,0,180};
directionlabels = {'upperrightwards','lowerleftwards','upperleftwards', ...
    'lowerrightwards','upwards','downwards','rightwards','leftwards'};
mapdirection = containers.Map(directionids,directionlabels);
mapdirectiondegree = containers.Map(directionlabels,directiondegrees);
b_iter = 1000; % # of iterations (0 = no bootstrap)

% ensure current directory is correct, or relocate
checkdir(projectname)
addpath('./_functions') % add folder with all functions

% if data is not present, downloads
% download_osf_data()

% for each subject, separate data for per condition, per location
[subjectinfo] = getsubjinfo();
%subjectinfo = subjectinfo(1);

analysis_type = {'AbsoluteMotion', 'RelativeMotion'};
analysis_subtype = {'RADIALTANG_2','RADIALTANG_4','CARDINALOBLIQUE'};
radialtang_conversion = create_radialtang_dict();

% iterate for each subject
for si=1:length(subjectinfo)
    % create subject directory
    subjectdir = fullfile(pwd,subjectinfo(si).name);
    if ~exist(subjectdir, 'dir')
        mkdir(subjectdir)
    end
    absolute_summarypath = sprintf('%s/%s/',subjectdir, analysis_type{1});
    relative_summarypath = sprintf('%s/%s/',subjectdir, analysis_type{2});
    if ~isfile(sprintf('%s/loc_0/downwards/params_boot.mat',absolute_summarypath))
        M_raw_concatenated = [];
        % iterate for each session
        for bi=1:length(subjectinfo(si).sessionlist_all)
            filepath = char(subjectinfo(si).sessionlist_all(bi));
            M_raw = csvread(filepath);
            % check for other blocks (repeat sessions)
            scannedblocks=0; n_block = 1;
            while scannedblocks == 0
                n_block = n_block+1;
                NewBlock=strrep(filepath,'Block1',sprintf('Block%i',n_block));
                if isfile(NewBlock)
                    M_raw = [M_raw; csvread(NewBlock)];
                else
                    scannedblocks = 1;
                end
            end
            
            M_raw = M_raw(any(M_raw,2),:); % get rid of any rows with broken fixation
            M_raw_concatenated = [M_raw; M_raw_concatenated];
        end
        
        cond_dirs = splitconditions(M_raw_concatenated, absolute_summarypath, maplocation, mapdirection, b_iter);
        
        fit_PF(cond_dirs, b_iter);
        
    end
    
    % get all cond_dirs folders
    if ~exist('cond_dirs','var')
        cond_dirs = dir(fullfile(absolute_summarypath, '*/*/params.mat'));
        cond_dirs = extractfield(cond_dirs,'folder');
    end
    
    save_relative_params(relative_summarypath, absolute_summarypath, cond_dirs, radialtang_conversion)
    
    if ~exist('radialtang4_dirs','var')
        radialtang4_dirs = dir(fullfile(relative_summarypath, 'RADIALTANG_4/*/*/params.mat'));
        radialtang4_dirs = extractfield(radialtang4_dirs,'folder');
    end
    if ~exist('radialtang2_dirs','var')
        radialtang2_dirs = dir(fullfile(relative_summarypath, 'RADIALTANG_2/*/*/params.mat'));
        radialtang2_dirs = extractfield(radialtang2_dirs,'folder');
    end
    if ~exist('cardoblique_dirs','var')
        cardoblique_dirs = dir(fullfile(relative_summarypath, 'CARDINALOBLIQUE/*/*/params.mat'));
        cardoblique_dirs = extractfield(cardoblique_dirs,'folder');
    end
    
    % compute CI from bootsamples & save
    compute_ci(cond_dirs); compute_ci(radialtang4_dirs);
    compute_ci(radialtang2_dirs); compute_ci(cardoblique_dirs);

    % loop through analysis condition (absolute motion, relative motion)
    for i=1:length(analysis_type)
        analysis_path = sprintf('%s/%s/',subjectdir, analysis_type{i});

        if strcmp(analysis_type{i}, 'AbsoluteMotion')
            
            figuresdir = fullfile(analysis_path, 'figures');
            if ~exist(figuresdir, 'dir')
                mkdir(fullfile(figuresdir,'pngs'));
                mkdir(fullfile(figuresdir,'figs'));
                mkdir(fullfile(figuresdir,'pdfs'));
            end
            
            organization = {'upwards', 'downwards','leftwards','rightwards', ...
                'lowerleftwards','lowerrightwards','upperleftwards','upperrightwards'};
            [main_conditions, ci_values] = select_mainconditions(absolute_summarypath, ...
                organization);
        
            % plot the polar angle plots for 8 absolute dirs
            plotpolar(length(organization), 'sensitivity', 'absolute', figuresdir, ...
                main_conditions, mapdegree, ci_values, organization)
            
            % plot vector plot for 8 absolute dirs
            plot_VP(figuresdir,main_conditions, organization)
            
            % load original 6 fit data for PF mapping
%                 load(fullfile(analysis_path,'analyzeddata.mat'))
% 
%                 four_cond = {summary_radialout,summary_radialin,summary_tangleft, ...
%                     summary_tangright};
%                 four_params = {params_radialout, params_radialin, params_tangleft, ...
%                     params_tangright};
%                 plot_PF(4, figuresdir, four_cond, four_params)
% 
%                 two_cond = {summary_radial,summary_tang};
%                 two_params = {params_radial, params_tang};
%                 plot_PF(2, figuresdir, two_cond, two_params)
            
            
        elseif strcmp(analysis_type{i}, 'RelativeMotion')
            
            for ai=1:length(analysis_subtype)
                analysis_path = fullfile(subjectdir, analysis_type{i},analysis_subtype{ai});

                figuresdir = fullfile(analysis_path, 'figures');
                if ~exist(figuresdir, 'dir')
                    mkdir(fullfile(figuresdir,'pngs'));
                    mkdir(fullfile(figuresdir,'figs'));
                    mkdir(fullfile(figuresdir,'pdfs'));
                end

                if strcmp(analysis_subtype{ai}, 'RADIALTANG_2')
                    organization = {'radial','tang'};
                    [main_conditions, ci_values] = select_mainconditions(analysis_path, ...
                    organization);

                    % plot the polar angle plots for 2 conditions
                    plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                    plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)

                elseif strcmp(analysis_subtype{ai}, 'RADIALTANG_4')
                    organization = {'radial_in','radial_out','tang_right','tang_left'};
                    [main_conditions, ci_values] = select_mainconditions(analysis_path, ...
                    organization);
                    plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                    plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                    
                elseif strcmp(analysis_subtype{ai}, 'CARDINALOBLIQUE')
                    organization = {'cardinal','oblique'};
                    [main_conditions, ci_values] = select_mainconditions(analysis_path, ...
                    organization);
                    plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                    plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                end

            end

        end
    end
     
end

%% MEAN SUBJECT DATA

% create mean params, and sem
for i=1:length(analysis_type) % relative or absolute motion
    
    analysis_type_path = fullfile(cd, 'ALLSUBJ', analysis_type{i});
    if strcmp(analysis_type{i}, 'RelativeMotion')
        
        for ai=1:length(analysis_subtype) % RADIALTANG or CARDINALOBLIQUE
            
            % temporary, until all data is collected
            if strcmp(analysis_subtype{ai}, 'RADIALTANG_2') || strcmp(analysis_subtype{ai}, 'RADIALTANG_4')
                subjects = {'BB','FH','NH','PW','RE'};
            elseif strcmp(analysis_subtype{ai}, 'CARDINALOBLIQUE')
                subjects = {'RE'}; % two full datasets
            end
                
            analysis_path = fullfile(analysis_type_path, analysis_subtype{ai});

            figuresdir = fullfile(analysis_path, 'figures');
            if ~exist(figuresdir, 'dir')
                mkdir(fullfile(figuresdir,'pngs'));
                mkdir(fullfile(figuresdir,'figs'));
                mkdir(fullfile(figuresdir,'pdfs'));
            end

            mean_sem_allsubjects(analysis_path, subjects);
            
            if strcmp(analysis_subtype{ai}, 'RADIALTANG_2')
                organization = {'radial','tang'};
                [main_conditions, ci_values] = select_mainconditions(analysis_path, ...
                organization);

                % plot the polar angle plots for 2 conditions
                plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)
                plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)

            elseif strcmp(analysis_subtype{ai}, 'RADIALTANG_4')
                organization = {'radial_in','radial_out','tang_right','tang_left'};
                [main_conditions, ci_values] = select_mainconditions(analysis_path, ...
                organization);
                plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)
                plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)

            elseif strcmp(analysis_subtype{ai}, 'CARDINALOBLIQUE')
                organization = {'cardinal','oblique'};
                [main_conditions, ci_values] = select_mainconditions(analysis_path, ...
                organization);
                plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)
                plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)
            end

        end
    elseif strcmp(analysis_type{i}, 'AbsoluteMotion')
        subjects = {'BB','FH','ME','NH','PW','RE','SX'};
        analysis_path = analysis_type_path;
        
        figuresdir = fullfile(analysis_path, 'figures');
        if ~exist(figuresdir, 'dir')
            mkdir(fullfile(figuresdir,'pngs'));
            mkdir(fullfile(figuresdir,'figs'));
            mkdir(fullfile(figuresdir,'pdfs'));
        end
    
        mean_sem_allsubjects(analysis_path, subjects);
        
        organization = {'upwards', 'downwards','leftwards','rightwards', ...
                'lowerleftwards','lowerrightwards','upperleftwards','upperrightwards'};
        [main_conditions, ci_values] = select_mainconditions(analysis_type_path, ...
            organization);

        % plot the polar angle plots for 8 absolute dirs
        plotpolar(length(organization), 'sensitivity', 'absolute', figuresdir, ...
            main_conditions, mapdegree, ci_values, organization)
        plotpolar(length(organization), 'bias', 'absolute', figuresdir, ...
            main_conditions, mapdegree, ci_values, organization)

        % plot vector plot for 8 absolute dirs
        plot_VP(figuresdir,main_conditions, organization)
    end

end
    
