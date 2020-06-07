function [error] = timeseries_error(ts1,xs1,ts2,xs2)

ref_time = 0:82;

[~,~,bin1] = histcounts(ref_time,ts1);
[~,~,bin2] = histcounts(ref_time,ts2);
bin1(bin1 == 0) = max(bin1);
bin2(bin2 == 0) = max(bin2);

xs1_sync = xs1(bin1);
xs2_sync = xs2(bin2);

% might compare more than 1D time series
% error_vector = vecnorm([xs1_sync;xs2_sync],1,2); % p = 2, along 2nd axis (so row norm)
% error = mean(error_vector);

error = norm(xs1_sync-xs2_sync, 1);

end
