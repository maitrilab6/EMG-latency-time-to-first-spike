function [stimulus, filteredResponse, spStart, spStop, raster, promSpikeLoc, promSpikeLatency] = EMGanalysis(muscleID, mothID, trialID, rowID)

% stimDataset = [];
% respDataset = [];
% rasterDataset = [];
% % gcfrDataset = [];
% latencyDataset = [];
% templatesDataset = [];dis
% spStartDataset = [];
% spStopDataset = [];

% Analysis Pipeline

% muscleID  = "Axillary";
% mothID = "M2"; % Update moth ID for every new moth
% trialID = "T1"; %Update the trial number every trial
writeFlag = 0; % = 1 to write 3 trial datasets into hdf5 file
prcDistThresh = 50;
prcAmpThresh = 50; % doens't matter
maxWidth = 0.007; % 7 ms spike width
minWidth = 0.002; % 2 ms
overlapThresh = 5;
stimThresh = 0.02;
minLatency = 0.005; % 5 ms
gauss_win_L = 0.05; %500 ms
gauss_win_sigma = 0.01; % 50 ms
requiredTrialLength = 2.5;

%rowID = join([mothID trialID], "-");
tablePath = "spike templates_5.xlsx";
rawDataDir = "/Users/praveen/Documents/EMG for paper/EMG_wingmuscles_rawfiles/Raw files for analysis/Raw files_UpdatedSampleSize/";
filepath = join([rawDataDir "/" muscleID "/" mothID "/" rowID ".txt"], "")


[samplingRate, trialLength, spikeTempIdx, initOffDur, stimOnDur, nTrials] = loadParameters(rowID, tablePath);
[stimulus,response] = loadData(filepath, requiredTrialLength*samplingRate);

filteredResponse = filterData(response, samplingRate);

t=0:1/samplingRate:(length(response)/samplingRate);
t(end)=[];

% plotData(t,filteredResponse,"time (s)", "Voltage (mV)", replace(rowID, "_", " "));
% hold on;
% yyaxis right; plot(t,stimulus);



spStart = []; spStop = []; spikeLength = [];


for templateIdx = 1:length(spikeTempIdx)
    spikeTempIdx(templateIdx)
    [startIdx, stopIdx] = findSpikes(filteredResponse, spikeTempIdx(templateIdx), prcDistThresh, prcAmpThresh);
    spStart = [spStart; startIdx];
    spStop = [spStop; stopIdx];

end

[spStart,idx] = sort(spStart);
spStop = spStop(idx);

% figure;
% plotSpikes(filteredResponse, t, samplingRate, spStart, spStop, "All spikes");

spikeLength = spStop - spStart +1;
spikes = nan(length(spStart), max(spikeLength));
for i=1:length(spStart)
    spikes(i,1:spikeLength(i)) = filteredResponse(spStart(i):spStop(i));
end

wideSpikeIdx = wideNonSpikeIndices(spikeLength, spikes, maxWidth, minWidth, samplingRate);
% wideSpikeIdx = find(spikeLength > widthThresh | spikeLength < 30);
spStart(wideSpikeIdx) = [];
spStop(wideSpikeIdx) = [];
spikes(wideSpikeIdx, :) = [];

% smallSpIdx = smallNonSpikeIndices(spikes, prcAmpThresh);
% spStart(smallSpIdx) = [];
% spStop(smallSpIdx) = [];
% spikes(smallSpIdx,:) = [];
% figure;
% plotSpikes(filteredResponse, t, samplingRate, spStart, spStop, "After eliminating small spikes");

redundantSpIdx = redundantSpikeIndices(spikes, spStart, spStop, overlapThresh);
spStart(redundantSpIdx) = [];
spStop(redundantSpIdx) = [];
spikes(redundantSpIdx,:) = [];

[raster, spLocs] = getRasterData(spikes, spStart, trialLength);
nspikes = length(spLocs);

