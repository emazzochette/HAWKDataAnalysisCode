%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_AnalysisMethods.

function cutoff = isWormCutOff(skeleton)
    HAWKSystemConstants;
    % is a portion of the body's body outside of the frame?

    head.x = skeleton.x(1);
    head.y = skeleton.y(1);
    tail.x = skeleton.x(end);
    tail.y = skeleton.y(end);

    xBounds = [0+5 IMAGE_WIDTH_PIXELS-5];
    yBounds = [0+5 IMAGE_HEIGHT_PIXELS-5];

    %Check head
    if (head.x < xBounds(1) || ...
            head.x > xBounds(2) )
        cutoff = find(diff(skeleton.x)~=00,1,'first');

    elseif (head.y < yBounds(1) || ...
            head.y > yBounds(2) )        
        cutoff = find(diff(skeleton.y)~=00,1,'first');
    %Check tail
    elseif (tail.x < xBounds(1) || ...
            tail.x > xBounds(2))
        cutoff = -find(diff(fliplr(skeleton.x))~=00,1,'first');
    elseif (tail.y < yBounds(1) || ...
            tail.y > yBounds(2) )
        cutoff = -find(diff(fliplr(skeleton.y))~=00,1,'first');
    %Else return 0
    else
       cutoff = 0; 
    end
    %What does the function return?
    % 0 = no body outside of the frame
    % -1 = tail outside of frame
    % 1 = head outside of frame
    
end