function save_mean_params(type_summarypath, orig_filename, output_filename)

    load(fullfile(type_summarypath,orig_filename))

    for fn = fieldnames(params_radial)'
        params_radial.(fn{1}) = (params_radialin.(fn{1}) + params_radialout.(fn{1}))/2;
    end
    
    for fn = fieldnames(params_tang)'
        params_tang.(fn{1}) = (params_tangright.(fn{1}) + params_tangleft.(fn{1}))/2;
    end
    
    for fn = fieldnames(bootparams_radial)'
        bootparams_radial.(fn{1}) = (bootparams_radialin.(fn{1}) + bootparams_radialout.(fn{1}))/2;
    end
    
    for fn = fieldnames(bootparams_tang)'
        bootparams_tang.(fn{1}) = (bootparams_tangright.(fn{1}) + bootparams_tangleft.(fn{1}))/2;
    end
    
    save(fullfile(type_summarypath, output_filename), 'params_radialout',...
                'bootparams_radialout','params_radialin', 'bootparams_radialin',...
                'params_tangleft','bootparams_tangleft', ...
                'params_tangright','bootparams_tangright', 'params_radial', ...
                'bootparams_radial', 'params_tang', 'bootparams_tang') 

end