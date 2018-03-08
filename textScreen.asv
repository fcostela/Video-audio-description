function textScreen(win, message, fontSize, waitforkey)
% Show a blank screen with a message in the middle, until any key is pressed (if waitforkey is not 0).
% 
% INPUT
%  win      Open window to write to
%  message  Text to write
%  fontSize Size of text to write
%  waitforkey If 1, wait for a press of the space bar before dismissing.
%
% Usage: textScreen(win, message, fontSize, waitforkey)

bgColor = [255 255 255]; % white
fontColor = [0 0 0]; % black
if ~exist('fontSize')
    fontSize = 140;
end
wrapat = 35;
font = 'Helvetica';

Screen('TextFont',win, font);
Screen('TextSize',win, fontSize);
Screen('TextStyle', win, 1); % Bold

Screen('FillRect',win, bgColor);

if (exist('waitforkey')) && (waitforkey)
   % message = sprintf('%s\n\nPress space to continue.',message);
end

DrawFormattedText(win, message, 'center', 'center', fontColor, wrapat);

Screen('Flip', win);

WaitSecs(.1); 

if (exist('waitforkey')) && (waitforkey)
    ListenChar(2); while KbCheck; end; ListenChar(0);  % Code to make sure the keyboard is released before we continue
    
    [secs, keyCode, deltaSecs]=KbWait;
    if keyCode(KbName('Delete'))%|| keyCode(KbName('DeleteForward'))
        sca;
        error('Pressed Delete to exit');
    end;
    while KbCheck; end;
    FlushEvents('keyDown');
end
