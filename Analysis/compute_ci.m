function compute_ci(type_summarypath, analysis_flag)

load(fullfile(type_summarypath,strcat(analysis_flag, '.mat')))

% this assumes normality:
%CIFcn = @(x,p)std(x(:),'omitnan')/sqrt(sum(~isnan(x(:)))) ...
%    * tinv(abs([0,1]-(1-p/100)/2),sum(~isnan(x(:)))-1); % ...
%    %+ mean(x(:),'omitnan'); % will add to sample mean later
    
CIFcn = @(x,p)prctile(x, [100-p, p]);

% compute ci for alpha and beta
% is there a way to condense this while retaining structname?

for fn = fieldnames(bootparams_radialout)'
    bootci_radialout.(fn{:}) = [];
    disp(fn{1})
    param_cis = nan(2,2,2); %nan(2);
    for param=1:length(param_cis)
        x = bootparams_radialout.(fn{1})(:,param);
        p = 95; CI_95 = CIFcn(x,p);  
        p = 68; CI_68 = CIFcn(x,p);
        param_cis(:,param,1) = [CI_95(1);CI_95(2)];
        param_cis(:,param,2) = [CI_68(1);CI_68(2)];
    end
    bootci_radialout.(fn{1}) = param_cis;
end

for fn = fieldnames(bootparams_radialin)'
    bootci_radialin.(fn{:}) = [];
    disp(fn{1})
    param_cis = nan(2,2,2);
    for param=1:length(param_cis)
        x = bootparams_radialin.(fn{1})(:,param);
        p = 95; CI_95 = CIFcn(x,p);  
        p = 68; CI_68 = CIFcn(x,p);
        param_cis(:,param,1) = [CI_95(1);CI_95(2)];
        param_cis(:,param,2) = [CI_68(1);CI_68(2)];
    end
    bootci_radialin.(fn{1}) = param_cis;
end

for fn = fieldnames(bootparams_tangleft)'
    bootci_tangleft.(fn{:}) = [];
    disp(fn{1})
    param_cis = nan(2,2,2);
    for param=1:length(param_cis)
        x = bootparams_tangleft.(fn{1})(:,param);
        p = 95; CI_95 = CIFcn(x,p);  
        p = 68; CI_68 = CIFcn(x,p);
        param_cis(:,param,1) = [CI_95(1);CI_95(2)];
        param_cis(:,param,2) = [CI_68(1);CI_68(2)];
    end
    bootci_tangleft.(fn{1}) = param_cis;
end

for fn = fieldnames(bootparams_tangright)'
    bootci_tangright.(fn{:}) = [];
    disp(fn{1})
    param_cis = nan(2,2,2);
    for param=1:length(param_cis)
        x = bootparams_tangright.(fn{1})(:,param);
        p = 95; CI_95 = CIFcn(x,p);  
        p = 68; CI_68 = CIFcn(x,p);
        param_cis(:,param,1) = [CI_95(1);CI_95(2)];
        param_cis(:,param,2) = [CI_68(1);CI_68(2)];
    end
    bootci_tangright.(fn{1}) = param_cis;
end

for fn = fieldnames(bootparams_radial)'
    bootci_radial.(fn{:}) = [];
    disp(fn{1})
    param_cis = nan(2,2,2);
    for param=1:length(param_cis) % bias, sensitivity
        x = bootparams_radial.(fn{1})(:,param);
        p = 95; CI_95 = CIFcn(x,p);  
        p = 68; CI_68 = CIFcn(x,p);
        param_cis(:,param,1) = [CI_95(1);CI_95(2)];
        param_cis(:,param,2) = [CI_68(1);CI_68(2)];
    end
    bootci_radial.(fn{1}) = param_cis;
end

for fn = fieldnames(bootparams_tang)'
    bootci_tang.(fn{:}) = [];
    disp(fn{1})
    param_cis = nan(2,2,2);
    for param=1:length(param_cis)
        x = bootparams_tang.(fn{1})(:,param);
        p = 95; CI_95 = CIFcn(x,p);  
        p = 68; CI_68 = CIFcn(x,p);
        param_cis(:,param,1) = [CI_95(1);CI_95(2)];
        param_cis(:,param,2) = [CI_68(1);CI_68(2)];
    end
    bootci_tang.(fn{1}) = param_cis;
end


save(fullfile(type_summarypath,'bootci'), 'bootci_radialout', ...
    'bootci_radialin', 'bootci_tangleft','bootci_tangright',...
    'bootci_radial','bootci_tang')

end