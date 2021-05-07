function namelist = getsubs()
    s = dir('../Experimental_SetUp/Data/');
    s=s(~ismember({s.name},{'.','..','.DS_Store'})); % remove hidden files
    namelist = extractfield(s,'name');
return