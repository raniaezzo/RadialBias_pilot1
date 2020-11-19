%% General experimenter launcher %%
%  =============================  %
% The following code was adapted from the 2IFC template provided by Martin Szinte's Programming course
% http://www.martinszinte.net/Martin_Szinte/Teaching_files/Prog_c6.pdf

%% Initial settings
% Initial closing :
clear all;clear mex;clear functions;
close all;home;ListenChar(1);tic

% General settings
const.expName      = 'Heeley_BuchananSmith_92';          % experiment name and folder
const.expStart     = 1;                     % Start of a recording exp  0 = NO   , 1 = YES

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
