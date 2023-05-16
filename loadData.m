function [stimulus,response] = loadData(filepath, trialLength)
%LOADDATA loads data from text file
    
    fid = fopen(filepath);
    data = fscanf(fid,'%f');
    totalTrialLength = length(data)/2;
    stimulus = data(totalTrialLength+1:end)/10;
    stimulus = stimulus(1:trialLength);
    stimulus = stimulus - stimulus(1);
    response = data(1:totalTrialLength);
    response = response - response(1);
    response = response(1:trialLength);

end

