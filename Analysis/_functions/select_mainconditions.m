function [main_conditions, ci_values] = select_mainconditions(path, ...
                organization)
            
locations = dir([path '/loc_*']); locations = setdiff({locations.name},{'.','..', '.DS_Store'});

main_conditions = cell(1,length(organization));
for oi=1:length(organization)
    for li=1:length(locations)
        try
            load(fullfile(path, locations{li}, organization{oi}, 'abs_params.mat'));
            T.(locations{li}) = paramsValues;
        catch
            T.(locations{li}) = nan(1,4); % if the folder doesn't exist
        end
    end
    main_conditions{1,oi} = T;
    clear T;
end

ci_values = cell(1,length(organization));
for oi=1:length(organization)
    for li=1:length(locations)
        try
            load(fullfile(path, locations{li}, organization{oi}, 'abs_bootci.mat'));
            T.(locations{li}) = boot_ci;
        catch
            T.(locations{li}) = nan(2,2,2); % if the folder doesn't exist
        end
    end
    ci_values{1,oi} = T;
    clear T;
end
                      
end