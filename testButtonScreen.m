% Quick script to test the buttonScreen function.
%
% Usage: testButtonScreen

Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'Verbosity', 2); 
KbName('UnifyKeyNames');

% Open a graphics window on the main screen
whichScreen=max(Screen('Screens') );       
win = Screen('OpenWindow', whichScreen, 0);
rect = Screen('Rect',win); 
try 
 
 %   drawButton(win, true ,  [(rect(1)+rect(3))/2 (rect(2)+rect(4))/2], 200, 'Very  ','interested ' );
     selection = buttonScreen(win, 'Have you seen this movie before?',      {'Yes','No'});
%     selection = buttonScreen(win, 'How interested are you in seeing this movie?', {'Not interested','A little interested','Moderately interested','Interested','Very interested'});
sca;

ListenChar(2); while KbCheck; end; ListenChar(0);  % Code to make sure the keyboard is released before we continue
 
catch myerr
    sca;
    ListenChar(0);
    commandwindow;
    disp(sprintf('ERROR: %s', myerr. message));
    for i = 1:length(myerr.stack) 
        disp(sprintf('File %s Line %d', myerr.stack(i).file, myerr.stack(i).line));
    end 
end %try..catch.
