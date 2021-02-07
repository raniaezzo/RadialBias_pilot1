clc
clear all;

% To DO:
% fix code so that PFs are in loop

% create PF figure

sets = {'SetA'}; %{'Set1','Set2','Sets_Combined'};
subject = 'SK';
figure


for ss=1:length(sets)
    
    setname = sets{ss};

    % first run
    storedStructure = load(sprintf('./%s/Datasummary_%s_radial_out.mat',setname, subject));
    radial_out = storedStructure.radial_out;
    clear('storedStructure');
    storedStructure = load(sprintf('./%s/Datasummary_%s_radial_in.mat',setname, subject));
    radial_in = storedStructure.radial_in;
    clear('storedStructure');
    storedStructure = load(sprintf('./%s/Datasummary_%s_tang.mat',setname, subject));
    tang = storedStructure.tang;
    clear('storedStructure');


    % for radial out

    Index_addedTilt = find(strcmp([radial_out.rownames], 'AddedTilt'));
    total_conditions = radial_out.radial_out(Index_addedTilt,:);
    Index_numTrials = find(strcmp([radial_out.rownames], 'NumTrials'));
    numTrials = radial_out.radial_out(Index_numTrials,:);
    Index_clockResp = find(strcmp([radial_out.rownames], 'AnsClockwise'));
    clockResp = radial_out.radial_out(Index_clockResp,:);

    numLevels = length(total_conditions);
    PF = @PAL_CumulativeNormal; %@PAL_Logistic; %
    bool_paramsFree = [1 1 0 0];
    searchGrid.alpha = [min(total_conditions):0.01:max(total_conditions)];
    searchGrid.beta = [0.5:0.01:15]; %maybe need to change?
    searchGrid.gamma = 0;
    searchGrid.lambda = 0;

    NumPos = clockResp;
    OutOfNum = numTrials;
    PC1 = clockResp./numTrials;

    [paramsValues LL exitflag] = PAL_PFML_Fit(total_conditions,NumPos, ...
    OutOfNum,searchGrid,bool_paramsFree, PF);
    disp(paramsValues)

    % plot PF 
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96])
    sz = 100;
    %PropCorrectData = NumPos./OutOfNum;
    StimLevelsFine = [min(total_conditions):max((total_conditions) - min(total_conditions))./1000:max(total_conditions)];
    Fit = PF(paramsValues, StimLevelsFine);
    if ss == 1
        plot(StimLevelsFine, Fit, 'g-','linewidth', 2)
    else
        plot(StimLevelsFine, Fit, 'g--','linewidth', 2)
    end
    xlabel('added tilt (deg)')
    ylabel('clockwise response')
    hold on

    % for radial in

    Index_addedTilt = find(strcmp([radial_in.rownames], 'AddedTilt'));
    total_conditions = radial_in.radial_in(Index_addedTilt,:);
    Index_numTrials = find(strcmp([radial_in.rownames], 'NumTrials'));
    numTrials = radial_in.radial_in(Index_numTrials,:);
    Index_clockResp = find(strcmp([radial_in.rownames], 'AnsClockwise'));
    clockResp = radial_in.radial_in(Index_clockResp,:);

    numLevels = length(total_conditions);
    PF = @PAL_CumulativeNormal; %@PAL_Logistic; %
    bool_paramsFree = [1 1 0 0];
    searchGrid.alpha = [min(total_conditions):0.01:max(total_conditions)];
    searchGrid.beta = [0.5:0.01:15]; %maybe need to change?
    searchGrid.gamma = 0;
    searchGrid.lambda = 0;

    NumPos = clockResp;
    OutOfNum = numTrials;
    PC2 = clockResp./numTrials;

    [paramsValues LL exitflag] = PAL_PFML_Fit(total_conditions,NumPos, ...
    OutOfNum,searchGrid,bool_paramsFree, PF);
    disp(paramsValues)

    % plot PF 
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96])
    sz = 100;
    %PropCorrectData = NumPos./OutOfNum;
    StimLevelsFine = [min(total_conditions):max((total_conditions) - min(total_conditions))./1000:max(total_conditions)];
    Fit = PF(paramsValues, StimLevelsFine);
    if ss == 1
        plot(StimLevelsFine, Fit, 'b-','linewidth', 2)
    else
        plot(StimLevelsFine, Fit, 'b--','linewidth', 2)
    end
    xlabel('added tilt (deg)')
    ylabel('clockwise response')
    hold on

    % tang

    Index_addedTilt = find(strcmp([tang.rownames], 'AddedTilt'));
    total_conditions = tang.tang(Index_addedTilt,:);
    Index_numTrials = find(strcmp([tang.rownames], 'NumTrials'));
    numTrials = tang.tang(Index_numTrials,:);
    Index_clockResp = find(strcmp([tang.rownames], 'AnsClockwise'));
    clockResp = tang.tang(Index_clockResp,:);

    numLevels = length(total_conditions);
    PF = @PAL_CumulativeNormal; %@PAL_Logistic; %
    bool_paramsFree = [1 1 0 0];
    searchGrid.alpha = [min(total_conditions):0.01:max(total_conditions)];
    searchGrid.beta = [0.5:0.01:15]; %maybe need to change?
    searchGrid.gamma = 0;
    searchGrid.lambda = 0;

    NumPos = clockResp;
    OutOfNum = numTrials;
    PC3 = clockResp./numTrials;

    [paramsValues LL exitflag] = PAL_PFML_Fit(total_conditions,NumPos, ...
    OutOfNum,searchGrid,bool_paramsFree, PF);
    disp(paramsValues)

    % plot PF 
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96])
    sz = 100;
    StimLevelsFine = [min(total_conditions):max((total_conditions) - min(total_conditions))./1000:max(total_conditions)];
    Fit = PF(paramsValues, StimLevelsFine);
    if ss == 1
        plot(StimLevelsFine, Fit, 'r-','linewidth', 2)
    else
        plot(StimLevelsFine, Fit, 'r--','linewidth', 2)
    end
    xlabel('added tilt (deg)')
    ylabel('clockwise response')
    hold on

    scatter(total_conditions, PC1, sz, 'MarkerEdgeColor',[0 1, 0], 'MarkerFaceColor',[0 1 0])
    hold on
    scatter(total_conditions, PC2, sz, 'MarkerEdgeColor',[0 0 1], 'MarkerFaceColor',[0 0 1])
    hold on
    scatter(total_conditions, PC3, sz, 'MarkerEdgeColor',[1 0 0], 'MarkerFaceColor',[1 0 0])
    hold on
    alpha(.3)
    legend('outward','inward','tang', 'Location','Northwest')
    title('Cumulative Normal Fit')
    ax = gca; 
    ax.FontSize = 40;
    stringsave = sprintf('PF_%s',subject);
    savefig(stringsave)
end