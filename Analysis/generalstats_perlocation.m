clc;
clear all; 

% general stats

% subject list
subjects = {'BB'}; % RE, SK
conditions = {'VU'}; %,'LL'}; %,'UL','LL','LR'}; %{'VU','LL','HL','UR','VL','UL','HR','LR'};
%{'LL','UR','UL','LR'};
%{'VU','HL','VL','HR'};
%{'VU','LL','HL','UR','VL','UL','HR','LR'};
%conditions = {'tang_UR','tang_LL','radial_UL','radial_LR'};

M_radialout = [];
M_radialin = [];
M_tang_u = [];
M_tang_l = [];

% rearrange data so that blocks are radial in, radial, out, all tang
for sub=1:length(subjects)
    for cond=1:length(conditions)
        % import data
        subject = subjects{1,sub}; condition = conditions{1, cond};
        savedir = sprintf('../Experimental_SetUp/Data/%s/ExpData/Block1/', subject);
        path = sprintf('../Experimental_SetUp/Data/%s/ExpData/Block1/expRes%s_RadialBias_pilot1_%s.csv', subject,subject, condition);
        if isfile(path)
            M_raw = csvread(path);
            if strcmp(condition, 'LR') % lower right vector
                M_LR = M_raw;
                M_radialout = [M_radialout; M_raw(M_raw(:,3) == 1,:)]; % lower right location
                M_radialin = [M_radialin; M_raw(M_raw(:,3) == 2,:)]; % upper left location
                M_tang_l = [M_tang_l; M_raw(M_raw(:,3) == 3,:)]; % lower left location
                M_tang_u = [M_tang_u; M_raw(M_raw(:,3) == 4,:)]; % upper right location
            elseif strcmp(condition,'UL') % upper left vector
                M_UL = M_raw;
                M_radialout = [M_radialout; M_raw(M_raw(:,3) == 2,:)]; % upper left location
                M_radialin = [M_radialin; M_raw(M_raw(:,3) == 1,:)]; % lower right location
                M_tang = [M_tang; M_raw(M_raw(:,3) == 3,:)]; % lower left location
                M_tang = [M_tang; M_raw(M_raw(:,3) == 4,:)]; % upper right location
            elseif strcmp(condition,'LL') % lower left vector
                 M_LL = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 3,:)]; % lower left location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 4,:)]; % upper right location
                 M_tang_l = [M_tang_l; M_raw(M_raw(:,3) == 1,:)]; % lower right location
                 M_tang_u = [M_tang_u; M_raw(M_raw(:,3) == 2,:)]; % upper left location
            elseif strcmp(condition,'UR') % upper right vector
                 M_UR = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 4,:)]; % upper right location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 3,:)]; % lower left location
                 M_tang_l = [M_tang_l; M_raw(M_raw(:,3) == 1,:)]; % lower right location
                 M_tang_u = [M_tang_u; M_raw(M_raw(:,3) == 2,:)]; % upper left location
            elseif strcmp(condition,'VU') % upper vector
                 M_VU = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 6,:)]; % upper location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 5,:)]; % lower location
                 M_tang_l = [M_tang_l; M_raw(M_raw(:,3) == 7,:)]; % left location
                 M_tang_u = [M_tang_u; M_raw(M_raw(:,3) == 8,:)]; % right location
            elseif strcmp(condition,'VL') % lower vector
                 M_VL = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 5,:)]; % lower location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 6,:)]; % upper location
                 M_tang_l = [M_tang_l; M_raw(M_raw(:,3) == 7,:)]; % left location
                 M_tang_u = [M_tang_u; M_raw(M_raw(:,3) == 8,:)]; % right location
            elseif strcmp(condition,'HR') % right vector
                 M_HR = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 8,:)]; % right location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 7,:)]; % left location
                 M_tang_l = [M_tang_l; M_raw(M_raw(:,3) == 5,:)]; % lower location
                 M_tang_u = [M_tang_u; M_raw(M_raw(:,3) == 6,:)]; % upper location
            elseif strcmp(condition,'HL') % left vector
                 M_HL = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 7,:)]; % left location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 8,:)]; % right location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 5,:)]; % lower location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 6,:)]; % upper location
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
    newfile = sprintf('%s/expRes%s_RadialBias_pilot1_%s.csv', savedir,subject, 'tang_u');
    csvwrite(newfile, M_tang_u)
    newfile = sprintf('%s/expRes%s_RadialBias_pilot1_%s.csv', savedir,subject, 'tang_l');
    csvwrite(newfile, M_tang_l)
