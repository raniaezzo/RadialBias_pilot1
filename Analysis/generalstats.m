clc;
clear all; 

% general stats

% subject list
subjects = {'RE'}; % RE, SK
conditions = {'VU','LL','HL','UR','VL','UL','HR','LR'};
%{'LL','UR','UL','LR'};
%{'VU','HL','VL','HR'};
%{'VU','LL','HL','UR','VL','UL','HR','LR'};
%conditions = {'tang_UR','tang_LL','radial_UL','radial_LR'};

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
            if strcmp(condition, 'LR') % lower right vector
                M_LR = M_raw;
                M_radialout = [M_radialout; M_raw(M_raw(:,3) == 1,:)]; % lower right location
                M_radialin = [M_radialin; M_raw(M_raw(:,3) == 2,:)]; % upper left location
                M_tang = [M_tang; M_raw(M_raw(:,3) == 3,:)]; % lower left location
                M_tang = [M_tang; M_raw(M_raw(:,3) == 4,:)]; % upper right location
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
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 1,:)]; % lower right location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 2,:)]; % upper left location
            elseif strcmp(condition,'UR') % upper right vector
                 M_UR = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 4,:)]; % upper right location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 3,:)]; % lower left location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 1,:)]; % lower right location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 2,:)]; % upper left location
            elseif strcmp(condition,'VU') % upper vector
                 M_VU = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 6,:)]; % upper location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 5,:)]; % lower location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 7,:)]; % left location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 8,:)]; % right location
            elseif strcmp(condition,'VL') % lower vector
                 M_VL = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 5,:)]; % lower location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 6,:)]; % upper location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 7,:)]; % left location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 8,:)]; % right location
            elseif strcmp(condition,'HR') % right vector
                 M_HR = M_raw;
                 M_radialout = [M_radialout; M_raw(M_raw(:,3) == 8,:)]; % right location
                 M_radialin = [M_radialin; M_raw(M_raw(:,3) == 7,:)]; % left location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 5,:)]; % lower location
                 M_tang = [M_tang; M_raw(M_raw(:,3) == 6,:)]; % upper location
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
    newfile = sprintf('%s/expRes%s_RadialBias_pilot1_%s.csv', savedir,subject, 'tang');
    csvwrite(newfile, M_tang)
end


%%
conditions = {'radial_out','radial_in','tang'};

for sub=1:length(subjects)
    for cond=1:length(conditions)
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
        
        filename = sprintf('Datasummary_%s_%s',subject, condition);
        save(filename, 'clockAnsData')
    end
    
end

%% polar plots (performance)

% radial out

m_radialout_0 = M_radialout(M_radialout(:,3) == 8,:); pc_radialout_0 = sum(m_radialout_0(:,14))/length(m_radialout_0(:,14));
m_radialout_45 = M_radialout(M_radialout(:,3) == 4,:); pc_radialout_45 = sum(m_radialout_45(:,14))/length(m_radialout_45(:,14));
m_radialout_90 = M_radialout(M_radialout(:,3) == 6,:); pc_radialout_90 = sum(m_radialout_90(:,14))/length(m_radialout_90(:,14));
m_radialout_135 = M_radialout(M_radialout(:,3) == 2,:); pc_radialout_135 = sum(m_radialout_135(:,14))/length(m_radialout_135(:,14));
m_radialout_180 = M_radialout(M_radialout(:,3) == 7,:); pc_radialout_180 = sum(m_radialout_180(:,14))/length(m_radialout_180(:,14));
m_radialout_225 = M_radialout(M_radialout(:,3) == 3,:); pc_radialout_225 = sum(m_radialout_225(:,14))/length(m_radialout_225(:,14));
m_radialout_270 = M_radialout(M_radialout(:,3) == 5,:); pc_radialout_270 = sum(m_radialout_270(:,14))/length(m_radialout_270(:,14));
m_radialout_315 = M_radialout(M_radialout(:,3) == 1,:); pc_radialout_315 = sum(m_radialout_315(:,14))/length(m_radialout_315(:,14));

% radial in

