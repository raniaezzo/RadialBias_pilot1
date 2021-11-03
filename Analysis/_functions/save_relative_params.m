function save_relative_params(relative_summarypath, absolute_summarypath, ...
    cond_dirs, radialtang_conversion)

% this avoids re-running the analysis again for new conditions;
% copies/renames folders etc.

radialtang4_dir = fullfile(relative_summarypath, 'RADIALTANG_4');
radialtang2_dir = fullfile(relative_summarypath, 'RADIALTANG_2');
cardinaloblique_dir = fullfile(relative_summarypath, 'CARDINALOBLIQUE');

% radialin vs radialout vs tangright vs tangleft
if ~exist(radialtang4_dir, 'dir')
    mkdir(radialtang4_dir)
end

for ci=1:length(cond_dirs)
    condition = cond_dirs{ci}; pathparts = strsplit(condition,filesep);
    location = pathparts{end-1}; direction = pathparts{end};
    % convert to radialtang4
    relative_direction = radialtang_conversion.(location).(direction);
    relative_direction_path = fullfile(radialtang4_dir, location, relative_direction);
    if ~isempty(relative_direction) && ~exist(relative_direction_path, 'dir')
        copyfile(cond_dirs{ci},relative_direction_path)
    end
end

% cardinal vs oblique
if ~exist(cardinaloblique_dir, 'dir')
    mkdir(cardinaloblique_dir)
end

% locations in absolute folder
locations = dir([absolute_summarypath '/loc_*']); locations = setdiff({locations.name},{'.','..', '.DS_Store'});

for li=1:length(locations)  
    cardinalfolder = fullfile(cardinaloblique_dir,locations{li},'cardinal');
    if ~exist(cardinalfolder, 'dir')
        mkdir(cardinalfolder)
    end
    upwards = load(fullfile(absolute_summarypath, locations{li}, 'upwards', 'params.mat'));
    upwards = upwards.paramsValues;
    downwards = load(fullfile(absolute_summarypath, locations{li}, 'downwards', 'params.mat'));
    downwards = downwards.paramsValues;
    leftwards = load(fullfile(absolute_summarypath, locations{li}, 'leftwards', 'params.mat'));
    leftwards = leftwards.paramsValues;
    rightwards = load(fullfile(absolute_summarypath, locations{li}, 'rightwards', 'params.mat'));
    rightwards = rightwards.paramsValues;
    paramsValues = mean([upwards; downwards; leftwards; rightwards], 1);
    save(fullfile(cardinalfolder, 'params.mat'),'paramsValues')
    paramsValues = abs(paramsValues);
    save(fullfile(cardinalfolder, 'abs_params.mat'),'paramsValues')
    
    boot_upwards = load(fullfile(absolute_summarypath, locations{li}, 'upwards', 'params_boot.mat'));
    boot_upwards = boot_upwards.bootParamValues;
    boot_downwards = load(fullfile(absolute_summarypath, locations{li}, 'downwards', 'params_boot.mat'));
    boot_downwards = boot_downwards.bootParamValues;
    boot_leftwards = load(fullfile(absolute_summarypath, locations{li}, 'leftwards', 'params_boot.mat'));
    boot_leftwards = boot_leftwards.bootParamValues;
    boot_rightwards = load(fullfile(absolute_summarypath, locations{li}, 'rightwards', 'params_boot.mat'));
    boot_rightwards = boot_rightwards.bootParamValues;
    bootParamValues = (boot_upwards+boot_downwards+boot_leftwards+boot_rightwards)/4;
    save(fullfile(cardinalfolder, 'params_boot.mat'),'bootParamValues')
    bootParamValues = abs(bootParamValues);
    save(fullfile(cardinalfolder, 'abs_params_boot.mat'),'bootParamValues')
    
    obliquefolder = fullfile(cardinaloblique_dir,locations{li},'oblique');
    if ~exist(obliquefolder, 'dir')
        mkdir(obliquefolder)
    end
    lowerleftwards = load(fullfile(absolute_summarypath, locations{li}, 'lowerleftwards', 'params.mat'));
    lowerleftwards = lowerleftwards.paramsValues;
    lowerrightwards = load(fullfile(absolute_summarypath, locations{li}, 'lowerrightwards', 'params.mat'));
    lowerrightwards = lowerrightwards.paramsValues;
    upperleftwards = load(fullfile(absolute_summarypath, locations{li}, 'upperleftwards', 'params.mat'));
    upperleftwards = upperleftwards.paramsValues;
    upperrightwards = load(fullfile(absolute_summarypath, locations{li}, 'upperrightwards', 'params.mat'));
    upperrightwards = upperrightwards.paramsValues;
    paramsValues = mean([lowerleftwards; lowerrightwards; upperleftwards; upperrightwards], 1);
    save(fullfile(obliquefolder, 'params.mat'),'paramsValues')
    paramsValues = abs(paramsValues);
    save(fullfile(obliquefolder, 'abs_params.mat'),'paramsValues')
    
    boot_lowerleftwards = load(fullfile(absolute_summarypath, locations{li}, 'lowerleftwards', 'params_boot.mat'));
    boot_lowerleftwards = boot_lowerleftwards.bootParamValues;
    boot_lowerrightwards = load(fullfile(absolute_summarypath, locations{li}, 'lowerrightwards', 'params_boot.mat'));
    boot_lowerrightwards = boot_lowerrightwards.bootParamValues;
    boot_upperleftwards = load(fullfile(absolute_summarypath, locations{li}, 'upperleftwards', 'params_boot.mat'));
    boot_upperleftwards = boot_upperleftwards.bootParamValues;
    boot_upperrightwards = load(fullfile(absolute_summarypath, locations{li}, 'upperrightwards', 'params_boot.mat'));
    boot_upperrightwards = boot_upperrightwards.bootParamValues;
    bootParamValues = (boot_lowerleftwards+boot_lowerrightwards+boot_upperleftwards+boot_upperrightwards)/4;
    save(fullfile(obliquefolder, 'params_boot.mat'),'bootParamValues')
    bootParamValues = abs(bootParamValues);
    save(fullfile(obliquefolder, 'abs_params_boot.mat'),'bootParamValues')
