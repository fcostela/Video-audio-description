function playClip(filename)
% Function to quickly try playing a movie clip, with the outdated
% playMovieFromFile.
% 
% Usage: playClip(filename)

videoRoot = '/Volumes/pelilab/Projects/Watching TV with LV/video segments/30s segments';  

whichScreen=max(Screen('Screens'));  % display on experimental screen
[win winRect] = Screen('OpenWindow', whichScreen, 0);  
playMovieFromFile(win,'/Users/danielsaunders/Blur experiment/BATM_6a.mov')% [videoRoot filesep filename '.mov']);
Screen( 'CloseAll');          
