function average_conditions_switch(relative_summarypath)

    % because I am using radialin, radialout, tangleft, tangright
    % I can use 6fits or 4 fits (same data)
    load(sprintf('%s/analyzeddata_6fits_abs.mat',relative_summarypath))

    allconds = {params_inclock,params_outclock,params_incclock,params_outcclock};
    bootallconds = {bootparams_inclock,bootparams_outclock,bootparams_incclock,bootparams_outcclock};
    
    % take average of all conditions per location (make matrix)
    for fn = fieldnames(allconds{1})' % just pick the first (workaround)
        params_switchcond.(fn{1}) = (params_inclock.(fn{1}) + params_outclock.(fn{1}) + ...
            params_incclock.(fn{1}) + params_outcclock.(fn{1}))/4;
    end
    
    for fn = fieldnames(bootallconds{1})' % just pick the first (workaround)
        bootparams_switchcond.(fn{1}) = (bootparams_inclock.(fn{1}) + bootparams_outclock.(fn{1}) + ...
            bootparams_incclock.(fn{1}) + bootparams_outcclock.(fn{1}))/4;
    end    
    
    save(fullfile(relative_summarypath,'analyzeddata_allcond_6fits_abs'), 'params_switchcond', ...
    'bootparams_switchcond');
    
    % compute CI
    CIFcn = @(x,p)prctile(x, [100-p, p]);
    
    for fn = fieldnames(bootparams_switchcond)'
        bootci_switchcond.(fn{:}) = [];
        disp(fn{1})
        param_cis = nan(2,2,2);
        for param=1:length(param_cis)
            x = bootparams_switchcond.(fn{1})(:,param);
            p = 95; CI_95 = CIFcn(x,p);  
            p = 68; CI_68 = CIFcn(x,p);
            param_cis(:,param,1) = [CI_95(1);CI_95(2)];
            param_cis(:,param,2) = [CI_68(1);CI_68(2)];
        end
        bootci_switchcond.(fn{1}) = param_cis;
    end
    
    save(fullfile(relative_summarypath,'bootci_allcond'), 'bootci_switchcond');


end