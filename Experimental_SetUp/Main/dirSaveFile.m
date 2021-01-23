function [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% [const]=dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------


[currentpath] = sprintf(cd);
[~, ParentFolderName] = fileparts(currentpath);
if ParentFolderName ~= 'Experimental_SetUp'
    disp('Not in correct directory. Please run code from Experimental_SetUp dir.')
end

% Creates Directory
if ~isdir(sprintf('%s/Data/%s',currentpath,const.sjct))
    mkdir(sprintf('%s/Data/%s',currentpath,const.sjct));
    cd (sprintf('%s/Data/%s',currentpath,const.sjct));
else
    cd (sprintf('%s/Data/%s',currentpath,const.sjct));
end

[currentpath] = sprintf(cd);

if const.expStart
    %expDir = sprintf('Data/%s/ExpData/Block%i',const.sjct,const.fromBlock);
    expDir = sprintf('%s/ExpData/Block%i',currentpath,const.fromBlock);
    if ~isdir(expDir)
        mkdir(expDir);
        cd(expDir);
    else
        aswErase = input('\n This file allready exist, do you want to overwrite it ? (Y or N)    ','s');
        if aswErase == 'N'
            error('Please restart the program with correct input.')
        elseif aswErase == 'Y'
            cd(expDir);
        else
            error('Incorrect input => Please restart the program with correct input.')
        end
    end

else
    const.c = clock;
    
    debugDir = sprintf('%s/DebugData/%i-%i_trials/',currentpath, const.c(2),const.c(3));
    if ~isdir(debugDir)
        mkdir(debugDir);
        cd (debugDir);
    else
        cd (debugDir);
    end

end

if const.motion_type == '1'
    motion_type = 'tangential_counterclockwise';
elseif const.motion_type == '2'
    motion_type = 'tangential_clockwise';
elseif const.motion_type == '3'
    motion_type = 'radial_inward';
elseif const.motion_type == '4'
    motion_type = 'radial_outward';
end

% Defines saving file names
const.scr_fileDat =         sprintf('scr_file%s_%s.dat',const.sjctCode, motion_type);
const.scr_fileMat =         sprintf('scr_file%s_%s.mat',const.sjctCode, motion_type);
const.const_fileDat =       sprintf('const_file%s_%s.dat',const.sjctCode, motion_type);
const.const_fileMat =       sprintf('const_file%s_%s.mat',const.sjctCode, motion_type);
const.expRes_fileCsv =      sprintf('expRes%s_%s.csv',const.sjctCode, motion_type);
const.design_fileMat =      sprintf('design%s_%s.mat',const.sjctCode, motion_type);

% Add path from the location of the data file folder
addpath('../../../../Config/');
addpath('../../../../Conversion/');
addpath('../../../../Data/');
addpath('../../../../Instructions/');
addpath('../../../../Main/');
addpath('../../../../Staircase/');
addpath('../../../../Stim/');
addpath('../../../../Trials/');

end