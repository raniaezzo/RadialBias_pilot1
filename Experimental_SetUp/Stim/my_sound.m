function my_sound (const)
% ----------------------------------------------------------------------
% my_sound(t)
% ----------------------------------------------------------------------
% Goal of the function :
% Play a wave file a specified number of time.
% ----------------------------------------------------------------------
% Input(s) :
% waveFile : wave file directory
% t : switch between diferent sounds.
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------

%t = const.numFrm_T2_start;
%pahandle = const.pahandle;
%tone = MakeBeep(523, 0.2, 44100);
%respTone = applyEnvelope(tone, 44100);
%PsychPortAudio('FillBuffer', pahandle, respTone);
%PsychPortAudio('Start', pahandle, [], t, 1); % timeRespCue = 

%if t == 1
%    % Ready Signal (Auditory tone)

InitializePsychSound(1);
Snd('Play',[repmat(0.3,1,150) linspace(0.4,0.0,50)].*[zeros(1,100) sin(1:100)],3000); 
%end
%Snd('Play',sin(0:100));
%Snd('Wait');              % wait until end of all sounds currently in channel
%Snd('Quiet');
end