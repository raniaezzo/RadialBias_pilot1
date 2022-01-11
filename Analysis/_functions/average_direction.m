function [mean_acrossloc, locvalues, ci_acrossloc] = average_direction(main_conditions, boot, organization, b_iter)

CIFcn = @(x,p)prctile(x, [100-p, p]);

main_conditions_array = cell2mat(main_conditions);
C = fieldnames(main_conditions_array);
SZ = struct(); % scalar structure
for k = 1:numel(C)
    F = C{k};
    SZ.(F) = mean(cat(4,main_conditions_array.(F)),4);
end

% taking the mean of lower/upper locations of the mean direction params
upperpoints = [SZ.loc_45; SZ.loc_90; SZ.loc_135];
uppermean = mean(upperpoints); % upper VF
lowerpoints = [SZ.loc_225; SZ.loc_270; SZ.loc_315];
lowermean = mean(lowerpoints); % lower VF

locvalues = {lowerpoints', upperpoints'};

% alternative: I could take the mean of the raw vectors? [same answer b/c sample size is same]
%upper = [main_conditions_array.loc_45, main_conditions_array.loc_90, main_conditions_array.loc_135];
%uppermean = mean(reshape(upper', [4,24])');

%lower = [main_conditions_array.loc_225, main_conditions_array.loc_270, main_conditions_array.loc_315];
%lowermean = mean(reshape(lower', [4,24])');

mean_acrossloc = [lowermean; uppermean];

boot_conditions_array = cell2mat(boot);
upperboot = [boot_conditions_array.loc_45, boot_conditions_array.loc_90, boot_conditions_array.loc_135];
upperbootmean = mean(reshape(upperboot,b_iter,4,[]),3);

lowerboot = [boot_conditions_array.loc_225, boot_conditions_array.loc_270, boot_conditions_array.loc_315];
lowerbootmean = mean(reshape(lowerboot,b_iter,4,[]),3);

set_boots = {lowerbootmean, upperbootmean};

% % added just to compute confidence intervals (maybe just use std instead)
ci_acrossloc = cell(length(set_boots), 1);
for ci=1:length(set_boots)
    % compute ci
    boot_ci = nan(2,2,2);
    for param=1:length(boot_ci)
        x = set_boots{ci}(:,param);
        p = 95; CI_95 = CIFcn(x,p);  
        p = 68; CI_68 = CIFcn(x,p);
        % added this because CIs sometimes were not around true mean
        meanboot = mean(set_boots{ci}); 
        Lower_95 = meanboot(param) - CI_95(1);
        Upper_95 = CI_95(2) - meanboot(param);
        Lower_68 = meanboot(param) - CI_68(1);
        Upper_68 = CI_68(2) - meanboot(param);
        boot_ci(:,param,1) = [Lower_95;Upper_95]; % lower - upper
        boot_ci(:,param,2) = [Lower_68;Upper_68]; % lower - upper
    end
    
    ci_acrossloc{ci,:} = boot_ci;
    
end

end



