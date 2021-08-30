function save_abs_params(type_summarypath, orig_filename, output_filename)

    load(fullfile(type_summarypath, orig_filename));

    for fn = fieldnames(params_radialin)'
        params_radialin.(fn{1}) = abs(params_radialin.(fn{1}));
    end
    
    for fn = fieldnames(params_radialout)'
        params_radialout.(fn{1}) = abs(params_radialout.(fn{1}));
    end
    
    for fn = fieldnames(params_radial)'
        params_radial.(fn{1}) = abs(params_radial.(fn{1}));
    end
    
    for fn = fieldnames(params_tangright)'
        params_tangright.(fn{1}) = abs(params_tangright.(fn{1}));
    end
    
    for fn = fieldnames(params_tangleft)'
        params_tangleft.(fn{1}) = abs(params_tangleft.(fn{1}));
    end
    
    for fn = fieldnames(params_tang)'
        params_tang.(fn{1}) = abs(params_tang.(fn{1}));
    end
    
    % bootstrapped params
    
    for fn = fieldnames(bootparams_radialin)'
        bootparams_radialin.(fn{1}) = abs(bootparams_radialin.(fn{1}));
    end
    
    for fn = fieldnames(bootparams_radialout)'
        bootparams_radialout.(fn{1}) = abs(bootparams_radialout.(fn{1}));
    end
    
    for fn = fieldnames(bootparams_radial)'
        bootparams_radial.(fn{1}) = abs(bootparams_radial.(fn{1}));
    end
    
    for fn = fieldnames(bootparams_tangright)'
        bootparams_tangright.(fn{1}) = abs(bootparams_tangright.(fn{1}));
    end
    
    for fn = fieldnames(bootparams_tangleft)'
        bootparams_tangleft.(fn{1}) = abs(bootparams_tangleft.(fn{1}));
    end
    
    for fn = fieldnames(bootparams_tang)'
        bootparams_tang.(fn{1}) = abs(bootparams_tang.(fn{1}));
    end

    save(fullfile(type_summarypath,output_filename), 'params_radialout',...
            'bootparams_radialout','params_radialin', 'bootparams_radialin',...
            'params_tangleft','bootparams_tangleft', ...
            'params_tangright','bootparams_tangright', 'params_radial', ...
            'bootparams_radial', 'params_tang', 'bootparams_tang') 
    
end