function writeDataset(filePath, mothId, dataset, datasetName, unit)
%WRITEDATASET 
%     datasetParameters = {'Shuffle', 1, 'Deflate', 9, 'Fletcher32', 1, 'ChunkSize', [100, 1]};
    
    datasetPath = strjoin(['/', mothId, '/', datasetName],"")

%     [fileLocation, filename, ext] = fileparts(filePath);
%     cd(fileLocation);
%     fileId = strjoin([filename ext],'');
    h5create(filePath, datasetPath, size(dataset)); %, datasetParameters{:});
    h5write(filePath, datasetPath, dataset);
    h5writeatt(filePath, datasetPath, 'Unit', unit);
end
