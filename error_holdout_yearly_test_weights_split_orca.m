
function []=error_holdout_yearly_test_weights_split_orca(TreeSetUp)


nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
% 
% file_name_season=[file_name,'_seasonal'];
% file_name_season_anom=[file_name_season,'_anom'];

path_oisst=TreeSetUp.path_oisst;
path_OHCA_data_out=TreeSetUp.path_OHCA_data_out;
path_OHCA_data_in=TreeSetUp.path_OHCA_data_in;
path_ssh=TreeSetUp.path_ssh;

path_tree=TreeSetUp.path_tree;
path_new_tree_season=TreeSetUp.path_new_tree_season;
path_new_tree_yearly=TreeSetUp.path_new_tree_yearly;
path_new_tree_all_year=TreeSetUp.path_new_tree_all_year;

path_tree_junk=TreeSetUp.path_tree_junk;
path_curve=TreeSetUp.path_curve;

layer_bounds=TreeSetUp.layer_bounds;

start_year=TreeSetUp.start_year;
end_year=TreeSetUp.end_year;

start_year_mean=TreeSetUp.start_year_mean;
end_year_mean=TreeSetUp.end_year_mean;
max_year_fit=TreeSetUp.max_year_fit;
min_year_fit=TreeSetUp.min_year_fit;
center_year=TreeSetUp.center_year;

start_yearly_maps=TreeSetUp.start_yearly_maps;
end_yearly_maps=TreeSetUp.end_yearly_maps;

start_all_year=TreeSetUp.start_all_year;
end_all_year=TreeSetUp.end_all_year;

start_year_trans=TreeSetUp.start_year_trans;
end_year_trans=TreeSetUp.end_year_trans;
%%




tree_model_file_name=tree_model_file_name_yearly;

path_new_tree=path_new_tree_yearly;



load('D:\data\topo_tpx_new.mat','topo_tpx_new','lon_topo','lat_topo')
 topo_tpx_new=-1.*topo_tpx_new;




% file_hold_out_estimate=[path_new_tree,tree_model_file_name,'_hold_out_estiamte_split.mat'];


%  load(file_hold_out_estimate)

 nlayer=length(layer_bounds);

tic

parfor ilayer=2:nlayer
    nbasin=10;
    fig_num=(ilayer-2)*10;
   layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   tree_file_name_yearly=[tree_model_file_name,'_',layer_name];
   tree_file_name_yearly_error=[tree_model_file_name,'_error_',layer_name];
%   load([path_tree,tree_file_name_yearly,'_split_7day.mat'], 'ht_estimate', 'lon_tpx', 'lat_tpx', 'time_aviso')
  [ht_estimate,time_aviso,lon_tpx,lat_tpx]=parload_tree([path_tree,tree_file_name_yearly,'_split_7day.mat']);
  ntime=length(time_aviso);
  nlon_tpx=length(lon_tpx);
  nlat_tpx=length(lat_tpx);
  ht_error=nans(nlon_tpx,nlat_tpx,ntime);
  scale_total=nans(nbasin,ntime);
  scale_total_median=scale_total;
   filename_holdout=[path_new_tree,tree_model_file_name,'_hold_out_estiamte_split_',layer_name,'.mat'];
  [ht_estimate_all,ht_all,hold_out_mat]=parload_holdout_estimate(filename_holdout);

%   eval(['hold_out_mat=hold_out_mat_',layer_name,';'])
%    eval(['ht_estimate_all=ht_estimate_',layer_name,';'])
%    eval(['ht_all=ht_',layer_name,';'])
% 
%    eval(['clear ','ht_',layer_name,' ht_estimate_',layer_name,' hold_out_mat_',layer_name])
    yr_all=hold_out_mat(:,1);
    lon_all=hold_out_mat(:,2);
    lat_all=hold_out_mat(:,3);
%    clear hold_out_mat
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
   for itime=2:ntime

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
                 scale=mean(ht_per_var(pos_holdout),'omitnan');
                 scale_median=median(ht_per_var(pos_holdout),'omitnan');
            else % if there are less than 10 estimates of error use the mean
                scale=mean(ht_per_var,'omitnan');
                scale_median=median(ht_per_var,'omitnan');
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

            scale_var(pos_2d)=sum([scale_median.*weight_cross(pos_2d) scale_var(pos_2d)],2,'omitnan');
   
   

    end

    ht_error(:,:,itime)=sqrt(scale_var.*var_ht);
    

  

   end
%  save([path_tree,tree_file_name_yearly_error,'_2xweight_7day_split.mat'], 'ht_error', ...
%      'scale_total','scale_total_median','lon_tpx', 'lat_tpx', 'time_aviso',...
%     '-v7.3')
parsave_error_estimate([path_tree,tree_file_name_yearly_error,'_2xweight_7day_split.mat'],ht_error,scale_total,...
    scale_total_median,lon_tpx, lat_tpx, time_aviso)
end


toc./60


end




function parsave_error_estimate(filename,ht_error,scale_total,...
    scale_total_median,lon_tpx, lat_tpx, time_aviso)
        ht_error=single(ht_error);

         save (filename, 'ht_error', 'scale_total','scale_total_median',...
             'lon_tpx', 'lat_tpx', 'time_aviso','-v7.3')

end
function [ht_estimate,time_aviso,lon_tpx,lat_tpx]=parload_tree(filename)
    
    load(filename,'ht_estimate','time_aviso','lon_tpx','lat_tpx')     
end
function [ht_estimate,ht_hold_out,hold_out_mat]=parload_holdout_estimate(filename)


         load (filename,'ht_estimate','ht_hold_out', 'hold_out_mat')

end

