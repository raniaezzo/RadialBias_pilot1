clc
clear all;

% To DO:
% fix code so that PFs are in loop

% create PF figure
rng('default')

sets = {'SF_3'};
%{'Final_ecc7_speed8_cardobl'}; %{'Sets_Combined'}; %{'SetA'}; %{'Set1','Set2','Sets_Combined'};
subject = 'RE'; %'RE','SK'
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
    
    % for CI
    data_radialout.x = total_conditions; data_radialout.y = clockResp; data_radialout.n = numTrials;
    pfhb = PAL_PFHB_fitModel(data_radialout,'PF','cumulativenormal','g',repmat(.01,1,length(data_radialout.y)),'parallel',1);
    %undo natural log of slope:
    radialout_beta_mean = exp(pfhb.summStats.b.mean);
    radialout_CI68_beta_low = exp(pfhb.summStats.b.HDI68low);
    radialout_CI68_beta_high = exp(pfhb.summStats.b.HDI68high);
    radialout_CI95_beta_low = exp(pfhb.summStats.b.HDI95low);
    radialout_CI95_beta_high = exp(pfhb.summStats.b.HDI95high);
    radialout_alpha_mean = pfhb.summStats.a.mean;
    radialout_CI68_alpha_low = pfhb.summStats.a.HDI68low;
    radialout_CI68_alpha_high = pfhb.summStats.a.HDI68high;
    radialout_CI95_alpha_low = pfhb.summStats.a.HDI95low;
    radialout_CI95_alpha_high = pfhb.summStats.a.HDI95high;

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
    searchGrid.beta = [0.03:0.01:20]; %maybe need to change?
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
    
    % for CI
    data_radialin.x = total_conditions; data_radialin.y = clockResp; data_radialin.n = numTrials;
    pfhb = PAL_PFHB_fitModel(data_radialin,'PF','cumulativenormal','g',repmat(.01,1,length(data_radialin.y)),'parallel',1);
    %undo natural log of slope:
    radialin_beta_mean = exp(pfhb.summStats.b.mean);
    radialin_CI68_beta_low = exp(pfhb.summStats.b.HDI68low);
    radialin_CI68_beta_high = exp(pfhb.summStats.b.HDI68high);
    radialin_CI95_beta_low = exp(pfhb.summStats.b.HDI95low);
    radialin_CI95_beta_high = exp(pfhb.summStats.b.HDI95high);
    radialin_alpha_mean = pfhb.summStats.a.mean;
    radialin_CI68_alpha_low = pfhb.summStats.a.HDI68low;
    radialin_CI68_alpha_high = pfhb.summStats.a.HDI68high;
    radialin_CI95_alpha_low = pfhb.summStats.a.HDI95low;
    radialin_CI95_alpha_high = pfhb.summStats.a.HDI95high;

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
    
    % for CI
    data_tang.x = total_conditions; data_tang.y = clockResp; data_tang.n = numTrials;
    pfhb = PAL_PFHB_fitModel(data_tang,'PF','cumulativenormal','g',repmat(.01,1,length(data_tang.y)),'parallel',1);
    %undo natural log of slope:
    tang_beta_mean = exp(pfhb.summStats.b.mean);
    tang_CI68_beta_low = exp(pfhb.summStats.b.HDI68low);
    tang_CI68_beta_high = exp(pfhb.summStats.b.HDI68high);
    tang_CI95_beta_low = exp(pfhb.summStats.b.HDI95low);
    tang_CI95_beta_high = exp(pfhb.summStats.b.HDI95high);
    tang_alpha_mean = pfhb.summStats.a.mean;
    tang_CI68_alpha_low = pfhb.summStats.a.HDI68low;
    tang_CI68_alpha_high = pfhb.summStats.a.HDI68high;
    tang_CI95_alpha_low = pfhb.summStats.a.HDI95low;
    tang_CI95_alpha_high = pfhb.summStats.a.HDI95high;

    scatter(total_conditions, PC1, sz, 'MarkerEdgeColor',[0 1, 0], 'MarkerFaceColor',[0 1 0])
    hold on
    scatter(total_conditions, PC2, sz, 'MarkerEdgeColor',[0 0 1], 'MarkerFaceColor',[0 0 1])
    hold on
    scatter(total_conditions, PC3, sz, 'MarkerEdgeColor',[1 0 0], 'MarkerFaceColor',[1 0 0])
    hold on
    alpha(.3)
    legend('outward','inward','tang', 'Location','Northwest')
    title('Cumulative Normal Fit (SF-3, LR Loc)')
    ax = gca; 
    ax.FontSize = 40;
    stringsave = sprintf('PF_%s',subject);
    savefig(stringsave)