% Firing rate

% gcfr = getGCFR(gauss_win_L, gauss_win_sigma, raster, samplingRate);
% baselineFR = gcfr(1:initOffDur*samplingRate);
% threshold = 5*std(baselineFR) ;


% [latency, timeAtThresh] = gcfrLatency(stimulus, stimThresh, samplingRate, gcfr, threshold, minLatency);
% disp(join(['Time at threshold crossing = ' string(timeAtThresh) 's']));
% disp(join(['GCFR latency = ' string(latency) 'ms']));

% [spikeLatency, firstSpikeLoc, stimulusOnTime] = getSpikeLatency(stimulus, stimThresh, samplingRate, spLocs, minLatency);
% disp(join(['Time to first stimulus elicited spike = ' string(firstSpikeLoc) 's']));
% disp(join(['First spike latency = ' string(spikeLatency*1000) 'ms']));

[promSpikeLatency, promSpikeLoc, stimulusOnTime] = getPromSpikeLatency(stimulus, stimThresh, samplingRate, spLocs, minLatency, spikes, spStop);
% disp(join(['Time to first stimulus elicited spike = ' string(promSpikeLoc) 's']));
% disp(join(['First spike latency = ' string(promSpikeLatency*1000) 'ms']));

% figure;
% plot(t, filteredResponse); hold on; ylabel('Voltage (mV)');
% yyaxis right; plot(t, stimulus); ylabel('Stimulus');
% xline(promSpikeLoc, 'r', 'LineStyle','--');
% xline(stimulusOnTime, 'LineStyle', '--');
% xlabel('Time (s)');


% figure;
% plot(t(spLocs),0.05*ones(1,nspikes), '|r', 'LineWidth',2); hold on;
% plotSpikes(filteredResponse, t, samplingRate, spStart, spStop, "Selected spikes");

% figure; 
% plot(t, gcfr);
% yline(threshold, 'k'); hold on;
% plot(timeAtThresh, gcfr(round(timeAtThresh*samplingRate)), 'rx');
% yyaxis right; plot(t, stimulus); 

% stimDataset = [stimDataset stimulus];
% respDataset = [respDataset response];
% rasterDataset = [rasterDataset raster'];
% spStartDataset = [spStartDataset spStart];
% spStopDataset = [spStopDataset spStop];
% % gcfrDataset = [gcfrDataset gcfr'];
% latencyDataset = [latencyDataset promSpikeLatency];
% templatesDataset = [templatesDataset (str2double(split(spikeTempIdx, ':')))'];

% if writeFlag == 1
% 
%     datasetParameters = {'Shuffle', 1, 'Deflate', 9, 'Fletcher32', 1, 'ChunkSize', [100, 1]};
%     groupPath = strjoin(['/' mothID],"");
%     newFilePath = strjoin([rawDataDir muscleID ".h5"], "");
% 
% 
%     writeDataset = @(dataset, datasetName, unit) writeh5file(newFilePath, mothID, dataset, datasetName, unit);
%     writeDataset(stimDataset, 'stimulus', 'V');
%     writeDataset(respDataset, 'response', 'mV');
%     writeDataset(templatesDataset, 'templates', 's');
%     writeDataset(rasterDataset, 'raster', 'a');
% %     writeDataset(gcfrDataset, 'firing rate', 'Hz');
%     writeDataset(spStartDataset, 'spStart', 'a');
%     writeDataset(spStopDataset, 'spStop', 'a');
%     writeDataset(latencyDataset', 'latency', 'ms');
% 
%     h5writeatt(newFilePath, groupPath, 'sampling rate', samplingRate );
%     h5writeatt(newFilePath, groupPath, 'trial length', trialLength );
%     h5writeatt(newFilePath, groupPath, 'muscle ID', muscleID );
%     h5writeatt(newFilePath, groupPath, 'moth ID', mothID );
% 
% end

end