m_radialin_0 = M_radialin(M_radialin(:,3) == 8,:); pc_radialin_0 = sum(m_radialin_0(:,14))/length(m_radialin_0(:,14));
m_radialin_45 = M_radialin(M_radialin(:,3) == 4,:); pc_radialin_45 = sum(m_radialin_45(:,14))/length(m_radialin_45(:,14));
m_radialin_90 = M_radialin(M_radialin(:,3) == 6,:); pc_radialin_90 = sum(m_radialin_90(:,14))/length(m_radialin_90(:,14));
m_radialin_135 = M_radialin(M_radialin(:,3) == 2,:); pc_radialin_135 = sum(m_radialin_135(:,14))/length(m_radialin_135(:,14));
m_radialin_180 = M_radialin(M_radialin(:,3) == 7,:); pc_radialin_180 = sum(m_radialin_180(:,14))/length(m_radialin_180(:,14));
m_radialin_225 = M_radialin(M_radialin(:,3) == 3,:); pc_radialin_225 = sum(m_radialin_225(:,14))/length(m_radialin_225(:,14));
m_radialin_270 = M_radialin(M_radialin(:,3) == 5,:); pc_radialin_270 = sum(m_radialin_270(:,14))/length(m_radialin_270(:,14));
m_radialin_315 = M_radialin(M_radialin(:,3) == 1,:); pc_radialin_315 = sum(m_radialin_315(:,14))/length(m_radialin_315(:,14));

% tang

m_tang_0 = M_tang(M_tang(:,3) == 8,:); pc_tang_0 = sum(m_tang_0(:,14))/length(m_tang_0(:,14));
m_tang_45 = M_tang(M_tang(:,3) == 4,:); pc_tang_45 = sum(m_tang_45(:,14))/length(m_tang_45(:,14));
m_tang_90 = M_tang(M_tang(:,3) == 6,:); pc_tang_90 = sum(m_tang_90(:,14))/length(m_tang_90(:,14));
m_tang_135 = M_tang(M_tang(:,3) == 2,:); pc_tang_135 = sum(m_tang_135(:,14))/length(m_tang_135(:,14));
m_tang_180 = M_tang(M_tang(:,3) == 7,:); pc_tang_180 = sum(m_tang_180(:,14))/length(m_tang_180(:,14));
m_tang_225 = M_tang(M_tang(:,3) == 3,:); pc_tang_225 = sum(m_tang_225(:,14))/length(m_tang_225(:,14));
m_tang_270 = M_tang(M_tang(:,3) == 5,:); pc_tang_270 = sum(m_tang_270(:,14))/length(m_tang_270(:,14));
m_tang_315 = M_tang(M_tang(:,3) == 1,:); pc_tang_315 = sum(m_tang_315(:,14))/length(m_tang_315(:,14));


figure
Axis = gca; % current axes
theta = [deg2rad(0), deg2rad(45), deg2rad(90), deg2rad(135), deg2rad(180), deg2rad(225), deg2rad(270), deg2rad(315),deg2rad(0)]'; % angle in radians
rho_out = [pc_radialout_0,pc_radialout_45,pc_radialout_90,pc_radialout_135,pc_radialout_180,pc_radialout_225,pc_radialout_270,pc_radialout_315,pc_radialout_0]';
rho_out = rho_out-0.5;
p1 = polarplot(theta, rho_out, 'g');
hold on
rho_in = [pc_radialin_0,pc_radialin_45,pc_radialin_90,pc_radialin_135,pc_radialin_180,pc_radialin_225,pc_radialin_270,pc_radialin_315,pc_radialin_0]';
rho_in = rho_in-0.5;
p2 = polarplot(theta, rho_in, 'b');
hold on
rho_tang = [pc_tang_0,pc_tang_45,pc_tang_90,pc_tang_135,pc_tang_180,pc_tang_225,pc_tang_270,pc_tang_315,pc_tang_0]';
rho_tang = rho_tang-0.5;
p3 = polarplot(theta, rho_tang, 'r');

rlim([0 0.5])
rticks([0 0.1 0.2 0.3 0.4 0.5])
rticklabels({'50%','60%','70%','80%','90%','100%'});
thetaticks([0 45 90 135 180 225 270 315]);
hold on
polarscatter(theta, rho_out, 'g')
hold on
polarscatter(theta, rho_in, 'b')
hold on
polarscatter(theta, rho_tang, 'r')
title('Polar Plot Performance', 'FontSize', 14)
legend([p1,p2,p3],{'radialout','radialin','tang'})


%%

% performance across blocks

M_allcond = [];

M_allcond = [M_allcond; M_radialout];
M_allcond = [M_allcond; M_radialin];
M_allcond = [M_allcond; M_tang];

