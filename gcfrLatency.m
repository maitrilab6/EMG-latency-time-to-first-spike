function [latency, timeAtThresh] = gcfrLatency(stimulus, stimThresh, samplingRate, gcfr, threshold, minLatency)

% [~, peakIdx] = max(stimulus);
% [~, troughIdx] = min(stimulus);
% 
% stimInd = min([peakIdx troughIdx]);
% stimulusOnTime = t(stimInd);

stimInd = find(stimulus > stimThresh, 1, 'first');
stimulusOnTime = stimInd/samplingRate;

% Find where Amplitude first exceeds threshold:
locsAboveThresh = find(gcfr > threshold);

% Get time at that y value:
ind = find(locsAboveThresh > stimInd + minLatency*samplingRate, 1,'first'); % Gets first index after stimulus
timeAtThresh = locsAboveThresh(ind)/samplingRate;

latency = ((timeAtThresh)-stimulusOnTime)*1000; 

end