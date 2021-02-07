clc;
clear all; 

% general stats

% subject list
subjects = {'SK'}; % RE
conditions = {'tang_UR','tang_LL','radial_UL','radial_LR'};

M_radialout = [];
M_radialin = [];
M_tang = [];

% rearrange data so that blocks are radial in, radial, out, all tang
for sub=1:length(subjects)
    for cond=1:length(conditions)
        % import data
        subject = subjects{1,sub}; condition = conditions{1, cond};
        savedir = sprintf('../Experimental_SetUp/Data/%s/ExpData/Block1/', subject);
        path = sprintf('../Experimental_SetUp/Data/%s/ExpData/Block1/expRes%s_RadialBias_pilot1_%s.csv', subject,subject, condition);
        if isfile(path)
            M_raw = csvread(path);
            if strcmp(condition, 'radial_LR')
                M_radialout = [M_radialout; M_raw(M_raw(:,3) == 1,:)]; % lower right vector, lower right location
                M_radialin = [M_radialin; M_raw(M_raw(:,3) == 2,:)]; % lower right vector, upper left location
            elseif strcmp(condition,'radial_UL')
                M_radialout = [M_radialout; M_raw(M_raw(:,3) == 2,:)]; % upper left vector, upper left location
                M_radialin = [M_radialin; M_raw(M_raw(:,3) == 1,:)]; % upper left vector, lower right location
            elseif strcmp(condition, 'tang_LL') || strcmp(condition, 'tang_UR')
                    M_raw = csvread(path);
                    M_tang = [M_tang; M_raw(:,:)]; % all locations treated the same for tang
            end
        else % not path
            disp(sprintf('path does not exist for %s', path))
            disp('.. skipping this condition')
        end
    end
    
    newfile = sprintf('%s/expRes%s_RadialBias_pilot1_%s.csv', savedir,subject, 'radial_out');
    csvwrite(newfile,M_radialout)
    newfile = sprintf('%s/expRes%s_RadialBias_pilot1_%s.csv', savedir,subject, 'radial_in');
    csvwrite(newfile, M_radialin)
    newfile = sprintf('%s/expRes%s_RadialBias_pilot1_%s.csv', savedir,subject, 'tang');
    csvwrite(newfile, M_tang)
end


%%
conditions = {'tang','radial_out','radial_in'};

for sub=1:length(subjects)
    for cond=1:length(conditions)
        % import data
        subject = subjects{1,sub}; condition = conditions{1, cond};
        path = sprintf('../Experimental_SetUp/Data/%s/ExpData/Block1/expRes%s_RadialBias_pilot1_%s.csv', subject,subject, condition);
        disp(path)
        M_raw = csvread(path);
        
        angle_adjustments = unique(abs(M_raw(:,9)-M_raw(:,10)));

        total_pc = sum(M_raw(:,14))/length(M_raw(:,14));
        disp('Total calculated percent correct = ')
        disp(total_pc)

        anglep_clockwans = [];
        anglep_nTrials = [];
        anglen_clockwans = [];
        anglen_nTrials = [];

        for angle_idx=1:length(angle_adjustments)
            angle = angle_adjustments(angle_idx);
            level = M_raw(abs(M_raw(:,7)-M_raw(:,8)) ==angle, :); 
            level_pc = sum(level(:,14))/length(level(:,14));
            
            actual_clockwise_level = level(level(:,11) == 1,:);
            actual_cclockwise_level = level(level(:,11) ~= 1,:);

            anglep_nTrials = [anglep_nTrials size(actual_clockwise_level,1)];
            anglep_clockwans = [anglep_clockwans size(actual_clockwise_level(actual_clockwise_level(:,12) == 2,:),1)];
            anglen_nTrials = [anglen_nTrials size(actual_cclockwise_level,1)];
            anglen_clockwans = [anglen_clockwans size(actual_cclockwise_level(actual_cclockwise_level(:,12) == 2,:),1)];

        end

        nTrials_levels = [flip(anglen_nTrials) anglep_nTrials];
        clockAns_levels = [flip(anglen_clockwans) anglep_clockwans];
        perCorrect_levels = clockAns_levels ./ nTrials_levels;

        tiltArray = [flip(angle_adjustments*-1); angle_adjustments]';
        
        clockAnsData.(condition) = [nTrials_levels;clockAns_levels;perCorrect_levels;tiltArray];
        
        clockAnsData.('rownames') = {'NumTrials';'AnsClockwise';'PercAnsClockwise';'AddedTilt'};
        
        filename = sprintf('Datasummary_%s_%s',subject, condition);
        save(filename, 'clockAnsData')
    end
    
end

