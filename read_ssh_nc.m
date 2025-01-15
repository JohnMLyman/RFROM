function [lon,lat,sla,adt]=read_ssh_nc(file_name)

    lat=ncread(file_name,'latitude');
    lon=ncread(file_name,'longitude');
    sla=ncread(file_name,'sla');
    adt=ncread(file_name,'adt');

    



end
