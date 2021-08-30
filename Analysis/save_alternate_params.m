function save_alternate_params(type_summarypath)

   % (1) taking abs from current 6cond w/fits [analyzeddata_6fits_abs.mat]  
   
   save_abs_params(type_summarypath, 'analyzeddata', 'analyzeddata_6fits_abs')
   
   % (2) creating radial/tangential from means of abs(4 fits) [analyzeddata_4fits_absmean.mat]
   
   save_mean_params(type_summarypath, 'analyzeddata_6fits_abs', 'analyzeddata_4fits_absmean')
   
   % (3) creating radial/tangential from means of 4 fits [analyzeddata_4fits_mean.mat]

   save_mean_params(type_summarypath, 'analyzeddata', 'analyzeddata_4fits_mean')
   
end