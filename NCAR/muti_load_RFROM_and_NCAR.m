years_load=[2009:2018];
TreeSetUp=TreeSetUp_2023_orca_heat_novert_test_NCAR;

tic
[lonR,latR,mean_depthR,mean_depth_bndsR,yrR,ohcR]=load_heat_netcdf(years_load,TreeSetUp);
toc./60

tic
[lonM,latM,yrM,ohcM,layer_bounds_NCAR_outM]=load_heat_netcdf_NCAR_SMALL(years_load,TreeSetUp);
toc./60