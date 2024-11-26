function [lon,lat,time,fresh]=load_idl_data_fresh(file_name)



data=netcdf(file_name)


 lon=data{'lon'}(1:end);
lat=data{'lat'}(1:end);
 fresh=permute(data{'fresh'}(1:end,1:end,1:end),[3 2 1]);
 time=[2005 2005 2005];