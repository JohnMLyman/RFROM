load('D:\s_maps\sdata_new_layers__cheng_EN4_2014_argo_2023_03_23_QC_press_seasonal.mat')

layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000]% layer_bounds must be in assending order


make_big_T_S_vars

time_data_1950=datenum(floor(yr),1,1)-datenum(1950,1,1)+yeardays(floor(yr)).*(yr-floor(yr));

lon_data=coords(:,1);
lat_data=coords(:,2);

lon_data(lon_data<0)=lon_data(lon_data<0)+360;

time_cent=datenum(2010,5,30)-datenum(1950,1,1);
lon_cent=332;
lon_cent=220;
lat_cent=0;
good_time=(time_data_1950>time_cent-30 )&(time_data_1950<time_cent);

good_lon=lon_data>lon_cent-1 & lon_data<lon_cent+1;

good_lat=lat_data>lat_cent-.5 & lat_data<lat_cent+.5;


good=good_lat&good_lon&good_time;
lon_use=lon_data(good);
lat_use=lat_data(good);
time_use=time_data_1950(good);
sal_use=SAL(good,:);
temp_use=TEMP(good,:);

[lon_out,lat_out,time_out,pres_out,sal_out]=find_RFROM_sal_profile(lon_use,lat_use,time_use);