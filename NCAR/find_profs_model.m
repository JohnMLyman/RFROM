function [pos_2d,coords_ncar_prof,max_depth_ncar_prof,yr_ncar_prof]=...
    find_profs_model(profile_coords,profile_yr,profile_max_depth)
    
    NCAR_file='K:\g.e20.G.TL319_t13.control.001.pop.h.0183-12-31.nc';
   
    model_ssh=ncread(NCAR_file,'SSH');
    
    model_lon=ncread(NCAR_file,'TLONG');
    model_lat=ncread(NCAR_file,'TLAT');
%     profile_coords=[10 10;0 300;1 2;80 50];
    
    max_year_NCAR=2019;
    min_year_NCAR=1993;
%     min_year_NCAR=2019.95;

    good_prof=profile_yr>=min_year_NCAR & profile_yr<=max_year_NCAR;
    
    yr_ncar_prof=profile_yr(good_prof);
    max_depth_ncar_prof=profile_max_depth(good_prof);
    profile_coords=profile_coords(good_prof,:);

    
    bad_ssh=~isfinite(model_ssh);
    
    model_lon(bad_ssh)=nan;
    model_lat(bad_ssh)=nan;

   

    
%    size(profile_coords)
   
    
    model_coords=[model_lon(:),model_lat(:)];
%      tic
%     
%     [pos_2d,~] = dsearchn(model_coords,profile_coords);
%     toc
    tic
    [pos_2d,~] = knnsearch(model_coords,profile_coords);
    toc./60
   
    
    
    lon_ncar_prof=model_lon(pos_2d);
    lon_ncar_prof(lon_ncar_prof>180)=lon_ncar_prof(lon_ncar_prof>180)-360;
    lat_ncar_prof=model_lat(pos_2d);

    coords_ncar_prof=[lon_ncar_prof lat_ncar_prof];

    
  
end