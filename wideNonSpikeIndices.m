function wideSpikeIdx = wideNonSpikeIndices(spikeLength, spikes, maxWidth, minWidth, samplingRate)
    
    nspikes = size(spikes,1);
    [~, peakIdx] = max(spikes, [], 2);
    [~, troughIdx] = min(spikes, [], 2);
    % spikeWidth = nan(nspikes,1);
    spikeWidth = abs(peakIdx - troughIdx)/samplingRate;
    % for i = 1: nspikes
    %     i
    %     spikeWidth(i) = findSpikeWidth(spikes(i,:), samplingRate); 
    % end

    wideSpikeIdx = find(spikeWidth > maxWidth | spikeLength/samplingRate < minWidth);
    
end