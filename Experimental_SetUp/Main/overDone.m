function overDone
% ----------------------------------------------------------------------
% overDone
% ----------------------------------------------------------------------
% Goal of the function :
% Close screen, listen keyboard and save duration of the experiment
% ----------------------------------------------------------------------
% Input(s) :
% none
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------

ListenChar(1);
%WaitSecs(2.0);

ShowCursor;
Screen('CloseAll');
timeDur=toc/60;
fprintf(1,'\nTotal time : %2.0f min.\n\n',timeDur);

%PsychPortAudio('Stop', const.pahandle);
%PsychPortAudio('Close', const.pahandle); %added

clear mex;
clear fun;

end

