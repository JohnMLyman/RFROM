function [sla,adt]=read_netcdf_sla_adt_tuna(file_name_nc)

% this code reads in SLA from Aviso files and 
%    shitches them to 0 to 360 if they are -180 to 180
    lon_junk=ncread(file_name_nc,'longitude');
    sla_junk=ncread(file_name_nc,'sla');
    adt_junk=ncread(file_name_nc,'adt');

  

    sla=[sla_junk(lon_junk>=0,:);sla_junk(lon_junk<0,:)];
    adt=[adt_junk(lon_junk>=0,:);adt_junk(lon_junk<0,:)];
    


