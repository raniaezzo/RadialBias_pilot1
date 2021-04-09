function main(const)
% ----------------------------------------------------------------------
% main(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Main code of experiment
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing subject information and saving files.
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% PsychDefaultSetup(2); % Setup unified keymapping and unit color range
PsychImaging('PrepareConfiguration'); % First step in starting pipeline
Screen('Preference','SkipSyncTests', 1); % override sync error (not good) 

% File directory :
[const] = dirSaveFile(const);

% Screen configuration :
[scr] = scrConfig(const);

% Keyboard configuration :
[my_key] = keyConfig;

% Experimental design configuration :
[expDes] = designConfig(const);

% Experimental constant :
[const] = constConfig(scr,const);

% Instruction file :
[textExp,button] = instructionConfig;

% Open screen window :
if const.DEBUG
    winRect = [0 0 1024 820];
else
    winRect = [];
end
% [scr.main,scr.rect] = Screen('OpenWindow',scr.scr_num,[0 0 0],[],[],2);
[scr.main,scr.rect] = PsychImaging('OpenWindow', scr.scr_num, [.5 .5 .5], winRect, 32, 2,...
     [], [],  kPsychNeed32BPCFloat);   % just added


Screen('BlendFunction', scr.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
priorityLevel = MaxPriority(scr.main);Priority(priorityLevel);

% Initialize eyetracking
if const.EL_mode, EL = initEyetracking(const, scr.main); end
EL.ON = const.EL_mode; % I dont think I need this line

% Main part :
if const.expStart;ListenChar(2);end
GetSecs;runTrials(scr,const,expDes,my_key,textExp,button,EL);

% End
overDone

end