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


[currentpath] = fullfile(cd);
[~, ParentFolderName] = fileparts(currentpath);
if ParentFolderName ~= 'Experimental_SetUp'
    disp('Not in correct directory. Please run code from Experimental_SetUp dir.')
end

% Creates Directory
if ~isfolder(sprintf('%s/Data/%s',currentpath,const.sjct))
    mkdir(sprintf('%s/Data/%s',currentpath,const.sjct));
    cd (sprintf('%s/Data/%s',currentpath,const.sjct));
else
    cd (sprintf('%s/Data/%s',currentpath,const.sjct));
end

[currentpath] = sprintf(cd);

if const.expStart
    %expDir = sprintf('Data/%s/ExpData/Block%i',const.sjct,const.fromBlock);
    expDir = sprintf('%s/ExpData/Block%i',currentpath,const.fromBlock);
    if ~isfolder(expDir)
        mkdir(expDir);
        cd(expDir);
    else
        aswErase = input('\n This file allready exist, do you want to overwrite it ? (Y or N)    ','s');
        if ismember(aswErase, ['N','n'])
            error('Please restart the program with correct input.')
        elseif ismember(aswErase, ['Y','y'])
            cd(expDir);
        else
            error('Incorrect input => Please restart the program with correct input.')
        end
    end
    
    % delete any saved movies
    movieDir = sprintf('%s/Movies',expDir);
    if isfolder(movieDir)
        %delete(sprintf('%\*', movieDir));
        rmdir(movieDir, 's')
    end

else
    const.c = clock;
    
    debugDir = sprintf('%s/DebugData/%i-%i_trials/',currentpath, const.c(2),const.c(3));
    if ~isfolder(debugDir)
        mkdir(debugDir);
        cd (debugDir);
    else
        cd (debugDir);
    end

end

if const.motion_type == '1'
    motion_type = 'UR';
elseif const.motion_type == '2'
    motion_type = 'LL';
elseif const.motion_type == '3'
    motion_type = 'UL';
elseif const.motion_type == '4'
    motion_type = 'LR';
elseif const.motion_type == '5'
    motion_type = 'VU';
elseif const.motion_type == '6'
    motion_type = 'VL';
elseif const.motion_type == '7'
    motion_type = 'HR';
elseif const.motion_type == '8'
    motion_type = 'HL';
end

const.eyeDataDir = 'eyedata';
const.eyeFile = sprintf('eyedata_%s%s_%s', const.sjctCode,datestr(now, 'YYYYmmddHH'),  motion_type);

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
addpath('../../../../Eyetracking/');
addpath('../../../../Data/');
addpath('../../../../Instructions/');
addpath('../../../../Main/');
addpath('../../../../Staircase/');
addpath('../../../../Stim/');
addpath('../../../../Trials/');

end