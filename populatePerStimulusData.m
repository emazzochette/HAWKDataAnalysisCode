function [data, firstColumn] = populatePerStimulusData( Stimulus, titles, numStims)
    firstColumn = strmatch('Stimulus Number',titles,'exact');
   
    
    for stim = 1:numStims
        time = Stimulus(stim).timeData(1,[1:6]);
        data(stim, strmatch('Stimulus First Frame Time',titles,'exact')-firstColumn+1) = Stimulus(stim).firstFrameTime;
        data(stim, strmatch('Stimulus Approach On Time',titles,'exact')-firstColumn+1) = Stimulus(stim).approachStartTime;
        data(stim, strmatch('Stimulus Start Time',titles,'exact')-firstColumn+1) = Stimulus(stim).stimOnStartTime;
        data(stim, strmatch('Stimulus End Time',titles,'exact')-firstColumn+1) = Stimulus(stim).stimEndTime;
        data(stim, strmatch('Stimulus Number',titles,'exact')-firstColumn+1) = stim;
        data(stim, strmatch('Average Body length (um)', titles, 'exact')-firstColumn+1) = Stimulus(stim).averageBodyLengthGoodFrames;
        data(stim, strmatch('STD Body Length', titles, 'exact')-firstColumn+1) = Stimulus(stim).stdBodyLengthGoodFrames;
        
    end
   
    
end


	

