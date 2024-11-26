tree_model_file_name='tree_sst_tpx_year_1993';
tree_model_file_name='tree_sst_tpx_yearly';
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
file_name='argo_2020_10_14_QC';
file_WOD_suf='_cheng_EN4_2014';
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];







 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);



fname_nc=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name];
load(fname_nc);
load([fname_nc,'_sst.mat'],'sst')

ht_total.coords=coords;
ht_total.yr=yr;
for ilayer=nlayer:-1:2
    
    tic
   layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]

    
       
       [ht_estimate]=predict_basin_yearly(coords(:,1),coords(:,2),yr,tpx,sst,ilayer,tree_model_file_name);
       
       eval(['ht_estimate= ht_',layer_name,'-ht_estimate;'])
       
       eval(['ht_total.htdiff_tree_',layer_name,'=ht_estimate;'])

            

  
    
   toc./60
end

file_hdata_tree=[fname_nc,'_',tree_model_file_name,'.mat'];

save(file_hdata_tree,'-struct','ht_total','-v7.3')


