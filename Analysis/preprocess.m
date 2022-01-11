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
%subjectinfo = subjectinfo(4); % choose subject

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
    absolute_summarypath = sprintf('%s/%s/',subjectdir, 'AbsoluteMotion');
    relative_summarypath = sprintf('%s/%s/',subjectdir, 'RelativeMotion');
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
            [main_conditions, ci_values, boot] = select_mainconditions(analysis_path, ...
                    organization, b_iter);
        
            % plot the polar angle plots for 8 absolute dirs
            plotpolar(length(organization), 'sensitivity', 'absolute', figuresdir, ...
                main_conditions, mapdegree, ci_values, organization)
            
            % plot vector plot for 8 absolute dirs
            plot_VP(figuresdir,main_conditions, organization)

            % all directions per location
            [mean_acrossloc, locvalues, ci_acrossloc] = average_direction(main_conditions, boot, organization, b_iter);
            organization = {'lower VF', 'upper VF'};
            plotbar(figuresdir, mean_acrossloc, locvalues, ci_acrossloc, organization);
            
%             % add PFs
                 
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
                    [main_conditions, ci_values, boot] = select_mainconditions(analysis_path, ...
                    organization, b_iter);
                
                    [mean_acrossloc, locvalues, ci_acrossloc] = average_condition(main_conditions, boot, organization);
                    plotbar(figuresdir, mean_acrossloc, locvalues, ci_acrossloc, organization);

                    % plot the polar angle plots for 2 conditions
                    plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                    plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)

                elseif strcmp(analysis_subtype{ai}, 'RADIALTANG_4')
                    organization = {'radial_in','radial_out','tang_right','tang_left'};
                    [main_conditions, ci_values, boot] = select_mainconditions(analysis_path, ...
                    organization, b_iter);
               
                    [mean_acrossloc, locvalues, ci_acrossloc] = average_condition(main_conditions, boot, organization);
                    plotbar(figuresdir, mean_acrossloc, locvalues, ci_acrossloc, organization);
                
                    plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                    plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                    
                elseif strcmp(analysis_subtype{ai}, 'CARDINALOBLIQUE')
                    organization = {'cardinal','oblique'};
                    [main_conditions, ci_values, boot] = select_mainconditions(analysis_path, ...
                    organization, b_iter);
                
                    [mean_acrossloc, locvalues, ci_acrossloc] = average_condition(main_conditions, boot, organization);
                    plotbar(figuresdir, mean_acrossloc, locvalues, ci_acrossloc, organization);
                    
                    plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                    plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                        main_conditions, mapdegree, ci_values, organization)
                end

            end

        end
    end
     
end

%% BAR PLOTS

% %%%%% BAR PLOTS %%%%%%
% average_locations2(relative_summarypath)
% %%%%average across locations%%%%
% (1) upper vs. lower
% (2) radial-cardinal vs. tang-cardinal vs. radial-off-cardinal vs.
% tang-off-cardinal
% (3) radial/tang cardinal, radial/tang off-cardinal,
% oblique-cardinal, oblique-off-cardinal
% (4) each absolute direction?

for si=1:length(subjectinfo)
    % create subject directory
    subjectdir = fullfile(pwd,subjectinfo(si).name);
    absolute_summarypath = fullfile(subjectdir, analysis_type{1});
    relative_summarypath = fullfile(subjectdir, analysis_type{2});
    radialtang_dir = fullfile(relative_summarypath, 'RADIALTANG_2');
    cardinaloblique_dir = fullfile(relative_summarypath, 'CARDINALOBLIQUE');
    
    average_condition(main_conditions, organization)
    
    
end

%% MEAN SUBJECT DATA
analysis_type = {'RelativeMotion'};
analysis_subtype = {'RADIALTANG_2','RADIALTANG_4','CARDINALOBLIQUE'};
b_iter = 0;
% create mean params, and sem
for i=1:length(analysis_type) % relative or absolute motion
    
    analysis_type_path = fullfile(cd, 'ALLSUBJ', analysis_type{i});
    if strcmp(analysis_type{i}, 'RelativeMotion')
        
        for ai=1:length(analysis_subtype) % RADIALTANG or CARDINALOBLIQUE
            disp('~~~~~~')
            disp(analysis_subtype{ai})
            
            % temporary, until all data is collected
            subjects_w_radialtang = {'BB','FH','NH','PW','RE','ME','SX'};
            subjects_w_all = {'RE','ME','SX'}; % two full datasets
                
            analysis_path = fullfile(analysis_type_path, analysis_subtype{ai});

            figuresdir = fullfile(analysis_path, 'figures');
            if ~exist(figuresdir, 'dir')
                mkdir(fullfile(figuresdir,'pngs'));
                mkdir(fullfile(figuresdir,'figs'));
                mkdir(fullfile(figuresdir,'pdfs'));
            end

            %mean_sem_allsubjects(analysis_path, subjects_w_radialtang, 'off');
            
            if strcmp(analysis_subtype{ai}, 'RADIALTANG_2')
                mean_sem_allsubjects(analysis_path, subjects_w_radialtang, 'on');
                organization = {'radial', 'tang'};
                [main_conditions, ci_values, boot] = select_mainconditions(analysis_path, ...
                    organization, b_iter);
                
                %organization = {'ratio'};
                %main_conditions = {main_conditions{1,2}};
                %ci_values = {ci_values{1,2}};
                
                % plot the polar angle plots for 2 conditions
                plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)
                plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)

            elseif strcmp(analysis_subtype{ai}, 'RADIALTANG_4')
                mean_sem_allsubjects(analysis_path, subjects_w_radialtang, 'off');
                organization = {'radial_in','radial_out','tang_right','tang_left'};
                [main_conditions, ci_values, boot] = select_mainconditions(analysis_path, ...
                    organization, b_iter);
                plotpolar(length(organization), 'sensitivity', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)
                plotpolar(length(organization), 'bias', 'relative', figuresdir, ...
                    main_conditions, mapdegree, ci_values, organization)

            elseif strcmp(analysis_subtype{ai}, 'CARDINALOBLIQUE')
                mean_sem_allsubjects(analysis_path, subjects_w_all, 'off');
                organization = {'cardinal','oblique'};
                [main_conditions, ci_values, boot] = select_mainconditions(analysis_path, ...
                    organization, b_iter);
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
    
        mean_sem_allsubjects(analysis_path, subjects, 'off');
        
        organization = {'upwards', 'downwards','leftwards','rightwards', ...
                'lowerleftwards','lowerrightwards','upperleftwards','upperrightwards'};
        [main_conditions, ci_values, boot] = select_mainconditions(analysis_path, ...
                    organization, b_iter);

        % plot the polar angle plots for 8 absolute dirs
        plotpolar(length(organization), 'sensitivity', 'absolute', figuresdir, ...
            main_conditions, mapdegree, ci_values, organization)
        plotpolar(length(organization), 'bias', 'absolute', figuresdir, ...
            main_conditions, mapdegree, ci_values, organization)

        % plot vector plot for 8 absolute dirs
        plot_VP(figuresdir,main_conditions, organization)
    end

end

