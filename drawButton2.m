function drawButton2(win, highlighted, center, diameter, label)

buttonColor = [0 0 0];
if highlighted
    fontColor = [255 255 255];
else
    fontColor = [0 0 0];
end
wrapat = 10;
linespacing = 15;
wrappedlabel = WrapString(label,wrapat);
numlines = length(find(wrappedlabel == sprintf('\n'))) + 1;
% if length(wrappedlabel) < 5
%     fontSize = 85;
% else
%     fontSize = 60;
% end
fontSize = 40;
font = 'Helvetica';
Screen('TextFont',win, font);
Screen('TextSize',win, fontSize);
Screen('TextStyle', win, 1); % Bold
% realbounds = bounds;
% if exist('line2')
%     realbounds(4) = realbounds(4)*2 + linespacing;
% end

outerCircle = [center(1)-diameter/2 center(2)-diameter/2 center(1)+diameter/2 center(2)+diameter/2];
Screen('FillOval', win, buttonColor, outerCircle);
innerBackground = InsetRect(outerCircle, 0.04*diameter, 0.04*diameter);
Screen('FillOval', win, [255 255 255], innerBackground);

if highlighted
    innerCircle = InsetRect(innerBackground, 0.01*diameter, 0.01*diameter);
    Screen('FillOval', win, [0 0 0], innerCircle);
end

totalbounds = Screen('TextBounds',win,wrappedlabel);
totalbounds(4) = totalbounds(4) * numlines +(numlines-1)*linespacing;
c = CenterRectOnPoint(totalbounds,center(1),center(2));
sy = c(2);

textlines = textscan(wrappedlabel,'%s','whitespace','\n');
for i = 1:numlines
    a = textlines{1}; a = a{i};
    linebounds = Screen('TextBounds',win,a);
    c = CenterRectOnPoint(linebounds,center(1),center(2));
    sx = c(1);
    DrawFormattedText(win, a, sx, sy, fontColor, wrapat);
    
    lineheight = linebounds(4);
    sy = sy + lineheight+linespacing;
end
