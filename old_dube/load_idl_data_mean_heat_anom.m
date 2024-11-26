function [lon,lat,time,ht]=load_idl_data_mean_heat_anom(file_name)



data=netcdf(file_name)


 lon=data{'lon_anom'}(1:end);
lat=data{'lat_anom'}(1:end);
time=data{'time_anom'}(1:end);
 ht=permute(data{'ht_anom'}(1:end,1:end,1:end),[3 2 1]);
time=time;