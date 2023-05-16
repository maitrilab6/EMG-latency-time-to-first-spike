function filteredData = filterData(response, samplingRate)
    
    lowCut = 50; %50; %10
    highCut = 500;
    order =3;
    [A,B,C,D] = butter(order,[lowCut highCut]/(samplingRate/2));
    [sos,g] = ss2sos(A,B,C,D);
    filteredData = filtfilt(sos,g,response);

end