% #define STARTBLINK 3 // pupil disappeared, time only
% #define ENDBLINK 4 // pupil reappeared, duration data
% #define STARTSACC 5 // start of saccade, time only
% #define ENDSACC 6 // end of saccade, summary data
% #define STARTFIX 7 // start of fixation, time only
% #define ENDFIX 8 // end of fixation, summary data
% #define FIXUPDATE 9 // update within fixation, summary data for interval
% #define MESSAGEEVENT 24 // user-definable text: IMESSAGE structure
% #define BUTTONEVENT 25 // button state change: IOEVENT structure
% #define INPUTEVENT 28 // change of input port: IOEVENT structure
% #define LOST_DATA_EVENT 0x3F // NEW: Event flags gap in data stream
i = eyelink_get_next_data(NULL); // Checks for new data itemswitch(i){case SAMPLE_TYPE
 // PROCESS PLAYBACK DATA FROM LINKi = eyelink_get_next_data(NULL); // check for new data itemif(i==0) // 0: no new data{ // Check if playback has completedif((eyelink_current_mode() & IN_PLAYBACK_MODE)==0) break;}