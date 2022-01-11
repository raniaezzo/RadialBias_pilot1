function [mean_acrossloc, locvalues, ci_acrossloc] = average_condition(main_conditions, boot, organization)

CIFcn = @(x,p)prctile(x, [100-p, p]);
mean_acrossloc = nan(length(main_conditions), 4);
locvalues = cell(length(main_conditions), 1);

for ci=1:length(main_conditions)
    temp = struct2cell(main_conditions{1,ci});
    Y = cat(3,temp{:});
    mean_acrossloc(ci,:) = mean(Y,3);
    locvalues{ci,:} = squeeze(Y);
end

% added just to compute confidence intervals (maybe just use std instead)
ci_acrossloc = cell(length(boot), 1);
for ci=1:length(boot)
    temp = struct2cell(boot{1,ci});
    Y = cat(3,temp{:});
    boot_acrossloc = mean(Y,3);

    % compute ci
    boot_ci = nan(2,2,2);
    for param=1:length(boot_ci)
        x = boot_acrossloc(:,param);
        p = 95; CI_95 = CIFcn(x,p);  
        p = 68; CI_68 = CIFcn(x,p);
        % added this because CIs sometimes were not around true mean
        meanboot = mean(boot_acrossloc); 
        Lower_95 = meanboot(param) - CI_95(1);
        Upper_95 = CI_95(2) - meanboot(param);
        Lower_68 = meanboot(param) - CI_68(1);
        Upper_68 = CI_68(2) - meanboot(param);
        boot_ci(:,param,1) = [Lower_95;Upper_95]; % lower - upper
        boot_ci(:,param,2) = [Lower_68;Upper_68]; % lower - upper
    end
    
    ci_acrossloc{ci,:} = boot_ci;
    
end