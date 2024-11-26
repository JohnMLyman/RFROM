% % % load('D:\grided\s_grided\allsal_new_layers_argo_WOD_new_argo_2023_03_23_QC_press_seasonal.mat')
% % % 
% % % 
load('D:\grided\s_grided\allsal_new_layers_seasonal__new.mat')
load('D:\EN4\Cheng_2014\allsal_wod_new_layers_all_conv4argo_2023_03_23_QC_press_cheng_EN4_2014.mat')


layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000]% layer_bounds must be in assending order


make_big_T_S_vars_argo
make_big_T_S_vars_wod


time_data_1950_wod=datenum(dt_wod)-datenum(1950,1,1);
time_data_1950_argo=datenum(dt)-datenum(1950,1,1);


lon_data_wod=coords_wod(:,1);
lat_data_wod=coords_wod(:,2);
lon_data_wod(lon_data_wod<0)=lon_data_wod(lon_data_wod<0)+360;

lon_data_argo=cds(:,1);
lat_data_argo=cds(:,2);
lon_data_argo(lon_data_argo<0)=lon_data_argo(lon_data_argo<0)+360;



time_cent=datenum(2010,5,30)-datenum(1950,1,1);
lon_cent=332;
lon_cent=220;
lat_cent=0;
% 
% lon_cent=(153+143)./2
% lat_cent=(-47-43)./2
good_time_wod=(time_data_1950_wod>time_cent-360 )&(time_data_1950_wod<time_cent);

good_lon_wod=lon_data_wod>lon_cent-2 & lon_data_wod<lon_cent+2;

good_lat_wod=lat_data_wod>lat_cent-.5 & lat_data_wod<lat_cent+.5;


good_wod=good_lat_wod&good_lon_wod&good_time_wod;
lon_use_wod=lon_data_wod(good_wod);
lat_use_wod=lat_data_wod(good_wod);
time_use_wod=time_data_1950_wod(good_wod);
sal_use_wod=SAL_wod(good_wod,:);
temp_use_wod=TEMP_wod(good_wod,:);


good_time_argo=(time_data_1950_argo>time_cent-150 )&(time_data_1950_argo<time_cent+150);

good_lon_argo=lon_data_argo>lon_cent-1 & lon_data_argo<lon_cent+1;

good_lat_argo=lat_data_argo>lat_cent-.5 & lat_data_argo<lat_cent+.5;


good_argo=good_lat_argo&good_lon_argo&good_time_argo;
lon_use_argo=lon_data_argo(good_argo);
lat_use_argo=lat_data_argo(good_argo);
time_use_argo=time_data_1950_argo(good_argo);
sal_use_argo=SAL_argo(good_argo,:);
temp_use_argo=TEMP_argo(good_argo,:);


[lon_out_wod,lat_out_wod,time_out_wod,pres_out_wod,sal_out_wod]=find_RFROM_sal_profile(lon_use_wod,lat_use_wod,time_use_wod);
[lon_out_argo,lat_out_argo,time_out_argo,pres_out_argo,sal_out_argo]=find_RFROM_sal_profile(lon_use_argo,lat_use_argo,time_use_argo);

 [lon_out_wodt,lat_out_wodt,time_out_wodt,pres_out_wodt,temp_out_wod]=find_RFROM_temp_profile(lon_use_wod,lat_use_wod,time_use_wod);
 [lon_out_argot,lat_out_argot,time_out_argot,pres_out_argot,temp_out_argo]=find_RFROM_temp_profile(lon_use_argo,lat_use_argo,time_use_argo);

 [lon_out_wod_no,lat_out_wod_no,time_out_wod_no,pres_out_wod_no,sal_out_wod_no]=find_RFROM_sal_profile_nossh(lon_use_wod,lat_use_wod,time_use_wod);
[lon_out_argo_no,lat_out_argo_no,time_out_argo_no,pres_out_argo_no,sal_out_argo_no]=find_RFROM_sal_profile_nossh(lon_use_argo,lat_use_argo,time_use_argo);

[lon_out_argo_nos,lat_out_argo_nos,time_out_argo_nos,pres_out_argo_nos,sal_out_argo_nos]=find_RFROM_sal_profile_nossh_stable(lon_use_argo,lat_use_argo,time_use_argo);
[lon_out_wod_nos,lat_out_wod_nos,time_out_wod_nos,pres_out_wod_nos,sal_out_wod_nos]=find_RFROM_sal_profile_nossh_stable(lon_use_wod,lat_use_wod,time_use_wod);

[lon_out_argo_nol_nosst,lat_out_argo_nol_nosst,time_out_argo_nol_nosst,pres_out_argo_nol_nosst,sal_out_argo_nol_nosst]=find_RFROM_sal_profile_nosst_nolatlon(lon_use_argo,lat_use_argo,time_use_argo);
