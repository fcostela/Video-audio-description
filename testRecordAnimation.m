% Little script for if you want to play around with the tape recorder
% animation of iaInhouse.
%
% Usage: testRecordAnimation

whichScreen=max(Screen('Screens'));  % display on experimental screen
[win winRect] = Screen('OpenWindow', whichScreen, 0);  
Screen('FillRect',win,[255 255 255]);

t = GetSecs;
for i = 1:150
    drawRecordAnimation(win,  GetSecs-t);
    Screen('Flip',win);
end
KbWait;
Screen( 'CloseAll');          
        