
%%%% Function: Score Behavior Responses
%  This function looks at the velocity of the worm before and after the
%  stimulus begin and determines the type of response. It adds a struct to
%  that includes a string specifying the type of response, the
%  response latency defined as the difference between the time the stimulus
%  was applied and the time of the frame in which the response began. The
%  structure also includes the average speed in the frames before the
%  stimulus and the 12 frames after the stimulus. 
%
%  A reversal is detected first by checking for a change in direction. If a
%  change in direction is not found, we then compare the pre stimulus speed
%  with the post stimulus speed, averaged over about 12 frames on either
%  side of the stimulus start time. 
%
%  param {Stimulus} struct,  contains experiment data organized by
%  stimulus
%  param {numStims} int, the number of stimulus in this experiment.
%
%  returns {Stimulus} struct,  contains experiment data organized by
%  stimulus including the determined response.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.
%  This method is compilation of adapted methods written by C. Fang-Yen and A.
%  Leifer. 
%%%%%

function Stimulus = scoreBehaviorResponse(Stimulus, numStims)
    
    HAWKProcessingConstants;
    for stim = 1:numStims
        speed = Stimulus(stim).velocity.speed;
        speed_smoothed = lowpass1D(speed,2);
        direction_smoothed = sign(speed_smoothed);
        direction = Stimulus(stim).velocity.direction;
        preStimCount= length(Stimulus(stim).FramesByStimulus.PreStimFrames);
        
        stimOnFrame =  find(Stimulus(stim).timeData(:,8)>Stimulus(stim).StimulusTiming.stimOnStartTime,1)-1;

        frames = [Stimulus(stim).FramesByStimulus.PreStimFrames(preStimCount-10:preStimCount),...
            Stimulus(stim).FramesByStimulus.DuringStimFrames, ...
            Stimulus(stim).FramesByStimulus.PostStimFrames(1:20)];
        
%        %Determine if there's a change in direction:
%         ind = find(diff(direction_smoothed(frames))~=0)+1+frames(1);
%         if(length(ind) ~=0 &&( length(ind) == 1 || ind(2)-ind(1)>5))
%            
%             deltaDirection = true;
%             reversalFrame = find(diff(direction(ind(1)-5:ind(1)+5))~=0,1)-5+ind(1)+1;
%             latency = Stimulus(stim).timeData(reversalFrame,8)-Stimulus(stim).StimulusTiming.stimOnStartTime;
% %         
%         else
%             
%             deltaDirection = false;
%             reversalFrame = 0;
%             latency = 0;
%         end
%         
        %determine speed delta
        preStimAveSpeed = nanmean(speed(frames(1)-1 + find(frames<=stimOnFrame-1)) ); 
        postStimAveSpeed = nanmean(speed(frames(1)-1 + find(frames>=stimOnFrame,POST_STIM_FRAMES)) ); 
        postStimAcceleration = diff(speed(find(frames>=stimOnFrame+1,POST_STIM_FRAMES)));
        
        if sign(preStimAveSpeed) ~= sign(postStimAveSpeed)
            deltaDirection = true;
        else
            deltaDirection = false;
        end
        
        if ( abs(postStimAveSpeed) < abs(preStimAveSpeed)*(SPEED_THRESHOLD_PAUSE))
            deltaSpeed = -1;
        elseif  (abs(postStimAveSpeed) > abs(preStimAveSpeed)*(SPEED_THRESHOLD_SPEEDUP))
            deltaSpeed = 1;
        else
            deltaSpeed = 0;
        end
            
        
        stimOnFrames = find(Stimulus(stim).StimulusActivity(frames)==1);
        figure(stim);
        subplot(211), plot(frames,speed(frames),'LineStyle',':','LineWidth',6, 'Color','b','Marker','none');
        hold on
        plot(frames,speed_smoothed(frames),'LineStyle','-','LineWidth',6, 'Color','r','Marker','none');
        legend('Speed','Smoothed Speed','Location','SouthEast');
        title('Signed speed of worm during stimulus','FontSize', 24)
        xlabel('Frame','FontSize', 20)
        ylabel('Speed','FontSize', 20)
%         axis([0 60 -Inf Inf])
        subplot(212), plot(frames,direction(frames),'LineStyle',':','LineWidth',6, 'Color','b','Marker','none');
         hold on
        plot(frames,direction_smoothed(frames),'LineStyle','-','LineWidth',6, 'Color','r','Marker','none');
        plot(frames(stimOnFrames),ones(size(stimOnFrames)).*1.3,'LineStyle','-','LineWidth',6, 'Color','g','Marker','none')
        axis([-Inf Inf -1.5 1.5])
        legend('Velocity Direction','Smoothed Velocity Direction','Stimulus On','Location','SouthEast');
        title('Direction of worm during stimulus','FontSize', 24)
        xlabel('Frame','FontSize', 20)
        ylabel('Direction (binary)','FontSize', 20)
        
        
        if (deltaDirection == 1)
            responseType = 'reversal';
%             reversalFrame(stim) = find(diff(direction(ind(1)-5:ind(1)+5))~=0,1)-5+ind(1)+1;
%             latency(stim) = Stimulus(stim).timeData(reversalFrame(stim),8)-Stimulus(stim).StimulusTiming.stimOnStartTime;     
            latency = 0;
        elseif (deltaSpeed == 0)
            responseType = 'none';
            latency = 0;
        elseif (deltaSpeed == -1)
            responseType = 'pause';
            latency = 0;

        elseif (deltaSpeed == 1)
            responseType = 'speedup';
            latency = 0;
        else 
            responseType = 'unknown';
            latency = 0;
        end
        
        Stimulus(stim).Response.Type = responseType;
        Stimulus(stim).Response.Latency = latency;
        Stimulus(stim).Response.preStimSpeed = preStimAveSpeed;
        Stimulus(stim).Response.postStimSpeed = postStimAveSpeed;
        Stimulus(stim).Response.postStimAcceleration = postStimAcceleration;
    end
end