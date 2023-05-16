tablePath = "spike templates_5.xlsx";
rawDataDir = "/Users/praveen/Documents/EMG for paper/EMG_wingmuscles_rawfiles/Raw files for analysis/Raw files_UpdatedSampleSize/";
templateLUT = readtable(tablePath,"ReadVariableNames",true,"VariableNamingRule","preserve","TextType","string");
trialLength = 2.5;
samplingRate = 10000;
T = table();

for irow = 1:height(templateLUT)
    
    muscleID = templateLUT.muscleID(irow);
    mothID = templateLUT.mothID(irow);
    rowID = templateLUT.fileID(irow);
    
    filepath = join([rawDataDir muscleID "/" join([mothID], "-") "/" rowID ".txt"], "");
    

    [stimulus,response] = loadData(filepath, trialLength*samplingRate);
    
    filteredData = filterData(response, samplingRate);
    
    T(irow,:) = table(stimulus',filteredData', rowID);
    
end
T = renamevars(T, ["Var1", "Var2", "rowID"],["stimulus", "filteredResponse", "filename"]);

%% Plot data


for irow = 1:height(T)
    figure;
    plot(T.filteredResponse(irow,:)); hold on;
    yyaxis right; plot(T.stimulus(irow,:));
    title(replace(T.rowID(irow),'_',' '));
    pause;
end
