function initialize_summaryvars(summarypath)

%summarydir = fileparts(summarypath);

if ~exist(summarypath, 'dir')
    mkdir(summarypath)
end

% initialize vars
summary_radialout = []; summary_radialin = []; summary_tangleft = []; summary_tangright = [];
bootsummary_radialout = []; bootsummary_radialin = []; bootsummary_tangleft = []; bootsummary_tangright = [];
summary_radial = []; summary_tang = []; bootsummary_radial = []; bootsummary_tang = [];

% save initialized empty vars
save(fullfile(summarypath,'summarydata'), 'summary_radialout',...
'summary_radialin','summary_tangleft', 'summary_tangright',...
'summary_radial','summary_tang', 'bootsummary_radialout', ...
'bootsummary_radialin', 'bootsummary_tangleft', ...
'bootsummary_tangright','bootsummary_radial','bootsummary_tang')

end