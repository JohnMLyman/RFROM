function []=bagged_tree_ohca_combine_split_sst_mask(TreeSetUp)

load_TreeSetUp

% IF YOU USE SPLIT path_tree_tpx will need to be cahanged to:
%    path_tree_tpx=[path_OHCA_data_out,'OHCA_trees\',tree_prefix_tpx,'\'];
% also the load statement will need to be changed to:
%       load([path_tree_tpx,tree_file_name_combined_tpx,'_split_7day.mat'],...
%         'ht_estimate','lon_tpx','lat_tpx','time_aviso')
% 

tree_prefix_tpx='tree_sst_tpx';
path_tree_tpx=[path_OHCA_data_out,'OHCA_trees\'];
tree_model_file_name_combined_tpx=[tree_prefix_tpx,'_combined_seasonal_anom'];

nlayers=length(layer_bounds);





tic
for ilayer=2:nlayers
   
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    
   
    tree_file_name_combined=[tree_model_file_name_combined,'_',layer_name];
    tree_file_name_combined_tpx=[tree_model_file_name_combined_tpx,'_',layer_name];

    

    load([path_tree_tpx,tree_file_name_combined_tpx,'_2_7day.mat'],...
        'ht_estimate','time_aviso')
   
    ht_mask=ht_estimate;
    time_mask=time_aviso;


    load([path_tree,tree_file_name_combined,'_split_7day.mat'],...
        'ht_estimate','lon_tpx','lat_tpx','time_aviso')

    [time_aviso,pos_est,pos_mask]=intersect(time_aviso,time_mask);
    

    ht_mask=ht_mask(:,:,pos_mask);
    ht_estimate=ht_estimate(:,:,pos_est);
    ht_estimate(isfinite(ht_mask))=nan;
    
   save([path_tree,tree_file_name_combined,'_split_7day_mask.mat'],...
        'ht_estimate','lon_tpx','lat_tpx','time_aviso','-v7.3')

  
   toc./60

end