m_vector_0 = M_allcond(M_allcond(:,4) == 7,:); pc_vector_0 = sum(m_vector_0(:,14))/length(m_vector_0(:,14));
m_vector_45 = M_allcond(M_allcond(:,4) == 1,:); pc_vector_45 = sum(m_vector_45(:,14))/length(m_vector_45(:,14));
m_vector_90 = M_allcond(M_allcond(:,4) == 5,:); pc_vector_90 = sum(m_vector_90(:,14))/length(m_vector_90(:,14));
m_vector_135 = M_allcond(M_allcond(:,4) == 3,:); pc_vector_135 = sum(m_vector_135(:,14))/length(m_vector_135(:,14));
m_vector_180 = M_allcond(M_allcond(:,4) == 8,:); pc_vector_180 = sum(m_vector_180(:,14))/length(m_vector_180(:,14));
m_vector_225 = M_allcond(M_allcond(:,4) == 2,:); pc_vector_225 = sum(m_vector_225(:,14))/length(m_vector_225(:,14));
m_vector_270 = M_allcond(M_allcond(:,4) == 6,:); pc_vector_270 = sum(m_vector_270(:,14))/length(m_vector_270(:,14));
m_vector_315 = M_allcond(M_allcond(:,4) == 4,:); pc_vector_315 = sum(m_vector_315(:,14))/length(m_vector_315(:,14));

figure(2)
hold on
mydata = [pc_vector_135 pc_vector_0 pc_vector_315 pc_vector_270 ...
    pc_vector_45 pc_vector_180 pc_vector_270 pc_vector_90];

for i = 1:length(mydata)
    h=bar(i,mydata(i));
    if rem(i, 2) == 0
        set(h,'FaceColor','c');
    else
        set(h,'FaceColor','b');
    end
end
hold off
ylim([0.5 1])
xticks([1 2 3 4 5 6 7 8])
xticklabels({'UL','HR','LR','VL','UR','HL','LL','VU'})
legend('oblique directions','cardinal directions')
title('Percent Correct per block (collapsed 4 locations)', 'FontSize', 14)


%% cardinal motion

% vector HR location HR
m_vector_0_loc_0 = m_vector_0(m_vector_0(:,3) == 8,:); m_vector_0_pc_loc_0 = sum(m_vector_0_loc_0(:,14))/length(m_vector_0_loc_0(:,14));
% vector HR location HL
m_vector_0_loc_180 = m_vector_0(m_vector_0(:,3) == 7,:); m_vector_0_pc_loc_180 = sum(m_vector_0_loc_180(:,14))/length(m_vector_0_loc_180(:,14));
% vector HR location VU
m_vector_0_loc_90 = m_vector_0(m_vector_0(:,3) == 6,:); m_vector_0_pc_loc_90 = sum(m_vector_0_loc_90(:,14))/length(m_vector_0_loc_90(:,14));
% vector HR location VL
m_vector_0_loc_270 = m_vector_0(m_vector_0(:,3) == 5,:); m_vector_0_pc_loc_270 = sum(m_vector_0_loc_270(:,14))/length(m_vector_0_loc_270(:,14));

% vector HL location HR
m_vector_180_loc_0 = m_vector_180(m_vector_180(:,3) == 8,:); m_vector_180_pc_loc_0 = sum(m_vector_180_loc_0(:,14))/length(m_vector_180_loc_0(:,14));
% vector HL location HL
m_vector_180_loc_180 = m_vector_180(m_vector_180(:,3) == 7,:); m_vector_180_pc_loc_180 = sum(m_vector_180_loc_180(:,14))/length(m_vector_180_loc_180(:,14));
% vector HL location VU
m_vector_180_loc_90 = m_vector_180(m_vector_180(:,3) == 6,:); m_vector_180_pc_loc_90 = sum(m_vector_180_loc_90(:,14))/length(m_vector_180_loc_90(:,14));
% vector HL location VL
m_vector_180_loc_270 = m_vector_180(m_vector_180(:,3) == 5,:); m_vector_180_pc_loc_270 = sum(m_vector_180_loc_270(:,14))/length(m_vector_180_loc_270(:,14));

% vector VU location HR
m_vector_90_loc_0 = m_vector_90(m_vector_90(:,3) == 8,:); m_vector_90_pc_loc_0 = sum(m_vector_90_loc_0(:,14))/length(m_vector_90_loc_0(:,14));
% vector VU location HL
m_vector_90_loc_180 = m_vector_90(m_vector_90(:,3) == 7,:); m_vector_90_pc_loc_180 = sum(m_vector_90_loc_180(:,14))/length(m_vector_90_loc_180(:,14));
% vector VU location VU
m_vector_90_loc_90 = m_vector_90(m_vector_90(:,3) == 6,:); m_vector_90_pc_loc_90 = sum(m_vector_90_loc_90(:,14))/length(m_vector_90_loc_90(:,14));
% vector VU location VL
m_vector_90_loc_270 = m_vector_90(m_vector_90(:,3) == 5,:); m_vector_90_pc_loc_270 = sum(m_vector_90_loc_270(:,14))/length(m_vector_90_loc_270(:,14));

