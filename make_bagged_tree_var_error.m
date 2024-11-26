tic
tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name_yearly=[tree_model_file_name_old,'_anom'];
tree_model_file_name=['tree_sst_tpx_all_year_seasonal_anom'];
path_oisst='C:\data\oisst\';
file_name_argo='pfloat_sal_greg_oct_2021_QC'
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);
file_name='argo_2020_10_14_QC';
file_name_season=[file_name,'_seasonal'];
file_name_season_anom=[file_name_season,'_anom'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];


var_start_year=2005;
var_end_year=2020;

% load in topo for data mask

load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new.mat','topo_tpx_new','lon_topo','lat_topo')
 topo_tpx_new=-1.*topo_tpx_new;
nlon=length(lon_topo);
nlat=length(lat_topo);

mask=ones(nlon,nlat);
for ilayer=2:nlayer
% make mask for each layer

maskj=mask;
    depth_min=layer_bounds(ilayer-1);
    depth_max=layer_bounds(ilayer);
    
    shallow=topo_tpx_new < depth_min;
    mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
    

    maskj(mid)=maskj(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
    maskj(shallow)=NaN;




 layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    tree_file_name=[tree_model_file_name,'_',layer_name];
    tree_file_name_yearly=[tree_model_file_name_yearly,'_',layer_name];
    load([path_tree,tree_file_name_yearly,'_7day.mat'], 'ht_estimate', 'lon_tpx', 'lat_tpx', 'time_aviso')
    ht_estimate_yearly=ht_estimate;
    time_aviso_yearly=time_aviso;

    load([path_tree,tree_file_name,'_7day.mat'], 'ht_estimate', 'lon_tpx', 'lat_tpx', 'time_aviso')

    for itime=1:ntime
     good=time_aviso>=var_start_year & time_aviso<=var_end_year;
     good_yearly=time_aviso_yearly>=var_start_year & time_aviso_yearly<=var_end_year;
    var_ht=var(ht_estimate(:,:,good),1,3,'omitnan');
    var_ht_yearly=var(ht_estimate_yearly(:,:,good_yearly),1,3,'omitnan');

    var_ht=var_ht.*maskj;
    var_ht_yearly=var_ht_yearly.*maskj;

   
% 
%     for it=1:length(time_aviso)
%         if time_aviso(it)>2010
%         time_aviso(it)
%         time_aviso_yearly(it)
%         figure(3)
%         pcolor(lon_tpx,lat_tpx,ht_estimate(:,:,it)')
%         caxis([-1 1]*1e8)
%         shading flat
%         figure(4)
%         pcolor(lon_tpx,lat_tpx,ht_estimate_yearly(:,:,it)')
%         caxis([-1 1]*1e8)
%         shading flat
%         pause
%         end
%     end
    end
    save([path_tree,tree_file_name,'_7day_var.mat'],'var_ht','var_ht_yearly','lon_tpx','lat_tpx','var_start_year','var_end_year')
    
end

