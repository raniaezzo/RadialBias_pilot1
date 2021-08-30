function average_locations(relative_summarypath)

    % because I am using radialin, radialout, tangleft, tangright
    % I can use 6fits or 4 fits (same data)
    load(sprintf('%s/analyzeddata_6fits_abs.mat',relative_summarypath))

    radialconds = {params_radialin,params_radialout};
    tangconds = {params_tangright,params_tangleft};
    bootradialconds = {bootparams_radialin,bootparams_radialout};
    boottangconds = {bootparams_tangright,bootparams_tangleft};
    
    % take average of all locations of radialin & radialout (make matrix)
    radial_init = [];
    for i=1:length(radialconds)
            for fn = fieldnames(radialconds{i})'
                radial_init = [radial_init; radialconds{i}.(fn{1})];
            end
    end

    params_radial = [];
    params_radial.all_loc = mean(radial_init);
    
    % combine boot for all locations of radialin & radialout (make matrix)
    bootradial_init = [];
    for i=1:length(bootradialconds)
            for fn = fieldnames(bootradialconds{i})'
                bootradial_init = [bootradial_init; bootradialconds{i}.(fn{1})];
            end
    end

    bootparams_radial = [];
    bootparams_radial.all_loc = bootradial_init;
    
    % take average of all locations of tangright & tangleft (make matrix)

    tang_init = [];
    for i=1:length(tangconds)
            for fn = fieldnames(tangconds{i})'
                tang_init = [tang_init; tangconds{i}.(fn{1})];
            end
    end

    params_tang = [];
    params_tang.all_loc = mean(tang_init);
    
    % combine boot for all locations of radialin & radialout (make matrix)
    boottang_init = [];
    for i=1:length(boottangconds)
            for fn = fieldnames(boottangconds{i})'
                boottang_init = [boottang_init; boottangconds{i}.(fn{1})];
            end
    end

    bootparams_tang = [];
    bootparams_tang.all_loc = boottang_init;
    
    save(fullfile(relative_summarypath,'analyzeddata_all_loc_6fits_abs'), 'params_radial', ...
    'params_tang', 'bootparams_radial', 'bootparams_tang');
    
    % compute CI
    CIFcn = @(x,p)prctile(x, [100-p, p]);
    
    for fn = fieldnames(bootparams_radial)'
        bootci_radial.(fn{:}) = [];
        disp(fn{1})
        param_cis = nan(2,2,2);
        for param=1:length(param_cis)
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
    
    save(fullfile(relative_summarypath,'bootci_all_loc'), 'bootci_radial', ...
    'bootci_tang');

end