function [samplingRate, trialLength, spikeTempIdx, initOffDur, stimOnDur, nTrials] = loadParameters(rowID, tablePath)
% LOADPARAMETERS loads parameters from LUT

% load('LUT.mat');
templateLUT = readtable(tablePath,"ReadVariableNames",true,"VariableNamingRule","preserve","TextType","string");
templateLUT.Properties.RowNames = templateLUT.fileID;
LUTrow = templateLUT(rowID,:);

samplingRate = LUTrow.samplingRate;
trialLength = LUTrow.trialLength * samplingRate;
spikeTempIdx = rmmissing([LUTrow.spikeType1; LUTrow.spikeType2; LUTrow.spikeType3; LUTrow.spikeType4]);   
initOffDur = LUTrow.initOffDur;
stimOnDur = LUTrow.stimOnDur;
nTrials = LUTrow.nTrials;
end
