function gcfr = getGCFR(gauss_win_L, gauss_win_sigma, raster, samplingRate)

    gauss_win_alpha = (gauss_win_L*samplingRate - 1)/(2*gauss_win_sigma*samplingRate);
    gauss_window = gausswin(gauss_win_L*samplingRate, gauss_win_alpha);
    
    gcfr = (samplingRate/sum(gauss_window))*conv(raster,gauss_window,'same');

end