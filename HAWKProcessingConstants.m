
% Parameters for determining the 
%Percentage of body length average to use as threshold for filtering
%frames.
BODY_LENGTH_PERCENT_THRESHOLD = 0.85;
PHASE_SHIFT_RESIDUAL_LIMIT = 10^-2;
WIDTH_AT_TARGET_LIMIT = 125;
FRAME_SCORE_THRESHOLD = 1;
metricWeights = [0.6; 0.8; 1];%; 0.6];

%Trial scoring parameters:
DROPPED_FRAMES_DURING_STIMULUS = 5;
PERCENT_DOWN_BODY_DIFFERENCE = 10;
PERCENT_ACROSS_BODY_DIFFERENCE = 25;


%Number of points to use for spline in curvature determination:
NUMCURVPTS = 50;
%How much to filter the skeleton before fitting the smooth spline:
CURVATURE_FILTERING_SIGMA = 1;

%The different in speed to determine changes in response.
SPEED_THRESHOLD_PAUSE = 0.3;
SPEED_THRESHOLD_SPEEDUP = 1.2;
POST_STIM_FRAMES = 12;