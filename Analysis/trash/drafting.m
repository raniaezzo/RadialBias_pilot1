Location = {'0';'45';'90';'135';'180';'225';'270';'315'};
Upwards = [;43;38;40;49];

T = struct2table(summary_radial);
T.Properties.RowNames = summary_radial.rownames;
T = removevars(T,{'rownames'});
%T.loc_0

LL_dir = M_raw_concatenated(M_raw_concatenated(:,9)==225,:);