% vector VL location HR
m_vector_270_loc_0 = m_vector_270(m_vector_270(:,3) == 8,:); m_vector_270_pc_loc_0 = sum(m_vector_270_loc_0(:,14))/length(m_vector_270_loc_0(:,14));
% vector VL location HL
m_vector_270_loc_180 = m_vector_270(m_vector_270(:,3) == 7,:); m_vector_270_pc_loc_180 = sum(m_vector_270_loc_180(:,14))/length(m_vector_270_loc_180(:,14));
% vector VL location VU
m_vector_270_loc_90 = m_vector_270(m_vector_270(:,3) == 6,:); m_vector_270_pc_loc_90 = sum(m_vector_270_loc_90(:,14))/length(m_vector_270_loc_90(:,14));
% vector VL location VL
m_vector_270_loc_270 = m_vector_270(m_vector_270(:,3) == 5,:); m_vector_270_pc_loc_270 = sum(m_vector_270_loc_270(:,14))/length(m_vector_270_loc_270(:,14));


figure
Axis = gca; % current axes
theta = [deg2rad(0), deg2rad(90), deg2rad(180), deg2rad(270), deg2rad(0)]'; % angle in radians
rho_out = [m_vector_0_pc_loc_0 m_vector_0_pc_loc_90 m_vector_0_pc_loc_180 m_vector_0_pc_loc_270 m_vector_0_pc_loc_0]';
rho_out = rho_out-0.5;
p1 = polarplot(theta, rho_out, 'b');
hold on
rho_out = [m_vector_180_pc_loc_0 m_vector_180_pc_loc_90 m_vector_180_pc_loc_180 m_vector_180_pc_loc_270 m_vector_180_pc_loc_0]';
rho_out = rho_out-0.5;
p2 = polarplot(theta, rho_out, 'g');
hold on
rho_out = [m_vector_90_pc_loc_0 m_vector_90_pc_loc_90 m_vector_90_pc_loc_180 m_vector_90_pc_loc_270 m_vector_90_pc_loc_0]';
rho_out = rho_out-0.5;
p3 = polarplot(theta, rho_out, 'm--');
hold on
rho_out = [m_vector_270_pc_loc_0 m_vector_270_pc_loc_90 m_vector_270_pc_loc_180 m_vector_270_pc_loc_270 m_vector_270_pc_loc_0]';
rho_out = rho_out-0.5;
p4 = polarplot(theta, rho_out, 'r--');
legend(['Motion HR';'Motion HL'; 'Motion VU'; 'Motion VL'])
rlim([0 0.5])
rticks([0 0.1 0.2 0.3 0.4 0.5])
rticklabels({'50%','60%','70%','80%','90%','100%'});
title('Cardinal blocks')


%% oblique motion

% vector UR location UR
m_vector_45_loc_45 = m_vector_45(m_vector_45(:,3) == 4,:); m_vector_45_pc_loc_45 = sum(m_vector_45_loc_45(:,14))/length(m_vector_45_loc_45(:,14));
% vector UR location UL
m_vector_45_loc_135 = m_vector_45(m_vector_45(:,3) == 2,:); m_vector_45_pc_loc_135 = sum(m_vector_45_loc_135(:,14))/length(m_vector_45_loc_135(:,14));
% vector UR location LL
m_vector_45_loc_225 = m_vector_45(m_vector_45(:,3) == 3,:); m_vector_45_pc_loc_225 = sum(m_vector_45_loc_225(:,14))/length(m_vector_45_loc_225(:,14));
% vector UR location LR
m_vector_45_loc_315 = m_vector_45(m_vector_45(:,3) == 1,:); m_vector_45_pc_loc_315 = sum(m_vector_45_loc_315(:,14))/length(m_vector_45_loc_315(:,14));

