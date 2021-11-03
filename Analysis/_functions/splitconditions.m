function [cond_dirs] = splitconditions(M_raw_concatenated, absolute_summarypath, maplocation, mapdirection, b_iter)

    cond_dirs = cell(length(maplocation)*length(mapdirection), 1);
    count=1;
    
    for li=1:length(maplocation)
        loc_dir = fullfile(absolute_summarypath, maplocation(li));
        if ~exist(loc_dir, 'dir')
                mkdir(loc_dir)
        end
        
        for di=1:length(mapdirection)
            direction_dir = fullfile(loc_dir, mapdirection(di));
            if ~exist(direction_dir, 'dir')
                mkdir(direction_dir)
            end

        % col3 = target location; col4 = motion direction
        raw_data=M_raw_concatenated(M_raw_concatenated(:,3)==li & M_raw_concatenated(:,4)==di,:);
        save(fullfile(direction_dir, 'raw_data'),'raw_data')

        [datasummary, rownames,bootsAns_levels] = compute_summary(raw_data, b_iter);
        
        try
            summarytable = array2table(datasummary, 'RowNames', rownames);
            summarybootstraps = bootsAns_levels;
        catch
            datasummary = nan(4,10); % no data yet
            summarytable = array2table(datasummary, 'RowNames', rownames);
            summarybootstraps = nan(b_iter,10);
        end
        
        save(fullfile(direction_dir, 'summarytable'),'summarytable')
        save(fullfile(direction_dir, 'summarybootstraps'),'summarybootstraps')
        
        cond_dirs{count,1} = direction_dir;
        count=count+1;
        
        end
    end
end