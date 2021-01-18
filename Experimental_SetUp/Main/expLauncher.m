%% General experimenter launcher %%
%  =============================  %
% The following code was adapted from the 2IFC template provided by Martin Szinte's Programming course
% http://www.martinszinte.net/Martin_Szinte/Teaching_files/Prog_c6.pdf

% On macOS Catlina and Big Sur Psychtoolbox does not have keyboard access by default
% see: https://psychtoolbox.discourse.group/t/kbdemo-not-working-mac-osx-catalina/3042
% Install PsychoPy as a workaround

%% Initial settings
% Initial closing :
clear all;clear mex;clear functions;
close all;home;ListenChar(1);tic
addpath(genpath(pwd));

const.DEBUG = 1; % Debug flag

% exp_mode is either practice, threshold to find thresh using staircase procedure, or experiment
% which uses manual input determined from staircase

session_type = [];
%while isempty(session_type)
Prompt        = {'Session Type (0-thresholding, 1-experimental, otherkey-practice):'};
Answer        = inputdlg(Prompt,'Info',1);
    %session_type   = str2double(Answer{1});
session_type   = Answer{1};
%end

switch session_type
    case '0'
        const.session_type = 'thresholding';
        const.use_staircase = 1;
        const.currStair = 8;
        disp('thresholding')
    case '1'
        const.session_type = 'experimental';
        const.use_staircase = 0;
        %while isempty(currStair)  % was set to 8 -- why?
        const.currStair = input('\n stairs = [0.25 0.5 1 1.5 2 3 4 5 7 8] \n Enter stair (value) obtained from the thresholding session: \n');
        %end
        disp('experimental')
    otherwise
        const.session_type = 'practice';
        const.use_staircase = 0;
        const.currStair = 8;
        disp('practice')
end

% General settings
const.expName      = 'RadialBias_pilot1';          % experiment name and folder
if const.DEBUG
    const.expStart     = 0; % Start of a recording exp  0 = NO   , 1 = YES
else
    const.expStart     = 1; % Start of a recording exp  0 = NO   , 1 = YES
end

% Screen
const.desiredFD    = 60;   % Desired refresh rate (change this later)
const.desiredRes   = [1024 820];  % Desired resolution

% Path :
dir = (which('expLauncher'));cd(dir(1:end-18));

% Block definition
numBlockMain = 1;                           % number of block to play per run time
const.numBlockTot  = 10;                    % total number of block before analysis

% Subject configuration :
if const.expStart
    const.sjct = input(sprintf('\n\tInitials: '),'s');
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


%% Main experimental code
for block = const.fromBlock:(const.fromBlock+numBlockMain-1)
    const.fromBlock = block;
    main(const);clear expDes
end
