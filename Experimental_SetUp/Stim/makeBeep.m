function makeBeep(dur, freq, amp, fs)

%% set default
if nargin<1 || isempty(dur), dur = 1; end
% error('Usage: beep=MakeBeep(freq,duration,[samplingRate]);')
if nargin<2 || isempty(freq), freq = 400;end
if nargin<3 || isempty(amp), amp = .1;end
if nargin<4 || isempty(fs), fs = 8192; end

%% 
nBeeps = max([length(dur),length(freq),length(amp)]);
for iBeep = 1:nBeeps
    if length(dur)>1, dur_ = dur(iBeep);else, dur_ = dur;end
    if length(freq)>1, freq_ = freq(iBeep);else, freq_ = freq;end
    if length(amp)>1, amp_ = amp(iBeep);else, amp_ = amp;end
    
    beep = amp_*sin(2*pi* freq_*(0:1/fs:dur_));
    sound(beep,fs), WaitSecs(dur_);
end