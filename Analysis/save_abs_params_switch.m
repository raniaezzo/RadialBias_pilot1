function save_abs_params_switch(type_summarypath, orig_filename, output_filename)

    load(fullfile(type_summarypath, orig_filename));

    for fn = fieldnames(params_inclock)'
        params_inclock.(fn{1}) = abs(params_inclock.(fn{1}));
    end
    
    for fn = fieldnames(params_outclock)'
        params_outclock.(fn{1}) = abs(params_outclock.(fn{1}));
    end
    
    for fn = fieldnames(params_incclock)'
        params_incclock.(fn{1}) = abs(params_incclock.(fn{1}));
    end
    
    for fn = fieldnames(params_outcclock)'
        params_outcclock.(fn{1}) = abs(params_outcclock.(fn{1}));
    end
    
    % bootstrapped params
    
    for fn = fieldnames(bootparams_inclock)'
        bootparams_inclock.(fn{1}) = abs(bootparams_inclock.(fn{1}));
    end
    
    for fn = fieldnames(bootparams_outclock)'
        bootparams_outclock.(fn{1}) = abs(bootparams_outclock.(fn{1}));
    end
    
    for fn = fieldnames(bootparams_incclock)'
        bootparams_incclock.(fn{1}) = abs(bootparams_incclock.(fn{1}));
    end
    
    for fn = fieldnames(bootparams_outcclock)'
        bootparams_outcclock.(fn{1}) = abs(bootparams_outcclock.(fn{1}));
    end

    save(fullfile(type_summarypath,output_filename), 'params_outclock',...
            'bootparams_outclock','params_inclock', 'bootparams_inclock',...
            'params_outcclock','bootparams_outcclock', ...
            'params_incclock','bootparams_incclock') 
    
end