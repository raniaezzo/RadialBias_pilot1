function runTrials(scr,const,expDes,my_key,textExp,button,EL)
% ----------------------------------------------------------------------
% runTrials(scr,const,expDes,my_key,textExp,button)
% ----------------------------------------------------------------------
% Goal of the function :
% Main trial function, display the trial function and save the experi-
% -mental data in different files.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containing all the constant configurations.
% expDes : struct containing all the variable design and configurations.
% my_key : keyborad keys names
% textExp : struct contanining all instruction text.
% button : struct containing all button text.
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------

%% General instructions:
keyPressed = instructions(scr,const,my_key,textExp.instruction1,button.instruction1);

% added
while KbCheck; end
FlushEvents('KeyDown');
clear KbCheck;
[keyIsDown, ~, keyCode] = KbCheck(-1);

% Check for eyetracking
switch keyPressed
    case 32 % space on PC
        if const.EL_mode
            [~, exitFlag] = initEyelinkStates('calibrate', scr.main, EL);
            if exitFlag, return, end
        end
    case 81 % 'q' on PC
        if const.EL_mode, Eyelink('Shutdown'); end
        makeBeep([.1 .1], 1000)
        Screen('CloseAll'); error('Alert: Experiment stopped by user!');
end

% Enable alpha blending for proper combination of the gaussian aperture
% with the drifting sine grating:
Screen('BlendFunction', scr.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% gabor
const.gabortex = CreateProceduralGabor(scr.main, const.gaborDim_xpix, const.gaborDim_xpix,...
    [], [0.5 0.5 0.5 0.0], 1, 0.5);

%% Main Loop
expDone = 0;
newJ = 0;
startJ = 1;
sectionsize=expDes.j/4;  % break size
while ~expDone
    for t = startJ:expDes.j   % 1 to numTrials
        
        % create a directory for movie of that trial
        %mkdir(sprintf('%s/Movies/%i',pwd, t));
        disp(t)
        % break (just added)
        if ~rem(t,sectionsize) && (t~=expDes.j)
            instructions(scr,const,my_key,textExp.pause,button.pause);
        end
        
        trialDone = 0;
        while ~trialDone

            %try
                [resMat, xUpdate_tilt] = runSingleTrial(scr,const,expDes,my_key,t,EL);
                const.stairs.xCurrent = xUpdate_tilt; % added
                if resMat(end-2) == -1 % if pausing experiment (space) (code = -1)
                    trialDone = 1;
                    newJ = newJ+1;
                    expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);
                    instructions(scr,const,my_key,textExp.pause,button.pause);
                elseif resMat(end-2) == -2 % broken fixation (code = -2)
                    trialDone = 1;
                    newJ = newJ+1;
                    expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);
                else
                    trialDone = 1; % completed trials
                    expResMat(t,:)= [expDes.expMat(t,:),resMat];
                    csvwrite(const.expRes_fileCsv,expResMat);
                end
            %catch                         % for esc
            %    trialDone = 1;
            %    newJ = 0;                 % no added trials
            %    expDone = 1;              % stop exp loop
            %    expResMat(t,:)= [expDes.expMat(t,:),resMat];
            %    csvwrite(const.expRes_fileCsv,expResMat);
            %    % copied below for whenever exiting function
            %    const.my_clock_end = clock;
            %    const_file = fopen(const.const_fileDat,'a+');
            %    fprintf(const_file,'Ending time :\t%ih%i',const.my_clock_end(4),const.my_clock_end(5));
            %    fclose('all');
            %    return;
            %end
        end
        if const.EL_mode, Eyelink('message', 'TRIAL_END'); end
    end
    %% If error of fixation of volontary missed trial
    if ~newJ
        expDone = 1;
    else
        startJ = expDes.j+1;
        expDes.j = expDes.j+newJ;
        expDes.expMat=[expDes.expMat;expDes.expMatAdd];
        expDes.expMatAdd = [];
        newJ = 0;
    end
end

const.my_clock_end = clock;
const_file = fopen(const.const_fileDat,'a+');
fprintf(const_file,'Ending time :\t%ih%i',const.my_clock_end(4),const.my_clock_end(5));
fclose('all');

% saving eye tracking file
if const.EL_mode
    if ~exist(const.eyeDataDir,'dir'), mkdir(const.eyeDataDir); end
    initEyelinkStates('eyestop', scr.main, {const.eyeFile, const.eyeDataDir})
end

instructions(scr,const,my_key,textExp.end,button.end); % thank you message

end