end


%%
conditions = {'radial_out','radial_in','tang_u','tang_l'};

for sub=1:length(subjects)
    for cond=1:length(conditions)
        sprintf('~~~~~~~~%s~~~~~~~~~~~', conditions{1,cond})
        % import data
        subject = subjects{1,sub}; condition = conditions{1, cond};
        path = sprintf('../Experimental_SetUp/Data/%s/ExpData/Block1/expRes%s_RadialBias_pilot1_%s.csv', subject,subject, condition);
        disp(path)
        M_raw = csvread(path);
        
        %angle_adjustments = unique(abs(M_raw(:,9)-M_raw(:,10)));
        % added to accurately calculate + and - angles (work around)
        %angle_adjustments = angle_adjustments(angle_adjustments<90);
        angle_adjustments = unique(M_raw(:,6)); % improvement

        total_pc = sum(M_raw(:,14))/length(M_raw(:,14));
        disp('Total calculated percent correct = ')
        disp(total_pc)
        %disp('dprime assuming no bias in criterion (PSYCHOPHYSICS COURSE):')
        %disp(2*norminv(total_pc))
        % dPrime Calculation, accounting for difference in criterion
        Clockwise_stim = M_raw(M_raw(:,11) == 1,:);
        PC_Clockwise = size(Clockwise_stim(Clockwise_stim(:,14) == 1),1)/size(Clockwise_stim,1);
        Hits = size(Clockwise_stim(Clockwise_stim(:,12) == 2,:),1);
        Misses = size(Clockwise_stim(Clockwise_stim(:,12) == 1,:),1);
        CounterClockwise_stim = M_raw(M_raw(:,11) == 0,:);
        PC_CClockwise = size(CounterClockwise_stim(CounterClockwise_stim(:,14) == 1),1)/size(CounterClockwise_stim,1);
        FalseAlarms = size(CounterClockwise_stim(CounterClockwise_stim(:,12) == 2,:),1);
        CorrRejs = size(CounterClockwise_stim(CounterClockwise_stim(:,12) == 1,:),1);
        % hit rate and false alarm rate: https://openwetware.org/wiki/Beauchamp:dprime
        HR = Hits/ (Hits + Misses);
        FAR = FalseAlarms/ (FalseAlarms + CorrRejs);
        dPrime = norminv(HR) - norminv(FAR); % same as above (sometimes)
        disp('dprime with bias in criterion (PSYCHOPHYSICS COURSE):')
        disp(norminv(PC_Clockwise)+norminv(PC_CClockwise));
        disp('dprime (raw calculation)= ')
        disp(dPrime)

        anglep_clockwans = [];
        anglep_nTrials = [];
        anglen_clockwans = [];
        anglen_nTrials = [];

        for angle_idx=1:length(angle_adjustments)
            angle = angle_adjustments(angle_idx);
            %level = M_raw(abs(M_raw(:,7)-M_raw(:,8)) ==angle, :); %i think this is?
            level = M_raw(M_raw(:,6) == angle ,:);
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
        
        if ~isdir(subject)
            mkdir(subject)
        end
        filename = sprintf('%s/Datasummary_%s_%s',subject,subject, condition);
        save(filename, 'clockAnsData')
    end
    
end
