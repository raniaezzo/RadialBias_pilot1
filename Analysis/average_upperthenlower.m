function average_upperthenlower(relative_summarypath)

    % because I am using radialin, radialout, tangleft, tangright
    % I can use 6fits or 4 fits (same data)
    load(sprintf('%s/analyzeddata_4fits_absmean.mat',relative_summarypath))

    paramconds = {params_radialin, params_radialout, params_tangleft, params_tangright};
    bootconds = {bootparams_radialin, bootparams_radialin, bootparams_tangleft, ...
        bootparams_tangright};
    
    % take average of all lower locations
    lower_init = [];
    for i=1:length(paramconds)
            for fn = fieldnames(paramconds{i})'
                if strcmp(fn, 'loc_315') || strcmp(fn, 'loc_270') || strcmp(fn, 'loc_225')
                    lower_init = [lower_init; paramconds{i}.(fn{1})];
                end
            end
    end

    params_lower = [];
    params_lower.all_loc = mean(lower_init);
    
    % combine boot of all lower locations
    bootlower_init = [];
    for i=1:length(bootconds)
            for fn = fieldnames(bootconds{i})'
                if strcmp(fn, 'loc_315') || strcmp(fn, 'loc_270') || strcmp(fn, 'loc_225')
                    bootlower_init = [bootlower_init; bootconds{i}.(fn{1})];
                end
            end
    end

    bootparams_lower = [];
    bootparams_lower.all_loc = mean(bootlower_init);
    
    % take average of all upper locations
    upper_init = [];
    for i=1:length(paramconds)
            for fn = fieldnames(paramconds{i})'
                if strcmp(fn, 'loc_45') || strcmp(fn, 'loc_90') || strcmp(fn, 'loc_135')
                    upper_init = [upper_init; paramconds{i}.(fn{1})];
                end
            end
    end

    params_upper = [];
    params_upper.all_loc = mean(upper_init);
    
    % combine boot of all lower locations
    bootupper_init = [];
    for i=1:length(bootconds)
            for fn = fieldnames(bootconds{i})'
                if strcmp(fn, 'loc_45') || strcmp(fn, 'loc_90') || strcmp(fn, 'loc_135')
                    bootupper_init = [bootupper_init; bootconds{i}.(fn{1})];
                end
            end
    end

    bootparams_upper = [];
    bootparams_upper.all_loc = mean(bootupper_init);
    
    save(fullfile(relative_summarypath,'analyzeddata_upperlower_6fits_abs'), 'params_upper', ...
    'params_lower', 'bootparams_upper', 'bootparams_lower');
    
%     % NEED TO FIX
%     % compute CI
%     CIFcn = @(x,p)prctile(x, [100-p, p]);
%     
%     for fn = fieldnames(bootparams_radial)'
%         bootci_radial.(fn{:}) = [];
%         disp(fn{1})
%         param_cis = nan(2,2,2);
%         for param=1:length(param_cis)
%             x = bootparams_radial.(fn{1})(:,param);
%             p = 95; CI_95 = CIFcn(x,p);  
%             p = 68; CI_68 = CIFcn(x,p);
%             param_cis(:,param,1) = [CI_95(1);CI_95(2)];
%             param_cis(:,param,2) = [CI_68(1);CI_68(2)];
%         end
%         bootci_radial.(fn{1}) = param_cis;
%     end
% 
%     for fn = fieldnames(bootparams_tang)'
%         bootci_tang.(fn{:}) = [];
%         disp(fn{1})
%         param_cis = nan(2,2,2);
%         for param=1:length(param_cis)
%             x = bootparams_tang.(fn{1})(:,param);
%             p = 95; CI_95 = CIFcn(x,p);  
%             p = 68; CI_68 = CIFcn(x,p);
%             param_cis(:,param,1) = [CI_95(1);CI_95(2)];
%             param_cis(:,param,2) = [CI_68(1);CI_68(2)];
%         end
%         bootci_tang.(fn{1}) = param_cis;
%     end
%     
%     save(fullfile(relative_summarypath,'bootci_all_loc'), 'bootci_radial', ...
%     'bootci_tang');

end