function organize_absolutedirs(relativemotion_dir, absolutemotion_dir, setting)    

    if ~exist(absolutemotion_dir, 'dir')
        mkdir(absolutemotion_dir)
    end
    
    if strcmp(setting, 'individual')
    
    load(fullfile(relativemotion_dir,'summarydata.mat'))
        
    % cardinal
    summary_upwards.loc_0 = summary_tangleft.loc_0; 
    summary_upwards.loc_90 = summary_radialout.loc_90;
    summary_upwards.loc_180 = summary_tangright.loc_180; 
    summary_upwards.loc_270 = summary_radialin.loc_270;
    
    bootsummary_upwards.loc_0 = bootsummary_tangleft.loc_0; 
    bootsummary_upwards.loc_90 = bootsummary_radialout.loc_90;
    bootsummary_upwards.loc_180 = bootsummary_tangright.loc_180; 
    bootsummary_upwards.loc_270 = bootsummary_radialin.loc_270;
    
    summary_downwards.loc_0 = summary_tangright.loc_0; 
    summary_downwards.loc_90 = summary_radialin.loc_90;
    summary_downwards.loc_180 = summary_tangleft.loc_180; 
    summary_downwards.loc_270 = summary_radialout.loc_270;
    
    bootsummary_downwards.loc_0 = bootsummary_tangright.loc_0; 
    bootsummary_downwards.loc_90 = bootsummary_radialin.loc_90;
    bootsummary_downwards.loc_180 = bootsummary_tangleft.loc_180; 
    bootsummary_downwards.loc_270 = bootsummary_radialout.loc_270;
    
    summary_leftwards.loc_0 = summary_radialin.loc_0;
    summary_leftwards.loc_90 = summary_tangleft.loc_90;
    summary_leftwards.loc_180 = summary_radialout.loc_180;
    summary_leftwards.loc_270 = summary_tangright.loc_270;
    
    bootsummary_leftwards.loc_0 = bootsummary_radialin.loc_0;
    bootsummary_leftwards.loc_90 = bootsummary_tangleft.loc_90; 
    bootsummary_leftwards.loc_180 = bootsummary_radialout.loc_180;
    bootsummary_leftwards.loc_270 = bootsummary_tangright.loc_270; 
    
    summary_rightwards.loc_0 = summary_radialout.loc_0; 
    summary_rightwards.loc_90 = summary_tangright.loc_90;
    summary_rightwards.loc_180 = summary_radialin.loc_180;
    summary_rightwards.loc_270 = summary_tangleft.loc_270;

    bootsummary_rightwards.loc_0 = bootsummary_radialout.loc_0;
    bootsummary_rightwards.loc_90 = bootsummary_tangright.loc_90;
    bootsummary_rightwards.loc_180 = bootsummary_radialin.loc_180;
    bootsummary_rightwards.loc_270 = bootsummary_tangleft.loc_270;
    
    % oblique
    summary_upperrightwards.loc_45 = summary_radialout.loc_45;
    summary_upperrightwards.loc_135 = summary_tangright.loc_135;
    summary_upperrightwards.loc_225 = summary_radialin.loc_225;
    summary_upperrightwards.loc_315 = summary_tangleft.loc_315;
    
    bootsummary_upperrightwards.loc_45 = bootsummary_radialout.loc_45;
    bootsummary_upperrightwards.loc_135 = bootsummary_tangright.loc_135;
    bootsummary_upperrightwards.loc_225 = bootsummary_radialin.loc_225;
    bootsummary_upperrightwards.loc_315 = bootsummary_tangleft.loc_315;
    
    summary_upperleftwards.loc_45 = summary_tangleft.loc_45;
    summary_upperleftwards.loc_135 = summary_radialout.loc_135;
    summary_upperleftwards.loc_225 = summary_tangright.loc_225;
    summary_upperleftwards.loc_315 = summary_radialin.loc_315;
    
    bootsummary_upperleftwards.loc_45 = bootsummary_tangleft.loc_45;
    bootsummary_upperleftwards.loc_135 = bootsummary_radialout.loc_135;
    bootsummary_upperleftwards.loc_225 = bootsummary_tangright.loc_225;
    bootsummary_upperleftwards.loc_315 = bootsummary_radialin.loc_315;
    
    summary_lowerrightwards.loc_45 = summary_tangright.loc_45;
    summary_lowerrightwards.loc_135 = summary_radialin.loc_135;
    summary_lowerrightwards.loc_225 = summary_tangleft.loc_225;
    summary_lowerrightwards.loc_315 = summary_radialout.loc_315;
    
    bootsummary_lowerrightwards.loc_45 = bootsummary_tangright.loc_45;
    bootsummary_lowerrightwards.loc_135 = bootsummary_radialin.loc_135;
    bootsummary_lowerrightwards.loc_225 = bootsummary_tangleft.loc_225;
    bootsummary_lowerrightwards.loc_315 = bootsummary_radialout.loc_315;
    
    summary_lowerleftwards.loc_45 = summary_radialin.loc_45;
    summary_lowerleftwards.loc_135 = summary_tangleft.loc_135;
    summary_lowerleftwards.loc_225 = summary_radialout.loc_225;
    summary_lowerleftwards.loc_315 = summary_tangright.loc_315;
    
    bootsummary_lowerleftwards.loc_45 = bootsummary_radialin.loc_45;
    bootsummary_lowerleftwards.loc_135 = bootsummary_tangleft.loc_135;
    bootsummary_lowerleftwards.loc_225 = bootsummary_radialout.loc_225;
    bootsummary_lowerleftwards.loc_315 = bootsummary_tangright.loc_315;
    
    % save summary data
    save(fullfile(absolutemotion_dir,'summarydata'), 'summary_upwards',...
        'bootsummary_upwards','summary_downwards','bootsummary_downwards',...
        'summary_leftwards', 'bootsummary_leftwards', 'summary_rightwards',...
        'bootsummary_rightwards','summary_upperrightwards','bootsummary_upperrightwards', ...
        'summary_upperleftwards','bootsummary_upperleftwards','summary_lowerleftwards',...
        'bootsummary_lowerleftwards','summary_lowerrightwards','bootsummary_lowerrightwards')
    
    end
    %%
    
    load(fullfile(relativemotion_dir,'analyzeddata.mat'))
    
    % cardinal
    params_upwards.loc_0 = params_tangleft.loc_0;
    params_upwards.loc_90 = params_radialout.loc_90;
    params_upwards.loc_180 = params_tangright.loc_180;
    params_upwards.loc_270 = params_radialin.loc_270;
    
    params_downwards.loc_0 = params_tangright.loc_0;
    params_downwards.loc_90 = params_radialin.loc_90;
    params_downwards.loc_180 = params_tangleft.loc_180;
    params_downwards.loc_270 = params_radialout.loc_270;
    
    params_leftwards.loc_0 = params_radialin.loc_0;
    params_leftwards.loc_90 = params_tangleft.loc_90;
    params_leftwards.loc_180 = params_radialout.loc_180;
    params_leftwards.loc_270 = params_tangright.loc_270;
    
    params_rightwards.loc_0 = params_radialout.loc_0;
    params_rightwards.loc_90 = params_tangright.loc_90;
    params_rightwards.loc_180 = params_radialin.loc_180;
    params_rightwards.loc_270 = params_tangleft.loc_270;
    
    params_upperrightwards.loc_45 = params_radialout.loc_45;
    params_upperrightwards.loc_135 = params_tangright.loc_135;
    params_upperrightwards.loc_225 = params_radialin.loc_225;
    params_upperrightwards.loc_315 = params_tangleft.loc_315;
    
    params_upperleftwards.loc_45 = params_tangleft.loc_45;
    params_upperleftwards.loc_135 = params_radialout.loc_135;
    params_upperleftwards.loc_225 = params_tangright.loc_225;
    params_upperleftwards.loc_315 = params_radialin.loc_315;
    
    params_lowerrightwards.loc_45 = params_tangright.loc_45;
    params_lowerrightwards.loc_135 = params_radialin.loc_135;
    params_lowerrightwards.loc_225 = params_tangleft.loc_225;
    params_lowerrightwards.loc_315 = params_radialout.loc_315;
    
    params_lowerleftwards.loc_45 = params_radialin.loc_45;
    params_lowerleftwards.loc_135 = params_tangleft.loc_135;
    params_lowerleftwards.loc_225 = params_radialout.loc_225;
    params_lowerleftwards.loc_315 = params_tangright.loc_315;
    
    if strcmp(setting, 'group')
            save(fullfile(absolutemotion_dir,'analyzeddata'), 'params_upwards',...
        'params_downwards','params_leftwards', 'params_rightwards',...
        'params_upperrightwards','params_upperleftwards','params_lowerleftwards',...
        'params_lowerrightwards')
    end
    
    if strcmp(setting, 'individual')
    
    bootparams_upwards.loc_0 = bootparams_tangleft.loc_0;
    bootparams_upwards.loc_90 = bootparams_radialout.loc_90;
    bootparams_upwards.loc_180 = bootparams_tangright.loc_180;
    bootparams_upwards.loc_270 = bootparams_radialin.loc_270;
    
    bootparams_downwards.loc_0 = bootparams_tangright.loc_0;
    bootparams_downwards.loc_90 = bootparams_radialin.loc_90;
    bootparams_downwards.loc_180 = bootparams_tangleft.loc_180;
    bootparams_downwards.loc_270 = bootparams_radialout.loc_270;
    
    bootparams_leftwards.loc_0 = bootparams_radialin.loc_0;
    bootparams_leftwards.loc_90 = bootparams_tangleft.loc_90;
    bootparams_leftwards.loc_180 = bootparams_radialout.loc_180;
    bootparams_leftwards.loc_270 = bootparams_tangright.loc_270;

    bootparams_rightwards.loc_0 = bootparams_radialout.loc_0;
    bootparams_rightwards.loc_90 = bootparams_tangright.loc_90;
    bootparams_rightwards.loc_180 = bootparams_radialin.loc_180;
    bootparams_rightwards.loc_270 = bootparams_tangleft.loc_270;
    
    bootparams_upperrightwards.loc_45 = bootparams_radialout.loc_45;
    bootparams_upperrightwards.loc_135 = bootparams_tangright.loc_135;
    bootparams_upperrightwards.loc_225 = bootparams_radialin.loc_225;
    bootparams_upperrightwards.loc_315 = bootparams_tangleft.loc_315;
    
    bootparams_upperleftwards.loc_45 = bootparams_tangleft.loc_45;
    bootparams_upperleftwards.loc_135 = bootparams_radialout.loc_135;
    bootparams_upperleftwards.loc_225 = bootparams_tangright.loc_225;
    bootparams_upperleftwards.loc_315 = bootparams_radialin.loc_315;
    
    bootparams_lowerrightwards.loc_45 = bootparams_tangright.loc_45;
    bootparams_lowerrightwards.loc_135 = bootparams_radialin.loc_135;
    bootparams_lowerrightwards.loc_225 = bootparams_tangleft.loc_225;
    bootparams_lowerrightwards.loc_315 = bootparams_radialout.loc_315;
    
    bootparams_lowerleftwards.loc_45 = bootparams_radialin.loc_45;
    bootparams_lowerleftwards.loc_135 = bootparams_tangleft.loc_135;
    bootparams_lowerleftwards.loc_225 = bootparams_radialout.loc_225;
    bootparams_lowerleftwards.loc_315 = bootparams_tangright.loc_315;
    
    % save analyzed data
    save(fullfile(absolutemotion_dir,'analyzeddata'), 'params_upwards',...
        'bootparams_upwards','params_downwards','bootparams_downwards',...
        'params_leftwards', 'bootparams_leftwards', 'params_rightwards',...
        'bootparams_rightwards','params_upperrightwards','bootparams_upperrightwards', ...
        'params_upperleftwards','bootparams_upperleftwards','params_lowerleftwards',...
        'bootparams_lowerleftwards','params_lowerrightwards','bootparams_lowerrightwards')
    end
    
    %%
    
    if strcmp(setting, 'individual')
    load(fullfile(relativemotion_dir,'bootci.mat'))
    
    % cardinal
    
    bootci_upwards.loc_0 = bootci_tangleft.loc_0;
    bootci_upwards.loc_90 = bootci_radialout.loc_90;
    bootci_upwards.loc_180 = bootci_tangright.loc_180;
    bootci_upwards.loc_270 = bootci_radialin.loc_270;
    
    bootci_downwards.loc_0 = bootci_tangright.loc_0;
    bootci_downwards.loc_90 = bootci_radialin.loc_90;
    bootci_downwards.loc_180 = bootci_tangleft.loc_180;
    bootci_downwards.loc_270 = bootci_radialout.loc_270;
    
    bootci_leftwards.loc_0 = bootci_radialin.loc_0;
    bootci_leftwards.loc_90 = bootci_tangleft.loc_90;
    bootci_leftwards.loc_180 = bootci_radialout.loc_180;
    bootci_leftwards.loc_270 = bootci_tangright.loc_270;

    bootci_rightwards.loc_0 = bootci_radialout.loc_0;
    bootci_rightwards.loc_90 = bootci_tangright.loc_90;
    bootci_rightwards.loc_180 = bootci_radialin.loc_180;
    bootci_rightwards.loc_270 = bootci_tangleft.loc_270;
    
    % oblique
    
    bootci_upperrightwards.loc_45 = bootci_radialout.loc_45;
    bootci_upperrightwards.loc_135 = bootci_tangright.loc_135;
    bootci_upperrightwards.loc_225 = bootci_radialin.loc_225;
    bootci_upperrightwards.loc_315 = bootci_tangleft.loc_315;
    
    bootci_upperleftwards.loc_45 = bootci_tangleft.loc_45;
    bootci_upperleftwards.loc_135 = bootci_radialout.loc_135;
    bootci_upperleftwards.loc_225 = bootci_tangright.loc_225;
    bootci_upperleftwards.loc_315 = bootci_radialin.loc_315;
    
    bootci_lowerrightwards.loc_45 = bootci_tangright.loc_45;
    bootci_lowerrightwards.loc_135 = bootci_radialin.loc_135;
    bootci_lowerrightwards.loc_225 = bootci_tangleft.loc_225;
    bootci_lowerrightwards.loc_315 = bootci_radialout.loc_315;
    
    bootci_lowerleftwards.loc_45 = bootci_radialin.loc_45;
    bootci_lowerleftwards.loc_135 = bootci_tangleft.loc_135;
    bootci_lowerleftwards.loc_225 = bootci_radialout.loc_225;
    bootci_lowerleftwards.loc_315 = bootci_tangright.loc_315;
    
    % save CI data
    save(fullfile(absolutemotion_dir,'bootci'), 'bootci_upwards',...
        'bootci_downwards','bootci_leftwards', 'bootci_rightwards',...
        'bootci_upperrightwards','bootci_upperleftwards','bootci_lowerleftwards',...
        'bootci_lowerrightwards')
    end
end