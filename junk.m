function []=error_holdout_all_years_test_weights(TreeSetUp)
load_TreeSetUp

tree_model_file_name=tree_model_file_name_all_year;
path_new_tree=path_new_tree_all_year;

load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new.mat','topo_tpx_new','lon_topo','lat_topo')
 topo_tpx_new=-1.*topo_tpx_new;




file_hold_out_estimate=[path_new_tree,tree_model_file_name,'_hold_out_estiamte_split.mat'];


 load(file_hold_out_estimate)
 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);

tic

for ilayer=2:nlayer
    nbasin=10;
    fig_num=(ilayer-2)*10;
   layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   tree_file_name_yearly=[tree_model_file_name,'_',layer_name];
   tree_file_name_yearly_error=[tree_model_file_name,'_error_',layer_name];
  load([path_tree,tree_file_name_yearly,'_7day.mat'], 'ht_estimate', 'lon_tpx', 'lat_tpx', 'time_aviso')
  ntime=length(time_aviso);
  nlon_tpx=length(lon_tpx);
  nlat_tpx=length(lat_tpx);
  ht_error=nans(nlon_tpx,nlat_tpx,ntime);
  scale_total=nans(nbasin,ntime);
  scale_total_median=scale_total;

  eval(['hold_out_mat=hold_out_mat_',layer_name,';'])
   eval(['ht_estimate_all=ht_estimate_',layer_name,';'])
   eval(['ht_all=ht_',layer_name,';'])

   eval(['clear ','ht_',layer_name,' ht_estimate_',layer_name,' hold_out_mat_',layer_name])
    yr_all=hold_out_mat(:,1);
    lon_all=hold_out_mat(:,2);
    lat_all=hold_out_mat(:,3);
   clear hold_out_mat
     maskj=ones(nlon_tpx,nlat_tpx);
    
    depth_min=layer_bounds(ilayer-1);
    depth_max=layer_bounds(ilayer);
    
    shallow=topo_tpx_new < depth_min;
    mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
    

    maskj(mid)=maskj(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
    maskj(shallow)=NaN;


    pos_aviso_180=lon_tpx>180;

    lon_tpx_180=[lon_tpx(pos_aviso_180)-360 ; lon_tpx(~pos_aviso_180)];
    lon_tpx_180_no_shift=lon_tpx;
    lon_tpx_180_no_shift(pos_aviso_180)=lon_tpx_180_no_shift(pos_aviso_180)-360;

    [LON,LAT]=ndgrid(lon_tpx,lat_tpx);
    [LON_180,~]=ndgrid(lon_tpx_180,lat_tpx);
    [LON_180_W,~]=ndgrid(lon_tpx_180_no_shift,lat_tpx);
    
    [global_basins_aviso]=find_basin_paige(LON,LAT);
   

[w_art,w_atl]=find_atlantic_artic_overlap_weights(global_basins_aviso,LON_180_W,LAT);


pos_2d_pac_ind=global_basins_aviso(2).pos & global_basins_aviso(1).pos;
pos_2d_atl_ind=global_basins_aviso(5).pos & global_basins_aviso(1).pos;
pos_2d_pac_atl=global_basins_aviso(5).pos & global_basins_aviso(2).pos;


delta_time_var=2;
delta_time_error=delta_time_var./2;
   for itime=1:ntime

      good_time=yr_all>=time_aviso(itime)-delta_time_error./2 & yr_all<=time_aviso(itime)+delta_time_error./2;
      good_time_aviso=time_aviso>=time_aviso(itime)-delta_time_var./2 & time_aviso<=time_aviso(itime)+delta_time_var./2;
      time_win=time_aviso(good_time_aviso)-time_aviso(itime)-delta_time_var./2;
      han_window=.5*(1-cos(2.*pi.*(time_win)));
     

      yr=yr_all(good_time);
      lon=lon_all(good_time);
      lat=lat_all(good_time);
      var_holdout=nans(length(find(good_time)),1);
      ht_holdout=ht_all(good_time);
      ht_estimate_holdout=ht_estimate_all(good_time);
       [global_basins_holdout]=find_basin_paige(lon,lat);

%     ssh=hold_out_mat(:,4);
%     sst=hold_out_mat(:,5);
    


    pos_360=lon<0;
    lon_180=lon;
    lon(pos_360)=lon_180(pos_360)+360 ;
    good_180=lon_180>-90 & lon_180<90;

    %% load in the variance estimate and than interptert it to the loaction of 
    % the hold out estimates
    
     
     var_ht=var(ht_estimate(:,:,good_time_aviso),han_window,3,'omitnan');

   
    var_ht=var_ht.*maskj;
    

   
  
    var_ht_180=[var_ht(pos_aviso_180,:);var_ht(~pos_aviso_180,:)];
    F=griddedInterpolant(LON,LAT,var_ht);
      F_180=griddedInterpolant(LON_180,LAT,var_ht_180);
      jlon=lon(~good_180);
      jlat=lat(~good_180);
      jlon_180=lon_180(good_180);
      jlat_180=lat(good_180);
    
      var_holdout(~good_180,1)=F(jlon,jlat);
      var_holdout(good_180,1)=F_180(jlon_180,jlat_180);

      %%%

    ht_diff=ht_holdout-ht_estimate_holdout;
    
    
    ht_per_var=ht_diff.^2./(var_holdout);


%% sumup over basin

    


    scale_var=zeros(nlon_tpx,nlat_tpx);
    
    
    nbasin=length(global_basins_aviso);




    for ibasin=1:nbasin

           pos_2d=global_basins_aviso(ibasin).pos;
            pos_holdout=global_basins_holdout(ibasin).pos;

            if length(pos_holdout)>10
                 scale=nanmean(ht_per_var(pos_holdout));
                 scale_median=nanmedian(ht_per_var(pos_holdout));
            else % if there are less than 10 estimates of error use the mean
                scale=nanmean(ht_per_var);
                scale_median=nanmedian(ht_per_var);
            end
            scale_total(ibasin,itime)=scale;
            if isempty(scale_median) 
                scale_median=nan;
            end
            scale_total_median(ibasin,itime)=scale_median;

    %         global_basins_aviso(ibasin).name
           
            
           
            
            if ibasin==3
                weight_cross=w_art;
            elseif ibasin==5
                 weight_cross=w_atl;
            else
                 weight_cross=ones(nlon_tpx,nlat_tpx);
            end
            
        
            if ibasin==1
                
                ind_lon_atl_ind=12.0540;
                atl_lon_atl_ind=40.3434;
                length_lon_line_atl_ind=atl_lon_atl_ind-ind_lon_atl_ind;
                weight_cross(pos_2d_atl_ind)=(LON_180_W(pos_2d_atl_ind)-ind_lon_atl_ind)./length_lon_line_atl_ind;
                
                
                ind_lon_pac_ind=152.6829;
                pac_lon_pac_ind=125.0001;
                length_lon_line_pac_ind=ind_lon_pac_ind-pac_lon_pac_ind;
                weight_cross(pos_2d_pac_ind)=(ind_lon_pac_ind-LON_180_W(pos_2d_pac_ind))./length_lon_line_pac_ind;
                
            end
        
            if ibasin==2
                
                pac_lon_pac_atl=-57.3946;
                atl_lon_pac_atl=-74.6408;
                length_lon_line_pac_atl=pac_lon_pac_atl-atl_lon_pac_atl;
        
                weight_cross(pos_2d_pac_atl)=(pac_lon_pac_atl-LON_180_W(pos_2d_pac_atl))./length_lon_line_pac_atl;
                
                
                ind_lon_pac_ind=152.6829;
                pac_lon_pac_ind=125.0001;
                length_lon_line_pac_ind=ind_lon_pac_ind-pac_lon_pac_ind;
                weight_cross(pos_2d_pac_ind)=(LON_180_W(pos_2d_pac_ind)-pac_lon_pac_ind)./length_lon_line_pac_ind;
        
                
            end
        
            if ibasin==5
                
                pac_lon_pac_atl=-57.3946;
                atl_lon_pac_atl=-74.6408;
                length_lon_line_pac_atl=pac_lon_pac_atl-atl_lon_pac_atl;
                weight_cross(pos_2d_pac_atl)=(LON_180_W(pos_2d_pac_atl)-atl_lon_pac_atl)./length_lon_line_pac_atl;
                
                ind_lon_atl_ind=12.0540;
                atl_lon_atl_ind=40.3434;
                length_lon_line_atl_ind=atl_lon_atl_ind-ind_lon_atl_ind;
                weight_cross(pos_2d_atl_ind)=(atl_lon_atl_ind-LON_180_W(pos_2d_atl_ind))./length_lon_line_atl_ind;
        
                
            end

            scale_var(pos_2d)=nansum([scale_median.*weight_cross(pos_2d) scale_var(pos_2d)],2);
   
   

    end

    ht_error(:,:,itime)=sqrt(scale_var.*var_ht);
    

  

   end
 save([path_tree,tree_file_name_yearly_error,'_2xweight_7day_split.mat'], 'ht_error', ...
     'scale_total','scale_total_median','lon_tpx', 'lat_tpx', 'time_aviso',...
    '-v7.3')

end

