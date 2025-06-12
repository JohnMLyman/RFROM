% ASSUMES THE FILE NAME DOESNT INCLUDE PATH AND IS OF THE FORM:
%  file_name='g.e20.G.TL319_t13.control.001.pop.h.0183-12-31.nc';
function Orca_netcdf_files(file_name_in,file_path_in,file_path_out)
% file_path_in='K:\data\NCAR\model_grid\';
% file_path_out='L:\data\NCAR\small_grid\';
% % 
% path_out='/glade/derecho/scratch/jlyman/';
% % path_out='K:\';
% 
% file_path_POP='/glade/campaign/cgd/oce/projects/FOSI/HR/g.e20.G.TL319_t13.control.001/ocn/hist/';
% % file_path_POP='K:\';
% 
% file_name='g.e20.G.TL319_t13.control.001.pop.h.0183-12-31.nc';

file_in=[file_path_in,file_name_in];

file_name_out=[file_name_in(1:9),'small_',file_name_in(10:end)];
file_out=[file_path_out,file_name_out];

ptemp=ncread(file_in,'ptemp');
sal=ncread(file_in,'sal');
ssh=ncread(file_in,'ssh');
time=ncread(file_in,'time');
lon=ncread(file_in,'longitude');
lat=ncread(file_in,'latitude');
depth=ncread(file_in,'depth');
dz=ncread(file_in,'dz');
yr_file=ncread(file_in,'time_yrfrac');




% 
% write_netcfd_cf_temp_sal_NCAR(ptemp,sal,ssh,time,yr_file,lon,...
%     lat,depth,dz,[path_out,file_name_out]);
% toc./60
tic
lon_new=.125:.25:360-.125;
lat_new=-90+.125:.25:90-.125;

[ptemp,sal,ssh]=regrid_3d(lon,lat,ptemp,sal,ssh,lon_new,lat_new);
write_netcfd_cf_temp_sal_NCAR_rect(ptemp,sal,ssh,time,yr_file,lon_new,...
    lat_new,depth,dz,file_out)
    
toc./60
end

function [var1_out,var2_out,var3_out]=regrid_3d(lon,lat,var1,var2,var3,lon_new,lat_new)
% put on a regular 1/4 degree grid
    var1=double(var1);
    var2=double(var2);
    var3=double(var3);
    lon=double(lon);
    lat=double(lat);
    lat_new=double(lat_new);
    lon_new=double(lon_new);
%var1 and var2 are 3D vars and var 3 is 2d all the same size
    tic
    good=isfinite(lon)&isfinite(lat);
    svar=size(var1);

    
    var1_out=nan(length(lon_new),length(lat_new),svar(3));
    var2_out=nan(length(lon_new),length(lat_new),svar(3));

    var3_out=griddata(lat(good),lon(good),var3(good),lat_new',lon_new,'linear');




    parfor ilevel=1:svar(3)
        var1_junk=squeeze(var1(:,:,ilevel));
        var1_out(:,:,ilevel)=griddata(lat(good),lon(good),var1_junk(good),lat_new',lon_new,'linear');
        var2_junk=squeeze(var2(:,:,ilevel));
        var2_out(:,:,ilevel)=griddata(lat(good),lon(good),var2_junk(good),lat_new',lon_new,'linear');

        

    end
   
    
end