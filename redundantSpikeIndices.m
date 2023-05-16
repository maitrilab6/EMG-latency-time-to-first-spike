function redundantSpIdx = redundantSpikeIndices(spikes, spStart, spStop, overlapThresh)

overlaps = nan(length(spStart),length(spStart));
redundantSpIdx = [];

for i = 1:length(spStart)-1
    for j = i+1:length(spStart)
        intersectSegment = intersect(spStart(i):spStop(i), spStart(j):spStop(j));
        totalRange = min([spStart(i), spStart(j)]) : max([spStop(i), spStop(j)]);
        overlaps(i,j) = length(intersectSegment)*100/length(totalRange);

        if overlaps(i,j) > overlapThresh
            % if max(spikes(i,:)) >= max(spikes(j,:)) 
            if range(spikes(i,:)) >= range(spikes(j,:)) 
                redundantSpIdx = [redundantSpIdx j];
            else
                redundantSpIdx = [redundantSpIdx i];
            end
        end
    end
end

end
