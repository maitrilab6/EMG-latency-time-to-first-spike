function [spStart, spStop] = findSpikes(filteredData, spikeTempIdx, prcDistThresh, prcAmpThresh)
% FINDSPIKES finds spikes using spike templates
    
    spikeType = filteredData(str2num(spikeTempIdx));
    % Finding distances with low threshold 
    [~,~, dist] = findsignal(filteredData, spikeType, 'TimeAlignment','dtw',"MaxDistance",1, "Normalization","center");

    % Percentile threshold
    maxDistVal = prctile(dist,prcDistThresh);

%     figure;
%     findsignal(filteredData, spikeType, 'TimeAlignment','dtw',"MaxDistance", maxDistVal, "Normalization","center");
%     title('Matches with spikeType');
%     xlabel('samples');

    [spStart,spStop, ~] = findsignal(filteredData, spikeType, 'TimeAlignment','dtw',"MaxDistance",maxDistVal, "Normalization","center"); 

    for i = 1:length(spStart)
        ampRange(i) = range(filteredData(spStart(i):spStop(i)));
    end
    
%     smallSignalThresh = prctile(ampRange, prcAmpThresh);
%     smallSpIdx = find(ampRange < smallSignalThresh);
    
    smallSpIdx = find(ampRange < 0.25*max(ampRange));
    
    spStart(smallSpIdx) = [];
    spStop(smallSpIdx) = [];

end