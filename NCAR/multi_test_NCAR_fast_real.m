
TreeSetUp=TreeSetUp_2024_orca_heat_novert_test_mid_paige;
years_load=1993:2017;
tic
[mean_depth,mean_depth_bnds,yr_new,ohca_curve_new]=load_heat_netcdf_all_year_paige_curve(years_load,TreeSetUp,60);
[mean_depth_newno,mean_depth_bnds_newno,yr_out_newno,ohca_curve_new_no]=load_heat_netcdf_all_year_paige_curve_nocycle(years_load,TreeSetUp,60);

% TreeSetUp=TreeSetUp_2024_orca_heat_novert_test_mid_fast;
% [mean_depth_old,mean_depth_bnds_old,yr_out_old,ohca_curve_old]=load_heat_netcdf_all_year_paige_curve(years_load,TreeSetUp,60);
% [mean_depth_oldno,mean_depth_bnds_oldno,yr_out_oldno,ohca_curve_old_no]=load_heat_netcdf_all_year_paige_curve_nocycle(years_load,TreeSetUp,60);


TreeSetUp=TreeSetUp_2024_orca_heat_novert_test_mid_fast;
[mean_depth_oldno2,mean_depth_bnds_oldno2,yr_out_oldno2,ohca_curve_old_no2]=load_heat_netcdf_all_year_paige_curve_nocycle(years_load,TreeSetUp,60);
[mean_depth_old2,mean_depth_bnds_old2,yr_out_old2,ohca_curve_old2]=load_heat_netcdf_all_year_paige_curve(years_load,TreeSetUp,60);


ohca_curve_2000_old_no2=squeeze(jnansum(ohca_curve_old_no2,1))*1e9;
ohca_curve_2000_old2=squeeze(jnansum(ohca_curve_old2,1))*1e9;


ohca_curve_2000_new=squeeze(jnansum(ohca_curve_new,1))*1e9;
ohca_curve_2000_new_no=squeeze(jnansum(ohca_curve_new_no,1))*1e9;

% 
% ohca_curve_2000_old_no=squeeze(jnansum(ohca_curve_old_no,1))*1e9;
% 
% ohca_curve_2000_old=squeeze(jnansum(ohca_curve_old,1))*1e9;

% ohca_curve_2000=squeeze(jnansum(ohca_curve_truth,1))*1e9; 
toc./60

good=yr_new>=2007;


% ohca_curve_2000=ohca_curve_2000-mean(ohca_curve_2000(good),'omitnan');
% ohca_curve_2000_old=ohca_curve_2000_old-mean(ohca_curve_2000_old(good),'omitnan');
ohca_curve_2000_old2=ohca_curve_2000_old2-mean(ohca_curve_2000_old2(good),'omitnan');
ohca_curve_2000_new=ohca_curve_2000_new-mean(ohca_curve_2000_new(good),'omitnan');

ohca_curve_2000_old_no2=ohca_curve_2000_old_no2-mean(ohca_curve_2000_old_no2(good),'omitnan');
ohca_curve_2000_new_no=ohca_curve_2000_new_no-mean(ohca_curve_2000_new_no(good),'omitnan');

% figure(1)
% plot(yr_new,smooth(ohca_curve_2000_new,73)./1e21,'b')
% hold on
% plot(yr_new,smooth(ohca_curve_2000_old,73)./1e21,'k')
% hold on
% plot(yr_new,smooth(ohca_curve_2000,73)./1e21,'r')
% 
% figure(2)
% plot(yr_new,smooth(ohca_curve_2000_new,6)./1e21,'b')
% hold on
% plot(yr_new,smooth(ohca_curve_2000_old,6)./1e21,'k')
% hold on
% plot(yr_new,smooth(ohca_curve_2000,6)./1e21,'r')
% 
% figure(3)
% plot(yr_new,ohca_curve_2000_new./1e21,'b')
% hold on
% plot(yr_new,ohca_curve_2000_old./1e21,'k')
% hold on
% plot(yr_new,ohca_curve_2000./1e21,'r')
