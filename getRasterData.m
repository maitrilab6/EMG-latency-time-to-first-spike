function [raster, spLocs] = getRasterData(spikes, spStart, trialLength)

spLocs = [];
[peak,spikePeakLoc] = max(spikes,[],2);
[trough,spikeTroughLoc] = min(spikes,[],2);
% for ispike = 1 : length(spStart)
%     spLocs(ispike) = spStart(ispike) + min([spikePeakLoc(ispike) spikeTroughLoc(ispike)]) + round(0.5 * abs(spikePeakLoc(ispike) - spikeTroughLoc(ispike)));
% end

for ispike = 1 : length(spStart)
    if abs(peak(ispike)) >= abs(trough(ispike))
        spLocs(ispike) = spStart(ispike) + spikePeakLoc(ispike);
    else
        spLocs(ispike) = spStart(ispike) + spikeTroughLoc(ispike);
    end
end

raster = zeros(1,trialLength);
raster(spLocs) = 1;

end