




tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name_yearly=[tree_model_file_name_old,'_anom'];
tree_model_file_name_all_years=['tree_sst_tpx_all_year_seasonal_anom'];
tree_model_file_name_combined=['tree_sst_tpx_combined_seasonal_anom'];

path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
% file_name='argo_2020_10_14_QC';
path_tree=[path_OHCA_data_out,'OHCA_trees\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];
nlayers=length(layer_bounds);



start_year_trans=2006;
end_year_trans=2007;
delta_trans=end_year_trans-start_year_trans+1;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name_all_years=[tree_model_file_name_all_years,'_',layer_name];
load([path_tree,tree_file_name_all_years,'_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);
TIME=[];
TIME(1,1,:)=time_aviso;
TIME=repmat(TIME,nlon_tpx,nlat_tpx,1);
SCALE_ALL_YEARS=ones(nlon_tpx,nlat_tpx,ntime_tpx);
OVERLAP=TIME>=start_year_trans & TIME<=(end_year_trans+1);
SCALE_YEARLY=SCALE_ALL_YEARS;
SCALE_ALL_YEARS(OVERLAP)=(start_year_trans-TIME(OVERLAP)+delta_trans)./(delta_trans);
SCALE_ALL_YEARS(TIME>end_year_trans+1)=0;
SCALE_YEARLY(OVERLAP)=(TIME(OVERLAP)-start_year_trans)./(delta_trans);
SCALE_YEARLY(TIME<start_year_trans)=0;
clear TIME OVERLAP 
tic
for ilayer=2:nlayers
   
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    tree_file_name_yearly=[tree_model_file_name_yearly,'_',layer_name];
    tree_file_name_all_years=[tree_model_file_name_all_years,'_',layer_name];
    tree_file_name_combined=[tree_model_file_name_combined,'_',layer_name];
    
    load([path_tree,tree_file_name_yearly,'_7day.mat'], 'ht_estimate')
    ht_out=ht_estimate.*SCALE_YEARLY;
    clear ht_estiamte
    load([path_tree,tree_file_name_all_years,'_7day.mat'], 'ht_estimate')
    ht_estimate=sum(cat(4,ht_out,ht_estimate.*SCALE_ALL_YEARS),4,'omitnan');
    clear ht_out
    save([path_tree,tree_file_name_combined,'_7day.mat'],'ht_estimate','time_aviso','lon_tpx','lat_tpx','-v7.3')

    

  

  
   toc./60

end