end


% radial vs tangential
if ~exist(radialtang2_dir, 'dir')
    mkdir(radialtang2_dir)
end

% locations in relative folder
locations = dir([radialtang4_dir '/loc_*']); locations = setdiff({locations.name},{'.','..'});

for li=1:length(locations)
    radialfolder = fullfile(radialtang2_dir,locations{li},'radial');
    if ~exist(radialfolder, 'dir')
        mkdir(radialfolder)
    end
    radial_in = load(fullfile(radialtang4_dir, locations{li}, 'radial_in', 'params.mat'));
    radial_in = radial_in.paramsValues;
    radial_out = load(fullfile(radialtang4_dir, locations{li}, 'radial_out', 'params.mat'));
    radial_out = radial_out.paramsValues;
    paramsValues = mean([radial_in; radial_out], 1);
    save(fullfile(radialfolder, 'params.mat'),'paramsValues')
    paramsValues = abs(paramsValues);
    save(fullfile(radialfolder, 'abs_params.mat'),'paramsValues')

    boot_radial_in = load(fullfile(radialtang4_dir, locations{li}, 'radial_in', 'params_boot.mat'));
    boot_radial_in = boot_radial_in.bootParamValues;
    boot_radial_out = load(fullfile(radialtang4_dir, locations{li}, 'radial_out', 'params_boot.mat'));
    boot_radial_out = boot_radial_out.bootParamValues;
    bootParamValues = (boot_radial_in+boot_radial_out)/2;
    save(fullfile(radialfolder, 'params_boot.mat'),'bootParamValues')
    bootParamValues = abs(bootParamValues);
    save(fullfile(radialfolder, 'abs_params_boot.mat'),'bootParamValues')

    tangfolder = fullfile(radialtang2_dir,locations{li},'tang');
    if ~exist(tangfolder, 'dir')
        mkdir(tangfolder)
    end
    tang_right = load(fullfile(radialtang4_dir, locations{li}, 'tang_right', 'params.mat'));
    tang_right = tang_right.paramsValues;
    tang_left = load(fullfile(radialtang4_dir, locations{li}, 'tang_left', 'params.mat'));
    tang_left = tang_left.paramsValues;
    paramsValues = mean([tang_right; tang_left], 1);
    save(fullfile(tangfolder, 'params.mat'),'paramsValues')
    paramsValues = abs(paramsValues);
    save(fullfile(tangfolder, 'abs_params.mat'),'paramsValues')

    boot_tang_right = load(fullfile(radialtang4_dir, locations{li}, 'tang_right', 'params_boot.mat'));
    boot_tang_right = boot_tang_right.bootParamValues;
    boot_tang_left = load(fullfile(radialtang4_dir, locations{li}, 'tang_left', 'params_boot.mat'));
    boot_tang_left = boot_tang_left.bootParamValues;
    bootParamValues = (boot_tang_right+boot_tang_left)/2;
    save(fullfile(tangfolder, 'params_boot.mat'),'bootParamValues')
    bootParamValues = abs(bootParamValues);
    save(fullfile(tangfolder, 'abs_params_boot.mat'),'bootParamValues')
end


end