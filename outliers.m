stim_ss = mean(T.stimulus(:,21000:22000),2);
stim_iqr = iqr(stim_ss);
outlier_idx = find(stim_ss > 1.5*stim_iqr | stim_ss < -1.5*stim_iqr);
disp(T.filename(outlier_idx))

figure;
for i=1:length(outlier_idx)
    irow = outlier_idx(i);
    plot(T.stimulus(irow,:)); hold on;
    disp(T.filename(irow));
    pause;
end 