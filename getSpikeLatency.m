function [spikeLatency, firstSpikeLoc, stimulusOnTime] = getSpikeLatency(stimulus, stimThresh, samplingRate, spLocs, minLatency)
% [~, peakIdx] = max(stimulus);
% [~, troughIdx] = min(stimulus);

% stimInd = 2*samplingRate +min([peakIdx troughIdx]);

stimInd = find(stimulus > stimThresh, 1, 'first');
stimulusOnTime = stimInd/samplingRate;

% spLocs = find(raster);
idx = find(spLocs > (stimInd + minLatency*samplingRate), 1,"first");
firstSpikeLoc = spLocs(idx)/samplingRate;
spikeLatency = firstSpikeLoc - stimulusOnTime;

end