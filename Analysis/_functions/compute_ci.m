function compute_ci(cond_dirs)

    for ci=1:length(cond_dirs)
    
        load(fullfile(cond_dirs{ci},'abs_params_boot.mat'))

        % this assumes normality (do not use):
        %CIFcn = @(x,p)std(x(:),'omitnan')/sqrt(sum(~isnan(x(:)))) ...
        %    * tinv(abs([0,1]-(1-p/100)/2),sum(~isnan(x(:)))-1); % ...
        %    %+ mean(x(:),'omitnan'); % will add to sample mean later

        CIFcn = @(x,p)prctile(x, [100-p, p]);

        % new
        boot_ci = nan(2,2,2); %nan(2);
        for param=1:length(boot_ci)
            x = bootParamValues(:,param);
            p = 95; CI_95 = CIFcn(x,p);  
            p = 68; CI_68 = CIFcn(x,p);
            boot_ci(:,param,1) = [CI_95(1);CI_95(2)];
            boot_ci(:,param,2) = [CI_68(1);CI_68(2)];
        end

        save(fullfile(cond_dirs{ci},'abs_bootci'), 'boot_ci')
    end
end