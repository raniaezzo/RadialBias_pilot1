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
Screen('Preference','SkipSyncTests', 1); % override time error 

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
[scr.main,scr.rect] = Screen('OpenWindow',scr.scr_num,[0 0 0],[],[],2);
% [scr.main,scr.rect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2,...
%     [], [],  kPsychNeed32BPCFloat);   % just added

Screen('BlendFunction', scr.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
priorityLevel = MaxPriority(scr.main);Priority(priorityLevel);

% Main part :
if const.expStart;ListenChar(2);end
GetSecs;runTrials(scr,const,expDes,my_key,textExp,button);

% End
overDone

end