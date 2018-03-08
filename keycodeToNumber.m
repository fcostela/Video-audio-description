function answer = keycodeToNumber(keycode)
% Utility function to get the number key that's being pressed.
%
% INPUT
%  keycode  Psychtoolbox keycode structure, e.g. as returned from kbcheck
%
% OUTPUT
%  answer   The number if a number key was pressed, or [] if no number key
%           (or more than 1)
%
% Usage: answer = keycodeToNumber(keycode)

answer = [];
if (length(keycode) == 1)
    if (keycode >= KbName('1!')) && (keycode <= KbName('9('))
        answer = keycode - KbName('1!') + 1;
    end
    if (keycode >= KbName('1')) && (keycode <= KbName('9'))
        answer = keycode - KbName('1') + 1;
    end
end
