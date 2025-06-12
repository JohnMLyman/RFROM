
TreeSetUp=TreeSetUp_2023_orca_heat_novert_test_NCAR_paige_old;
years_load=1993:2018;
basin_number=100;
tic
[yr_truth,ohca_curve_truth,layer_bounds_NCAR_oute]=multi_load_heat_netcdf_NCAR_SMALL_fast_curve_basin(years_load,TreeSetUp,-60,60,basin_number);
[mean_depth,mean_depth_bnds,yr_new,ohca_curve_new]=multi_load_heat_netcdf_all_year_paige_curve_basin(years_load,TreeSetUp,-60,60,basin_number);
TreeSetUp=TreeSetUp_2023_orca_heat_novert_test_NCAR_old;
[mean_depth_old,mean_depth_bnds_old,yr_out_old,ohca_curve_old]=multi_load_heat_netcdf_all_year_paige_curve_basin(years_load,TreeSetUp,-60,60,basin_number);

ohca_curve_2000_new_t=squeeze(jnansum(ohca_curve_new,1))*1e9;

ohca_curve_2000_old_t=squeeze(jnansum(ohca_curve_old,1))*1e9;

ohca_curve_2000_t=squeeze(jnansum(ohca_curve_truth,1))*1e9;
toc./60

good=yr_new>=2007;


for ibasin=1:12
    ohca_curve_2000=ohca_curve_2000_t(:,ibasin)-mean(ohca_curve_2000_t(good,ibasin),'omitnan');
    ohca_curve_2000_old=ohca_curve_2000_old_t(:,ibasin)-mean(ohca_curve_2000_old_t(good,ibasin),'omitnan');
    ohca_curve_2000_new=ohca_curve_2000_new_t(:,ibasin)-mean(ohca_curve_2000_new_t(good,ibasin),'omitnan');
    
    figure(1)
    clf
    plot(yr_new,smooth(ohca_curve_2000_new,73)./1e21,'b')
    hold on
    plot(yr_new,smooth(ohca_curve_2000_old,73)./1e21,'k')
    hold on
    plot(yr_new,smooth(ohca_curve_2000,73)./1e21,'r')
    ibasin
    pause
end

figure(2)
plot(yr_new,smooth(ohca_curve_2000_new,6)./1e21,'b')
hold on
plot(yr_new,smooth(ohca_curve_2000_old,6)./1e21,'k')
hold on
plot(yr_new,smooth(ohca_curve_2000,6)./1e21,'r')

figure(3)
plot(yr_new,ohca_curve_2000_new./1e21,'b')
hold on
plot(yr_new,ohca_curve_2000_old./1e21,'k')
hold on
plot(yr_new,ohca_curve_2000./1e21,'r')
