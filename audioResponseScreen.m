function duration = audioResponseScreen(win, message, outputfilename, fontSize)
% Function to prompt the participant, and have them record by pressing the space bar,
% pressing it again to finish (and terminate the function), with a little
% animation while it's recording.
% 
% INPUT
%  win      An open window to draw to.
%  message  String to put at the top of the screen.
%  outputfilename   File to record the sound data to (will be a .wav)
%  fontSize Font size of the prompt and 
%
% OUTPUT
%  duration Length of the recording in seconds.
%
% Usage: duration = audioResponseScreen(win, message, outputfilename,fontSize)

% Setup stuff
bgColor = [255 255 255]; % white
fontColor = [0 0 0]; % black
samplerate = 22050;
bitdepth = 16;
if ~exist('fontSize')
    fontSize = 50; % former size 70;
end
wrapat = 55; %%80;
font = 'Helvetica';
Screen('TextFont',win, font);
Screen('TextSize',win, fontSize);
Screen('FillRect',win, bgColor);
beginMessage = sprintf('%s\n\nPresiona espacio para comenzar.',message);

% Draw the initial prompt screen
DrawFormattedText(win, beginMessage, 'center', 'center', fontColor, wrapat);
drawRecordAnimation(win,  0,[0 0 0]);
Screen('Flip', win);

% Code to make sure the keyboard is released before we continue
ListenChar(2); while KbCheck; end; ListenChar(0); 

% Wait for the spacebar to be pressed (or Delete to exit)
while 1
   [keyIsDown,secs,keyCode]=KbCheck;
   if (keyIsDown==1 && keyCode(KbName('SPACE')))
        break;
    end
    if keyCode(KbName('Delete')) %|| keyCode(KbName('DeleteForward')) 
        error('Pressed delete to exit'); 
    end;
end

% Now start the recording and the animation, and go until space bar
drawRecordAnimation(win,  0);
DrawFormattedText(win, beginMessage, 'center', 'center', fontColor, wrapat);
Screen('Flip', win);
ListenChar(2); while KbCheck; end; ListenChar(0);  % Code to make sure the keyboard is released before we continue
r = audiorecorder(samplerate, bitdepth, 1);
record(r);
t = GetSecs;
while 1
    endMessage = sprintf('%s\n\nGrabando. Presiona espacio para terminar.',message);
    DrawFormattedText(win, endMessage, 'center', 'center', fontColor, wrapat);
    drawRecordAnimation(win,  GetSecs-t);
    Screen('Flip', win);
    [keyIsDown,secs,keyCode]=KbCheck;
    if ((keyIsDown==1) && (keyCode(KbName('SPACE')) && ((GetSecs - t) > 1)))
        break;
    end
    if keyCode(KbName('Delete')) %|| keyCode(KbName('DeleteForward')) 
        sca; 
        stop(r);
        error('Pressed delete to exit'); 
    end;
end;

% Finish the sound recording and write out the data.
stop(r);
sounddata = getaudiodata(r, 'double');
wavwrite(sounddata, samplerate, bitdepth, outputfilename);

duration = length(sounddata)/samplerate;