function average_conditions(relative_summarypath)

    % because I am using radialin, radialout, tangleft, tangright
    % I can use 6fits or 4 fits (same data)
    load(sprintf('%s/analyzeddata_6fits_abs.mat',relative_summarypath))

    allconds = {params_radialin,params_radialout,params_tangright,params_tangleft};
    bootallconds = {bootparams_radialin,bootparams_radialout,bootparams_tangright,bootparams_tangleft};
    
    % take average of all conditions per location (make matrix)
    for fn = fieldnames(allconds{1})' % just pick the first (workaround)
        params_origcond.(fn{1}) = (params_radialin.(fn{1}) + params_radialout.(fn{1}) + ...
            params_tangright.(fn{1}) + params_tangleft.(fn{1}))/4;
    end
    
    for fn = fieldnames(bootallconds{1})' % just pick the first (workaround)
        bootparams_origcond.(fn{1}) = (bootparams_radialin.(fn{1}) + bootparams_radialout.(fn{1}) + ...
            bootparams_tangright.(fn{1}) + bootparams_tangleft.(fn{1}))/4;
    end    
    
    save(fullfile(relative_summarypath,'analyzeddata_allcond_6fits_abs'), 'params_origcond', ...
    'bootparams_origcond');
    
    % compute CI
    CIFcn = @(x,p)prctile(x, [100-p, p]);
    
    for fn = fieldnames(bootparams_origcond)'
        bootci_origcond.(fn{:}) = [];
        disp(fn{1})
        param_cis = nan(2,2,2);
        for param=1:length(param_cis)
            x = bootparams_origcond.(fn{1})(:,param);
            p = 95; CI_95 = CIFcn(x,p);  
            p = 68; CI_68 = CIFcn(x,p);
            param_cis(:,param,1) = [CI_95(1);CI_95(2)];
            param_cis(:,param,2) = [CI_68(1);CI_68(2)];
        end
        bootci_origcond.(fn{1}) = param_cis;
    end
    
    save(fullfile(relative_summarypath,'bootci_allcond'), 'bootci_origcond');


end