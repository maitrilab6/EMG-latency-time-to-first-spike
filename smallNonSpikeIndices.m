function smallSpIdx = smallNonSpikeIndices(spikes, prcAmpThresh)


    ampRange = range(spikes, 2); %max(spikes, [],2) - min(spikes, [],2);
    
    smallSignalThresh = prctile(ampRange, prcAmpThresh);
    smallSpIdx = find(ampRange < smallSignalThresh);

end