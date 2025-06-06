years_load=[2007:2018];


TreeSetUp=TreeSetUp_2023_orca_heat_novert_test_NCAR;
[lonR,latR,mean_depthR,mean_depth_bndsR,yrR,ohcaR]=load_heat_netcdf_final(years_load,TreeSetUp); 
[lon,lat,yr,ohca,layer_bounds_NCAR]=load_heat_netcdf_NCAR_SMALL_fast(years_load,TreeSetUp);

TreeSetUp=TreeSetUp_2023_orca_heat_novert_test_NCAR_paige;
[lonP,latP,mean_depthP,mean_depth_bndsP,yrP,ohcaP]=...
    load_heat_netcdf_final(years_load,TreeSetUp); 



[amp_annual_total,phase_annual_total,amp_semi_total,phase_semi_total,...
amp_third_total,phase_third_total,slope_total,mean_total,model_err_total]=...
make_seasonal_cycle_comp_NCAR(yr,ohca);

[amp_annual_totalR,phase_annual_totalR,amp_semi_totalR,phase_semi_totalR,...
amp_third_totalR,phase_third_totalR,slope_totalR,mean_totalR,model_err_totalR]=...
make_seasonal_cycle_comp_NCAR(yrR,ohcaR);

[amp_annual_totalP,phase_annual_totalP,amp_semi_totalP,phase_semi_totalP,...
amp_third_totalP,phase_third_totalP,slope_totalP,mean_totalP,model_err_totalP]=...
make_seasonal_cycle_comp_NCAR(yrP,ohcaP);