end

%%
figure
n_sets = [1,2,3];
n_means = [radialout_beta_mean, radialin_beta_mean, tang_beta_mean];
n_lows = [radialout_CI95_beta_low, radialin_CI95_beta_low, tang_CI95_beta_low];
n_lows = n_means - n_lows;
n_highs = [radialout_CI95_beta_high, radialin_CI95_beta_high, tang_CI95_beta_high];
n_highs = n_highs-n_means;
bar(n_sets,n_means)                
hold on
er = errorbar(n_sets, n_means,n_lows,n_highs, 'k', 'LineStyle','none', 'linewidth', 2);
hold on
n_lows = [radialout_CI68_beta_low, radialin_CI68_beta_low, tang_CI68_beta_low];
n_lows = n_means - n_lows;
n_highs = [radialout_CI68_beta_high, radialin_CI68_beta_high, tang_CI68_beta_high];
n_highs = n_highs-n_means;
er = errorbar(n_sets, n_means,n_lows,n_highs, 'r', 'LineStyle','none', 'linewidth', 2);
set(gca,'xticklabel',{'radialout','radialin','tang'})
ylabel('mean beta')
title('RE Mean Slope w/ CI (SF-3, LR Loc)')
%ylim([0.5 1])
ax = gca; 
ax.FontSize = 20;
stringsave = sprintf('MeanSlopeError_ci_%s',subject);
savefig(stringsave)

%%

figure
n_sets = [1,2,3];
n_means = [radialout_alpha_mean, radialin_alpha_mean, tang_alpha_mean];
n_lows = [radialout_CI95_alpha_low, radialin_CI95_alpha_low, tang_CI95_alpha_low];
n_lows = n_means - n_lows;
n_highs = [radialout_CI95_alpha_high, radialin_CI95_alpha_high, tang_CI95_alpha_high];
n_highs = n_highs-n_means;
bar(n_sets,n_means)                
hold on
er = errorbar(n_sets, n_means,n_lows,n_highs, 'k', 'LineStyle','none', 'linewidth', 2);
hold on
n_lows = [radialout_CI68_alpha_low, radialin_CI68_alpha_low, tang_CI68_alpha_low];
n_lows = n_means - n_lows;
n_highs = [radialout_CI68_alpha_high, radialin_CI68_alpha_high, tang_CI68_alpha_high];
n_highs = n_highs-n_means;
er = errorbar(n_sets, n_means,n_lows,n_highs, 'r', 'LineStyle','none', 'linewidth', 2);
set(gca,'xticklabel',{'radialout','radialin','tang'})
ylabel('mean alpha')
ylim([-2,2])
title('RE Mean Bias w/ CI (SF-3, LR Loc)')
ax = gca; 
ax.FontSize = 20;
stringsave = sprintf('MeanBiasError_ci_%s',subject);
savefig(stringsave)

%%


%%
% data_tang.x = total_conditions; data_tang.y = clockResp; data_tang.n = numTrials;
% figure
%  [paramsValues LL exitflag] = PAL_PFML_Fit(total_conditions,NumPos, ...
%     OutOfNum,searchGrid,bool_paramsFree, PF);
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96])
% sz = 100;
% StimLevelsFine = [min(total_conditions):max((total_conditions) - min(total_conditions))./1000:max(total_conditions)];
% Fit = PF(paramsValues, StimLevelsFine);
% %rng('twister');
% pfhb = PAL_PFHB_fitModel(data_tang,'PF','cumulativenormal','g',repmat(.01,1,length(data_tang.y)),'parallel',1);
% %undo natural log of slope:
% data_tang.x = total_conditions; data_tang.y = clockResp; data_tang.n = numTrials;
% tang_mean = exp(pfhb.summStats.b.mean);
% tang_CI_low = exp(pfhb.summStats.b.HDI95low);
% tang_CI_high = exp(pfhb.summStats.b.HDI95high);
% if ss == 1
%     plot(StimLevelsFine, Fit, 'r-','linewidth', 2)
% else
%     plot(StimLevelsFine, Fit, 'r--','linewidth', 2)
% end
% xlabel('added tilt (deg)')
% ylabel('clockwise response')

