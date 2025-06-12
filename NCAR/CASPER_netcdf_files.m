% ASSUMES THE FILE NAME DOESNT INCLUDE PATH AND IS OF THE FORM:
%  file_name='g.e20.G.TL319_t13.control.001.pop.h.0183-12-31.nc';
function CASPER_netcdf_files(file_name,file_path_POP,path_out)
tic
% 
% path_out='/glade/derecho/scratch/jlyman/';
% % path_out='K:\';
% 
% file_path_POP='/glade/campaign/cgd/oce/projects/FOSI/HR/g.e20.G.TL319_t13.control.001/ocn/hist/';
% % file_path_POP='K:\';
% 
% file_name='g.e20.G.TL319_t13.control.001.pop.h.0183-12-31.nc';

file_name_out=['NCAR_POP_',file_name(37:9+37+3)];
% file_name_out2=['NCAR_POP2_',file_name(37:9+37+3)];
file_name_in=[file_path_POP,file_name];


ptemp=ncread(file_name_in,'TEMP');
sal=ncread(file_name_in,'SALT');
ssh=ncread(file_name_in,'SSH');
time=ncread(file_name_in,'time');
lon=ncread(file_name_in,'TLONG');
lat=ncread(file_name_in,'TLAT');
depth=ncread(file_name_in,'z_t')./100;
dz=ncread(file_name_in,'dz')./100;




year_file=str2num(file_name(37:3+37));
year_file_comp=year_file-183+2018;
yr_file=year_file_comp+(time-year_file*365-1)./365;


lat=smooth_NCAR_2d(lat);
lon=smooth_NCAR_2d_lon(lon);
ssh=smooth_NCAR_2d(ssh);




sal=smooth_NCAR_3d(sal);
ptemp=smooth_NCAR_3d(ptemp);


write_netcfd_cf_temp_sal_NCAR(ptemp,sal,ssh,time,yr_file,lon,...
    lat,depth,dz,[path_out,file_name_out]);
toc./60
% % % tic
% % % lon_new=.125:.25:360-.125;
% % % lat_new=-90+.125:.25:90-.125;
% % % 
% % % [ptemp,sal,ssh]=regrid_3d(lon,lat,ptemp,sal,ssh,lon_new,lat_new);
% % % write_netcfd_cf_temp_sal_NCAR_rect(ptemp,sal,ssh,time,yr_file,lon_new,...
% % %     lat_new,depth,dz,[path_out,file_name_out2])
% % %     
% % % toc./60
end

function [var1_out,var2_out,var3_out]=regrid_3d(lon,lat,var1,var2,var3,lon_new,lat_new)
% put on a regular 1/4 degree grid

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