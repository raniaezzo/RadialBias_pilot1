function checkdir(projectname)

mydir = pwd; idcs = strfind(mydir,projectname);
try
    mydir = fullfile(mydir(1:idcs(end)-1),projectname,'Analysis'); cd(mydir) 
catch
    fprintf('DIRECTORY ERROR: Must be within %s folder or subfolder', projectname)
end

return