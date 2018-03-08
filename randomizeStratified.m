function stimulusOrder = randomizeStratified(numParticipants, stimuliPerParticipant, categoryIndices)

% Random stratification program.
%
% Outputs a 2d array of integers of the form (participant i, stimulus to
% display on trial j).
%
%   numParticipants: Total number of participants. Note that it does not
%       need information about the participant groups.
%   stimuliPerParticipant: Number of videos or whatnot that will be viewed
%       by a participant over the course of their involvement.
%   categoryIndices: Cell array where each entry represents the indices of
%       a particular category of stimulus.
%   
% Note: numStimuli, the total number of stimuli, will be computed by adding
% up the number of items in each of the categoryIndices entries.
%
% Ideally these should be true:
% - numParticipants is a multiple of numStimuli/stimuliPerParticipant, and 
% so is the number of participants in a particular group 
% - numStimuli is a multiple of stimuliPerParticipant (and therefore 
% larger than it)
% - The number of stimuli in each category is a multiple of
% numStimuli/stimuliPerParticipant
%
% If they are, than this randomization procedure guarantees:
% 1 Every stimulus will be seen the same number of times
% 2 No individual sees the same stimulus more than once
% 3 Every participant sees the same proportion of each category of stimulus
% 4 Consequently, every group of participants will see the same proportion of each
% category of stimulus
% 5 Within every group every stimulus will be seen the same number of
% times.
%
% Example: numParticipants = 8, stimuliPerParticipant = 5, categoryIndices
% = {1:6,7:10} (so that numstimuli = 10 and numStimuli/stimuliPerParticipants = 2)
% and let's say participants 1-6 are in one group and 7-8 in another.
%
% IF it is desired to just generate a random session for one person, for
% instance if someone is added at the last minute, then this can be run
% with a greater numParticipants than is intended, and just the first row
% used. Guarantees 1 and 5 cannot be affirmed under these conditions, but
% guarantees 2-4 will be, and the collection of stimuli will be a
% proportional random sample. 
%
% USAGE: stimulusOrder = randomizeStratified(numParticipants, stimuliPerParticipant, categoryIndices)

numStimuli = 0;
for i = 1:length(categoryIndices)
    numStimuli = numStimuli + length(categoryIndices{i});
end

participantsPerStimuli = (numParticipants*stimuliPerParticipant)/numStimuli;
stimulusOrder = [];
for i = 1:participantsPerStimuli
    a = [];
    for j = 1:length(categoryIndices)
        b = categoryIndices{j};
        b = shuffle(b);
        a = cat(2, a, reshape(b,numStimuli/stimuliPerParticipant, length(b)/(numStimuli/stimuliPerParticipant)));
    end
    a = (shuffle(a'))';
    stimulusOrder = cat(1,stimulusOrder, a);
end
