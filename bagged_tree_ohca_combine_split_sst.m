function []=bagged_tree_ohca_combine_split_sst(TreeSetUp)

load_TreeSetUp





nlayers=length(layer_bounds);





tic
for ilayer=2:nlayers
   
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    
    tree_file_name_all_year=[tree_model_file_name_all_year,'_',layer_name];
    tree_file_name_combined=[tree_model_file_name_combined,'_',layer_name];
   
    copyfile([path_tree,tree_file_name_all_year,'_split_7day.mat'],...
    open([path_tree,tree_file_name_combined,'_split_7day.mat'],ht_estimate)
    
  

  
   toc./60

end




