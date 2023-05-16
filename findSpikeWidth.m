function spikeWidth = findSpikeWidth(spike, samplingRate)

crossingIdx = [];
peak = max(spike);
trough = min(spike);

if abs(peak) > abs(trough)
    halfMax = peak/2;
else
    halfMax = trough + abs(trough/2);
end

for i=1:length(spike)-1
    if (spike(i)<halfMax & spike(i+1) >= halfMax | spike(i)>=halfMax & spike(i+1)< halfMax)
        crossingIdx = [crossingIdx i];
    end
end

spikeWidth = abs(crossingIdx(1) - crossingIdx(2))/samplingRate;

end