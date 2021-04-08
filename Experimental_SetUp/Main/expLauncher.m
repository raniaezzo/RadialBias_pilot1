%% General experimenter launcher %%
%  =============================  %
% The following code was adapted from the 2IFC template provided by Martin Szinte's Programming course
% http://www.martinszinte.net/Martin_Szinte/Teaching_files/Prog_c6.pdf

% On macOS Catlina and Big Sur Psychtoolbox does not have keyboard access by default
% see: https://psychtoolbox.discourse.group/t/kbdemo-not-working-mac-osx-catalina/3042
% Install PsychoPy as a workaround

%% Initial settings
% Initial closing :
warning('off'); sca, Screen('CloseAll'); clc; commandwindow; % added
%Screen('Preference', 'SkipSyncTests', 1); % change to 0 for real exp
InitializePsychSound(1);

clear all;clear mex;clear functions;
close all;home;ListenChar(1);tic
addpath(genpath(pwd));
load('conditions.mat')

EL_mode = 1; % 0 = no eyelink; 1 = eyelink
EL_modes = {'OFF','ON'};

const.DEBUG = 0; % Debug flag

% exp_mode is either practice, threshold to find thresh using staircase procedure, or experiment
% which uses manual input determined from staircase

session_type = [];
Prompt        = {'Session Type (0-thresholding, 1-experimental, otherkey-practice):'};
Answer        = inputdlg(Prompt,'Info',1);
session_type   = Answer{1};

Prompt        = {'Motion Reference [oblique loc] 1-UR, 2-LL, 3-UL, 4-LR (default) [cardinal loc] 5-VU, 6-VL, 7-HR, 8-HL:'};
Answer    = inputdlg(Prompt,'Info',1);
const.motion_type   = Answer{1};

if isempty(const.motion_type)
    const.motion_type = '4';
    const.params = conditions.LR;
    disp('Motion type (set to default):')
    disp(const.motion_type)  
elseif const.motion_type == '1'
    const.params = conditions.UR;
elseif const.motion_type == '2'
    const.params = conditions.LL;
elseif const.motion_type == '3'
    const.params = conditions.UL;
elseif const.motion_type == '4'
    const.params = conditions.LR;
elseif const.motion_type == '5'
    const.params = conditions.VU;
elseif const.motion_type == '6'
    const.params = conditions.VL;
elseif const.motion_type == '7'
    const.params = conditions.HR;
elseif const.motion_type == '8'
    const.params = conditions.HL;
end

disp('Motion type:')
disp(const.motion_type)

switch session_type
    case '0'
        const.session_type = 'thresholding';
        const.use_staircase = 1;
        const.currStair = 8;
        disp('Session type: thresholding')
    case '1'
        const.session_type = 'experimental';
        const.use_staircase = 0;
        %while isempty(currStair)  % was set to 8 -- why?
        const.currStair = NaN;
        %input('\n angles = [0.25 0.5 1 1.5 2 3 4 5 7 8] \n Enter stair (value) obtained from the thresholding session: \n');
        %end
        disp('Session type: experimental')
    otherwise
        const.session_type = 'practice';
        const.use_staircase = 0;
        const.currStair = 8;
        disp('Session type: practice (default)')
end

% General settings
const.expName      = 'RadialBias_pilot1';          % experiment name and folder
if const.DEBUG
    const.expStart     = 0; % Start of a recording exp  0 = NO   , 1 = YES
else
    const.expStart     = 1; % Start of a recording exp  0 = NO   , 1 = YES
end

% Screen
screen_details = Screen('Computer');

if strcmp(screen_details.system, 'NT-10.0.9200 - ')
    const.desiredFD    = 60;   % Desired refresh rate (change this later)
    const.desiredRes   = [1024 768];  % Desired resolution
    const.experimenter = 'RM-956';
else
    switch screen_details.localHostName
        case 'Ranias-MacBook-Pro-2'
            const.desiredFD    = 60;   % Desired refresh rate (change this later)
            const.desiredRes   = [1024 820];  % Desired resolution
            const.experimenter = 'Rania';
        case 'Bass-iMac'
            disp('Undefined screen configuration for this computer.')
            const.desiredFD    = 60; 
            const.desiredRes   = [1280 720]; 
            const.experimenter = 'Bas';
        case 'fechner' % R1 eyetracker
            const.desiredFD    = 60;
            const.desiredRes   = [1280 960];
            const.experimenter = 'Carrasco-R1';
            disp('fechner')
        otherwise
            disp('Undefined screen configuration for this computer.')
            const.DEBUG = 0;
            const.experimenter = 'Unknown';
    end
end

% Path :
dir = (which('expLauncher'));cd(dir(1:end-18));

% Block definition
numBlockMain = 1;                           % number of block to play per run time
const.numBlockTot  = 10;                    % total number of block before analysis

% Subject configuration :
if const.expStart
    const.sjct = input(sprintf('\n\tInitials (2 letters): '),'s');
    const.sjctCode = sprintf('%s_%s',const.sjct,const.expName);
    const.fromBlock  = input(sprintf('\n\tFrom Block nb: '));
    if const.fromBlock == 1
        const.sjct_age = input(sprintf('\n\tAge: '));
        const.sjct_gender = input(sprintf('\n\tGender (M or F): '),'s');
    end
else
    const.sjct = 'NoName';const.fromBlock = 1;const.sjct_age = 'XX';const.sjct_gender = 'X';
end
const.sjctCode = sprintf('%s_%s',const.sjct,const.expName);

% eyetracker state (controlled by user)
fprintf('Subject: %s, %s, if available, eye-tracker %s.\n ',const.sjct, const.session_type, EL_modes{EL_mode+1})
const.EL_mode = EL_mode;

%% Main experimental code
for block = const.fromBlock:(const.fromBlock+numBlockMain-1)
    const.fromBlock = block;
    main(const);clear expDes
end
