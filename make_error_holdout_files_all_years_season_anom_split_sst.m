function []=make_error_holdout_files_all_years_season_anom_split_sst(TreeSetUp)
load_TreeSetUp

tree_model_file_name=tree_model_file_name_all_year;

path_new_tree=path_new_tree_all_year;

 nlayer=length(layer_bounds);



for ilayer=2:nlayer
    
    tic
   layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   file_hold_out=[path_new_tree,tree_model_file_name,'_hold_out_data_',layer_name,'_split.mat'];
   load(file_hold_out);

    yr=hold_out_mat(:,1);
    lon=hold_out_mat(:,2);
    lat=hold_out_mat(:,3);
    sst=hold_out_mat(:,4);
    

    [ht_estimate]=predict_basin_all_years_split_sst(lon,lat,yr,sst,layer_name,...
        tree_model_file_name,path_new_tree);
  
   
   
   
   eval(['ht_total.ht_estimate_',layer_name,'=ht_estimate;'])
   eval(['ht_total.hold_out_mat_',layer_name,'=hold_out_mat;'])
   eval(['ht_total.ht_',layer_name,'=ht_hold_out;']);

        

  
    
   toc./60
end
file_hold_out_estimate=[path_new_tree,tree_model_file_name,'_hold_out_estiamte_split.mat'];

save(file_hold_out_estimate,'-struct','ht_total','-v7.3')


