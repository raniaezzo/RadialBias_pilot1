function mean_sem_allsubjects(analysis_path, subjects)

examplesubject = subjects{1};

subjpath = strrep(analysis_path,'ALLSUBJ',examplesubject);
locations = dir([subjpath '/loc_*']); locations = setdiff({locations.name},{'.','..', '.DS_Store'});

for li=1:length(locations)
    conditions = dir([fullfile(subjpath, locations{li})]); 
    conditions = setdiff({conditions.name},{'.','..', '.DS_Store'});
end

allsubjs_path = strrep(analysis_path,'ALLSUBJ','*');

for li=1:length(locations)
    for ci=1:length(conditions)
        parampath = fullfile(allsubjs_path,locations{li},conditions{ci},'abs_params.mat');
        d=dir(parampath);  % get the list of files
        x=[];            % start w/ an empty array
        for i=1:length(d)
            load(fullfile(d(i).folder, d(i).name))
            if strcmp(d(i).name, 'ALLSUBJ')
                continue
            elseif ~any(isnan(paramsValues))
                x=[x; paramsValues];   % read/concatenate into x
            end
        end
        
        % take mean
        paramsValues = mean(x,1);
        
        % find sem
        sem = std(x,1)/sqrt(size(x,1)); 
        boot_ci = nan(2,2,2); % maintain nomenclature (although this is sem)
        
        sem_halved = sem./2;
        boot_ci(:,1,1) = [paramsValues(1)-sem_halved(1);paramsValues(1)+sem_halved(1)]; % sem bias
        boot_ci(:,1,2) = [paramsValues(1)-sem_halved(1);paramsValues(1)+sem_halved(1)]; % repeat (SEM)
        boot_ci(:,2,1) = [paramsValues(2)-sem_halved(2);paramsValues(2)+sem_halved(2)]; % sem sensitivity
        boot_ci(:,2,2) = [paramsValues(2)-sem_halved(2);paramsValues(2)+sem_halved(2)]; % repeat (SEM)
        
        allsubj_parampath = fileparts(parampath); % gives directory
        allsubj_parampath = strrep(allsubj_parampath,'*','ALLSUBJ'); % gives file
        
        if ~exist(allsubj_parampath, 'dir')
            mkdir(allsubj_parampath);
        end
        
        % save abs_params
        save(fullfile(allsubj_parampath, 'abs_params.mat'),'paramsValues')
        % save abs_bootci
        save(fullfile(allsubj_parampath, 'abs_bootci.mat'),'boot_ci')
    end
end

end