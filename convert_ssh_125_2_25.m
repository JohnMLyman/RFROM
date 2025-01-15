function []=convert_ssh_125_2_25(file_name,path_in,path_out)


% first remove the file if it exist in destination dir
%     I am only checking the first part of the name because that is the
%     time the file represents.  The second part is the time the file was
%     made, which can change and we dont want duplicates

file_exist=dir([path_out,file_name(1:33),'*.nc']);

if ~isempty(file_exist)
    delete([path_out,file_exist.name])
end



[lon,lat,time,sla,adt]=read_ssh_nc_125deg([path_in,file_name]);
units = ncreadatt([path_in,file_name],'sla','units');

if units~='m' 
    error(['sla is not in meters!! for file: ',path_in,file_name])
end

if lon(2)-lon(1)~=.25 
    error(['file not .125 deg!! for file: ',path_in,file_name])
end

write_netcdf_ssh(lon,lat,time,sla,adt,[path_out,file_name])

delete([path_in,file_name])

end