% vector UR location UL
m_vector_135_loc_45 = m_vector_135(m_vector_135(:,3) == 4,:); m_vector_135_pc_loc_45 = sum(m_vector_135_loc_45(:,14))/length(m_vector_135_loc_45(:,14));
% vector UR location UL
m_vector_135_loc_135 = m_vector_135(m_vector_135(:,3) == 2,:); m_vector_135_pc_loc_135 = sum(m_vector_135_loc_135(:,14))/length(m_vector_135_loc_135(:,14));
% vector UR location LL
m_vector_135_loc_225 = m_vector_135(m_vector_135(:,3) == 3,:); m_vector_135_pc_loc_225 = sum(m_vector_135_loc_225(:,14))/length(m_vector_135_loc_225(:,14));
% vector UR location LR
m_vector_135_loc_315 = m_vector_135(m_vector_135(:,3) == 1,:); m_vector_135_pc_loc_315 = sum(m_vector_135_loc_315(:,14))/length(m_vector_135_loc_315(:,14));

% vector LL location UL
m_vector_225_loc_45 = m_vector_225(m_vector_225(:,3) == 4,:); m_vector_225_pc_loc_45 = sum(m_vector_225_loc_45(:,14))/length(m_vector_225_loc_45(:,14));
% vector LL location UL
m_vector_225_loc_135 = m_vector_225(m_vector_225(:,3) == 2,:); m_vector_225_pc_loc_135 = sum(m_vector_225_loc_135(:,14))/length(m_vector_225_loc_135(:,14));
% vector LL location LL
m_vector_225_loc_225 = m_vector_225(m_vector_225(:,3) == 3,:); m_vector_225_pc_loc_225 = sum(m_vector_225_loc_225(:,14))/length(m_vector_225_loc_225(:,14));
% vector LL location LR
m_vector_225_loc_315 = m_vector_225(m_vector_225(:,3) == 1,:); m_vector_225_pc_loc_315 = sum(m_vector_225_loc_315(:,14))/length(m_vector_225_loc_315(:,14));

% vector LR location UL
m_vector_315_loc_45 = m_vector_315(m_vector_315(:,3) == 4,:); m_vector_315_pc_loc_45 = sum(m_vector_315_loc_45(:,14))/length(m_vector_315_loc_45(:,14));
% vector LR location UL
m_vector_315_loc_135 = m_vector_315(m_vector_315(:,3) == 2,:); m_vector_315_pc_loc_135 = sum(m_vector_315_loc_135(:,14))/length(m_vector_315_loc_135(:,14));
% vector LR location LL
m_vector_315_loc_225 = m_vector_315(m_vector_315(:,3) == 3,:); m_vector_315_pc_loc_225 = sum(m_vector_315_loc_225(:,14))/length(m_vector_315_loc_225(:,14));
% vector LR location LR
m_vector_315_loc_315 = m_vector_315(m_vector_315(:,3) == 1,:); m_vector_315_pc_loc_315 = sum(m_vector_315_loc_315(:,14))/length(m_vector_315_loc_315(:,14));


figure
Axis = gca; % current axes
theta = [deg2rad(45), deg2rad(135), deg2rad(225), deg2rad(315), deg2rad(45)]'; % angle in radians
rho_out = [m_vector_45_pc_loc_45 m_vector_45_pc_loc_135 m_vector_45_pc_loc_225 m_vector_45_pc_loc_315 m_vector_45_pc_loc_45]';
rho_out = rho_out-0.5;
p1 = polarplot(theta, rho_out, 'b');
hold on
rho_out = [m_vector_135_pc_loc_45 m_vector_135_pc_loc_135 m_vector_135_pc_loc_225 m_vector_135_pc_loc_315 m_vector_135_pc_loc_45]';
rho_out = rho_out-0.5;
p2 = polarplot(theta, rho_out, 'g');
hold on
rho_out = [m_vector_225_pc_loc_45 m_vector_225_pc_loc_135 m_vector_225_pc_loc_225 m_vector_225_pc_loc_315 m_vector_225_pc_loc_45]';
rho_out = rho_out-0.5;
p3 = polarplot(theta, rho_out, 'm--');
hold on
rho_out = [m_vector_315_pc_loc_45 m_vector_315_pc_loc_135 m_vector_315_pc_loc_225 m_vector_315_pc_loc_315 m_vector_315_pc_loc_45]';
rho_out = rho_out-0.5;
p4 = polarplot(theta, rho_out, 'r--');
hold on
legend(['Motion UL';'Motion UR';'Motion LL';'Motion LR'])
rlim([0 0.5])
rticks([0 0.1 0.2 0.3 0.4 0.5])
rticklabels({'50%','60%','70%','80%','90%','100%'});
title('InterCardinal blocks')
