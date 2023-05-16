function plotSpikes(filteredData, t, samplingRate, spStart, spStop, plotTitle)
    
    % figure;
    plot(t, filteredData, 'k', 'LineWidth', 0.2);
    hold on;

    for i = 1:length(spStart)
        plot(t(spStart(i) : spStop(i)), filteredData(spStart(i) : spStop(i)), 'LineWidth', 1.5);
    end
%     xlabel('Time (s)');
%     ylabel('Voltage (ms)');
%     title(plotTitle);
    

end