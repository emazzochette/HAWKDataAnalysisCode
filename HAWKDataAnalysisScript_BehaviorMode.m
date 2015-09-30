%% Worm Tracker Data Analysis Script - Behavior Mode Analysis
% This script brings in the data from the yaml file generated by HAWK and
% analysizes the data.
%
%  Copyright 2015 Eileen Mazzochette, et al <emazz86@stanford.edu>
%  This file is part of HAWK_Analysis_Methods.
%
%%%%%
clear all;
close all;
% Get Folder where all the files are:
clear all
if (ispc) %if on PC workstation in MERL 223
    DestinationFolder = 'C:\Users\HAWK\Documents\HAWKData';
    addpath(genpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\YAMLMatlab_0.4.3'));
    excelFile = 'C:\Users\HAWK\Dropbox\HAWK\HAWKExperimentLog.xls';
    addpath('C:\Users\HAWK\Documents\HAWKDataAnalysisCode\20130227_xlwrite');
    slash = '\';
    % For excel writing, need these files linked:
    % Initialisation of POI Libs
    % Add Java POI Libs to matlab javapath
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\poi-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\poi-ooxml-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\poi-ooxml-schemas-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\xmlbeans-2.3.0.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\dom4j-1.6.1.jar');
    javaaddpath('20130227_xlwrite\20130227_xlwrite\poi_library\stax-api-1.0.1.jar');
elseif (ismac) % if on Eileen's personal computer
    DestinationFolder = '/Volumes/home/HAWK Data/';
    addpath(genpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/YAMLMatlab_0.4.3'));
    excelFile = '/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/Experiments/Force Position Response Assay/DataDrop.xls';
    addpath('/Users/emazzochette/Documents/MicrosystemsResearch/HAWK/HAWKDataAnalysisCode/HAWKDataAnalysisCode/20130227_xlwrite');
    slash = '/';
    % For excel writing, need these files linked:
    % Initialisation of POI Libs
    % Add Java POI Libs to matlab javapath
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/poi-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/poi-ooxml-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/poi-ooxml-schemas-3.8-20120326.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/xmlbeans-2.3.0.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/dom4j-1.6.1.jar');
    javaaddpath('20130227_xlwrite/20130227_xlwrite/poi_library/stax-api-1.0.1.jar');
end

%asks user for the directory where all the files are:
%directory = uigetdir(DestinationFolder,'Choose the folder where the data if located');
directories = uipickfiles( 'FilterSpec',DestinationFolder);
fileID = fopen('/Users/emazzochette/Desktop/ErrorList.txt','a');



for dir = 1:length(directories)
    %Select next directory:
    directoryCell = directories(:,dir);
    directory = directoryCell{1};
    
    %determine experiment title based on file name:
    experimentTitle = getExperimentTitle(directory);
     try
        TrackingData = getTrackingDataFromYAML(directory,experimentTitle);
        StimulusData = getStimulusDataFromYAML(directory,experimentTitle);
         load(fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat')));
%        [Stimulus, numStims, TrackingData] = extractBehaviorDataFromTracking(TrackingData);
%        save(fullfile(directory,strcat(experimentTitle,'_tracking_parsedData.mat')),'TrackingData');
        if TrackingData.NumberOfStimulus > 0
            Stimulus = getTimingData(Stimulus,TrackingData.NumberOfStimulus, TrackingData);
            Stimulus = determineStimulusTimingBehavior(Stimulus,TrackingData.NumberOfStimulus);
            Stimulus = calculateBodyMorphology(Stimulus,TrackingData.NumberOfStimulus);
            Stimulus = filterFramesByBodyLength(Stimulus,TrackingData.NumberOfStimulus);
            Stimulus = calculateWormCentroidMean(Stimulus,TrackingData.NumberOfStimulus);
            Stimulus = calculateSmoothFitSkeleton(Stimulus, TrackingData.NumberOfStimulus);
            Stimulus = filterFramesByBodyLength(Stimulus,TrackingData.NumberOfStimulus);
            Stimulus = sortFramesBasedOnStimulus(Stimulus, TrackingData.NumberOfStimulus);
            Stimulus = findCurvature(Stimulus, TrackingData.NumberOfStimulus);
            Stimulus = scoreFrames(Stimulus, TrackingData.NumberOfStimulus);
            Stimulus = determineWormTrajectory(Stimulus, TrackingData.NumberOfStimulus);
            Stimulus = getVelocityFromCurvature(Stimulus, TrackingData.NumberOfStimulus);   
            Stimulus = spatialResolutionBehaviorExperiment(directory, Stimulus, TrackingData, TrackingData.NumberOfStimulus, true);
            Stimulus = getBehaviorVelocityStatistics(Stimulus, TrackingData.NumberOfStimulus);
            plotDataBehavior(Stimulus, TrackingData, TrackingData.NumberOfStimulus, directory);
            plotTrackData(Stimulus, TrackingData.NumberOfStimulus, directory);
            save(fullfile(directory,strcat(experimentTitle,'_DataByStimulus.mat')),'Stimulus');
        end
    catch
        disp(strcat('Error with: ',experimentTitle));
        fprintf(fileID,'%s\n',experimentTitle);
    end
end
fclose(fileID);

