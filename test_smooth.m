function var_out=smooth_NCAR_3d(var)

var=temp;
lat_new=double(rlat);
lon_new=double(rlon);
               nlayers=63;
               
               n_Ln=ones(2,1800,3,800,nlayers-1);
                tic
                var= reshape(var,2,1800,3,800,nlayers-1);
                n_var=n_Ln;
                n_var(~isfinite(var))=0;
                var=sum(sum(var,1,'omitnan'),3,'omitnan');
                n_var=sum(sum(n_var,1,'omitnan'),3,'omitnan');
                var=reshape(var./n_var,1800,800,nlayers-1);
                'smooth'
                toc./60

              
             
                n_Ln_lat=ones(2,1800,3,800);
                tic
                lon_var= reshape(lon,2,1800,3,800);
                n_lon_var=n_Ln_lat;
                n_lon_var(~isfinite(lon_var))=0;
                lon_var=sum(sum(lon_var,1,'omitnan'),3,'omitnan');
                n_lon_var=sum(sum(n_lon_var,1,'omitnan'),3,'omitnan');
                lon_var=reshape(lon_var./n_lon_var,1800,800);

                lat_var= reshape(lat,2,1800,3,800);
                n_lat_var=n_Ln_lat;
                n_lat_var(~isfinite(lat_var))=0;
                lat_var=sum(sum(lat_var,1,'omitnan'),3,'omitnan');
                n_lat_var=sum(sum(n_lat_var,1,'omitnan'),3,'omitnan');
                lat_var=reshape(lat_var./n_lat_var,1800,800);
                'lon lat'
                toc./60

                sst_low=var(:,:,1);
                sst=temp(:,:,1);

% good_var=isfinite(lon_var)&isfinite(lat_var);
% 
% tic
% sst_new_low_lin=griddata(lon_var(good_var),lat_var(good_var),sst_low(good_var),lon_new',lat_new,'linear');
% 
% 62*toc./60
% 
% tic
% sst_new_low_near=griddata(lon_var(good_var),lat_var(good_var),sst_low(good_var),lon_new',lat_new,'nearest');
% 'mean'
% 62*toc./60
% 
% 
% good=isfinite(lon)&isfinite(lat);
% 
% tic
% sst_new_lin=griddata(lon(good),lat(good),sst(good),lon_new',lat_new,'linear');
% 'all linear'
% 62*toc./60
% 
% 
% 
% tic
% sst_new_near=griddata(lon(good),lat(good),sst(good),lon_new',lat_new,'nearest');
% 'all nearest'
% 62*toc./60

