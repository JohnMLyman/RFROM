tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name=['tree_sst_tpx_all_year_seasonal_anom'];
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
% file_name='argo_2020_10_14_QC';
file_WOD_suf='_cheng_EN4_2014';
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];


% start_year=1993;
% end_year=2021;




 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);



for ilayer=2:nlayer
    
    tic
   layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   file_hold_out=[path_new_tree,tree_model_file_name,'_hold_out_data_',layer_name,'.mat'];
   load(file_hold_out);

    yr=hold_out_mat(:,1);
    lon=hold_out_mat(:,2);
    lat=hold_out_mat(:,3);
    ssh=hold_out_mat(:,4);
    sst=hold_out_mat(:,5);

    [ht_estimate]=predict_basin_all_years(lon,lat,yr,ssh,sst,layer_name,tree_model_file_name);
  
   
   
   
   eval(['ht_total.ht_estimate_',layer_name,'=ht_estimate;'])
   eval(['ht_total.hold_out_mat_',layer_name,'=hold_out_mat;'])
   eval(['ht_total.ht_',layer_name,'=ht_hold_out;']);

        

  
    
   toc./60
end
file_hold_out_estimate=[path_new_tree,tree_model_file_name,'_hold_out_estiamte.mat'];

save(file_hold_out_estimate,'-struct','ht_total','-v7.3')


