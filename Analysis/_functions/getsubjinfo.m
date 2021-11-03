function [subjectinfo] = getsubjinfo()
    
    % creates struct array with subject per rows
    s = dir('../Experimental_SetUp/Data/');
    s=s(~ismember({s.name},{'.','..','.DS_Store'})); % remove hidden files
    for i=1:length(s)
        subjectinfo(i).name = s(i).name;
    end
    
    for i=1:length(s)
        
            % list all files in directory (assume Block1 just to define all conditions)
            allfiles = dir(sprintf('../Experimental_SetUp/Data/%s/*/Block1/', ...
                s(i).name));

            % add demographics (from first session)
            allfiles = allfiles(~[allfiles.isdir]);
            demofiles = allfiles(startsWith({allfiles.name}, ...  % demo file
                sprintf('const_file%s_RadialBias_pilot1_',s(i).name)));
            demofiles = demofiles(endsWith({demofiles.name}, '.mat'));
            [~,idx] = sort([demofiles.datenum]); demofiles = demofiles(idx);
            demofile = fullfile(demofiles(1).folder, demofiles(1).name);
            load(demofile)
            subjectinfo(i).gender = const.sjct_gender;
            subjectinfo(i).age = const.sjct_age;

            % get answers from expRes%s_RadialBias_pilot1
            contents = allfiles(startsWith({allfiles.name}, ...   % results file
                sprintf('expRes%s_RadialBias_pilot1_',s(i).name)));
            contents = contents(endsWith({contents.name},{'UR.csv','UL.csv','LR.csv', ...
                'LL.csv','VU.csv','VL.csv','HR.csv','HL.csv'}));
            [~,idx] = sort([contents.datenum]);
            contents = contents(idx);

            % get full session list (preserving order)
            filepaths = fullfile(extractfield(contents,'folder')', ...
                extractfield(contents,'name')');
            subjectinfo(i).sessionlist_all = filepaths';
            
    end
    
return