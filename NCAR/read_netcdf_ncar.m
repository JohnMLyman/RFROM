% ASSUMES THE FILE NAME DOESNT INCLUDE PATH AND IS OF THE FORM:
%  file_name='g.e20.G.TL319_t13.control.001.pop.h.0183-12-31.nc';
file_name='g.e20.G.TL319_t13.control.001.pop.h.0183-12-31.nc';

file_name_out=['NCAR_POP_',file_name(37:9+37+3)];

ptemp=ncread(file_name,'TEMP');
sal=ncread(file_name,'SALT');
ssh=ncread(file_name,'SSH');
time=ncread(file_name,'time');
lon=ncread(file_name,'TLONG');
lat=ncread(file_name,'TLAT');
depth=ncread(file_name,'z_t')./100;
dz=ncread(file_name,'dz')./100;
area=ncread(file_name,'TAREA')./(100.*100);


time_leap=datenum(file_name(37:9+37));


lat=smooth_NCAR_2d(lat);
lon=smooth_NCAR_2d(lon);
ssh=smooth_NCAR_2d(ssh);

area=sum_NCAR_2d(area);

sal=smooth_NCAR_3d(sal);
ptemp=smooth_NCAR_3d(ptemp);

write_netcfd_cf_temp_sal_NCAR(ptemp,sal,ssh,time,time_leap,lon,...
    lat,depth,dz,area,file_name_out);

