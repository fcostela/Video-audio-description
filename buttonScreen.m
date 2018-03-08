function selection = buttonScreen(win, message, labels)
% Draw buttons on the screen horizontally, along with a prompt and labels
% inside. Buttons can be activated by clicking or pressing the
% corresponding number key.
%
% INPUT
%   win     An open window to draw to.
%   message The prompt to appear above the buttons.
%   labels  Cell array of strings for the button labels, also specifies the
%           number of buttons.
%
% OUTPUT
%  selection Number from 1-numButtons about which one was selected.
%
% Usage: selection = buttonScreen(win, message, labels)

numButtons = length(labels);

bgColor = [255 255 255]; % white
fontColor = [0 0 0]; % black
if ~exist('fontSize')
    promptFontSize = 45;%45;%90;
end
wrapat = 60;%40;%80;
font = 'Helvetica';
upperPlacement = 0.2; % Proportion of screen height
lowerPlacement = 0.85;
screenBounds = Screen(win,'Rect');

Screen('TextFont',win, font);
Screen('TextStyle', win, 1); % Bold
Screen('FillRect',win, bgColor);
Screen('TextSize',win, promptFontSize);
[nx, ny, textbounds] = DrawFormattedText(win, message, 'center', screenBounds(4)*upperPlacement, fontColor, wrapat);

buttonDiameter = 450;%350;%450;
buttonSpacing = 30;%15;%30;
c = CenterRect([0 0 ((numButtons-1)*buttonDiameter)+((numButtons-1)*buttonSpacing) 0], screenBounds);
buttonCenters(1,:) = linspace(c(1),c(3),numButtons);
buttonCenters(2,:) = textbounds(4)+buttonDiameter/2 + 50; %100;
captionCenters(1,:) = buttonCenters(1,:);
captionCenters(2,:) = buttonCenters(2,:) + buttonDiameter/2 + 35; %75;
buttonDepressed = zeros(numButtons,1);

ShowCursor('Arrow');
ListenChar(2);
selection=[];
while 1
    Screen('TextSize',win, promptFontSize);
    DrawFormattedText(win, message, 'center', screenBounds(4)*upperPlacement, fontColor, wrapat);
    Screen('TextSize',win, promptFontSize*0.8);
    DrawFormattedText(win, 'Click con el ratón o pulsa 1 (sí) o 2 (no) y luego espacio', 'center', screenBounds(4)*lowerPlacement, fontColor, wrapat);
    
    for i = 1:numButtons
        drawButton(win, buttonDepressed(i), buttonCenters(:,i), buttonDiameter, labels{i});
        Screen('TextSize',win, 90);%100
        drawTextCenteredOnPoint(win,num2str(i),captionCenters(:,i));
    end
    
    
    Screen('Flip', win);
    [x, y, buttons]=GetMouse;
    [k, t, keyCode] = KbCheck;
    if keyCode(KbName('Delete')) %|| keyCode(KbName('DeleteForward')) 
        error('Pressed delete to exit'); 
    end;
    if keyCode(KbName('Space'))
        if selection
            break;
        end
    end
    if k
        numberPressed  = keycodeToNumber(find(keyCode));
        if numberPressed
            if (numberPressed <= numButtons)
                buttonDepressed = zeros(numButtons,1);
                buttonDepressed(numberPressed) = true;
                selection = numberPressed;
            end
        end
    end
    if any(buttons)
        for i = 1:numButtons
            if mouseInButton(buttonCenters(:,i), buttonDiameter, x, y)
                buttonDepressed = zeros(numButtons,1);
                buttonDepressed(i) = true;
                selection = i;
            end
        end
    end
end
ListenChar(0);
