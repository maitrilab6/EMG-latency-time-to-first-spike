function [promSpikeLatency, promSpikeLoc, stimulusOnTime] = getPromSpikeLatency(stimulus, stimThresh, samplingRate, spLocs, minLatency, spikes, spStop)
    
    % [~,idx] = sort(spStop, 'ascend');
    % spikesSorted = spikes(idx,:);

    stimInd = find(stimulus > stimThresh, 1, 'first');
    stimulusOnTime = stimInd/samplingRate;
    % locs = find(raster);

    try
        lastBaselineSpikeLoc = find(spLocs < stimInd, 1, "last");
        maxBaselineSpikeAmp = max(range(spikes(1:lastBaselineSpikeLoc,:),2));
        

        allSpikesAmp = range(spikes,2);
        largeSpIdx = allSpikesAmp > maxBaselineSpikeAmp;
        largeSpLocs = spLocs(largeSpIdx);
        promSpikeLoc = largeSpLocs(find(largeSpLocs > stimInd + minLatency*samplingRate, 1, "first"))/samplingRate;
        promSpikeLatency = promSpikeLoc - stimulusOnTime;

    catch
        [spikeLatency, firstSpikeLoc, stimulusOnTime] = getSpikeLatency(stimulus, stimThresh, samplingRate, spLocs, minLatency);
        promSpikeLatency = spikeLatency;
        promSpikeLoc = firstSpikeLoc;
    end

    



end