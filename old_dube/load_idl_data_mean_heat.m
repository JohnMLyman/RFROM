function [lon,lat,time,ht]=load_idl_data_mean_heat(file_name)



data=netcdf(file_name)


 lon=data{'lon'}(1:end);
lat=data{'lat'}(1:end);
time=data{'time'}(1:end);
 ht=permute(data{'ht'}(1:end,1:end,1:end),[3 2 1]);
time=time+.5;