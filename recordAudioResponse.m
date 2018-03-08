function duration = recordAudioResponse(outputfilename, stopKeyCode, animate, win)
% Record an audio clip, optionally including playing an animation.
%
% INPUT
%  outputfilename   Name of the sound file to write out (.wav)
%  stopKeyCode      What key stops recording?
%  animate          If true, draws a tape recorder animation.
%  win              Open window to draw to if animate is true.
%
% OUTPUT
%  duration         Length of recorded clip, in s.
%
% Usage: duration = recordAudioResponse(outputfilename, stopKeyCode, animate, win)

samplerate = 22050;
bitdepth = 16;

r = audiorecorder(samplerate, bitdepth, 1);
record(r);

while 1
    [keyIsDown,secs,keyCode]=KbCheck;
    if (keyIsDown==1 && keyCode(stopKeyCode))
        break;
    end
    if keyCode(KbName('ENTER')) 
        sca; 
        stop(r);
        error('Pressed Enter'); 
    end;
    if exist('animate') && animate
        drawRecordAnimation(win,  GetSecs);
    end
end;

stop(r);
sounddata = getaudiodata(r, 'double');
duration = length(sounddata)/samplerate;

wavwrite(sounddata, samplerate, bitdepth, outputfilename);
