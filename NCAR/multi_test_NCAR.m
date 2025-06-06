TreeSetUp=TreeSetUp_2023_orca_heat_novert_test_NCAR_paige;
years_load=2015:2018;
[lone,late,yre,ohcae,layer_bounds_NCAR_oute]=load_heat_netcdf_NCAR_SMALL_fast(years_load,TreeSetUp);
[lon,lat,mean_depth,mean_depth_bnds,yr_out,ohca]=load_heat_netcdf_all_year_paige(years_load,TreeSetUp);


% arw=areavec(lone,late);


ohca_0_2000=squeeze(jnansum(ohca,3));
ohcae_0_2000=squeeze(jnansum(ohcae,3));
% ohca=ohca.*arw;
% ohcae=ohcae.*arw;

hme=mean(ohcae,4,'omitnan');
hm=mean(ohca,4,'omitnan');
% 
% ohca=ohca-hm;
% ohcae=ohcae-hme;
% 
% ohca_curve=ohca.*arw;
% ohcae_curve=ohcae.*arw;
% 
% ohca_curve=jnansum(ohca_curve,1);
% ohca_curve=jnansum(ohca_curve,2);
% ohca_curve=squeeze(jnansum(ohca_curve,3));
% 
% ohcae_curve=jnansum(ohcae_curve,1);
% ohcae_curve=jnansum(ohcae_curve,2);
% ohcae_curve=squeeze(jnansum(ohcae_curve,3));