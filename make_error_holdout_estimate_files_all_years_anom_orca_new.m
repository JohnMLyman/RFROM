function []=make_error_holdout_estimate_files_all_years_anom_orca_new(TreeSetUp)


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
path_error=TreeSetUp.path_error;

path_new_tree_season=TreeSetUp.path_new_tree_season;
path_new_tree_yearly=TreeSetUp.path_new_tree_yearly;
path_new_tree_all_year=TreeSetUp.path_new_tree_all_year;

path_new_error_season=TreeSetUp.path_new_error_season;
path_new_error_yearly=TreeSetUp.path_new_error_yearly;
path_new_error_all_year=TreeSetUp.path_new_error_all_year;

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

tree_model_file_name=tree_model_file_name_all_year;

path_new_tree=path_new_tree_all_year;
path_new_error=path_new_error_all_year;
 nlayer=length(layer_bounds);

if ~exist(path_new_error,'dir')
    mkdir(path_new_error)
end


parfor ilayer=2:nlayer
    
    tic
   layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   file_hold_out=[path_new_tree,tree_model_file_name,'_hold_out_data_',layer_name,'_split.mat'];
   [hold_out_mat,ht_hold_out]=parload_holdout(file_hold_out);


    yr=hold_out_mat(:,1);
    lon=hold_out_mat(:,2);
    lat=hold_out_mat(:,3);
    ssh=hold_out_mat(:,4);
    sst=hold_out_mat(:,5);

    [ht_estimate]=predict_basin_all_years_split(lon,lat,yr,ssh,sst,layer_name,...
        tree_model_file_name,path_new_tree);
  
   
%    filename_junk=[path_new_tree,tree_model_file_name,'_hold_out_estiamte_split_',layer_name,'.mat'];
     filename_junk=[path_new_error, tree_model_file_name,'_hold_out_estiamte_split_',layer_name,'.mat'];

   parsave_holdout_estimate(filename_junk,ht_estimate,ht_hold_out,hold_out_mat)
   
%    eval(['ht_total.ht_estimate_',layer_name,'=ht_estimate;'])
%    eval(['ht_total.hold_out_mat_',layer_name,'=hold_out_mat;'])
%    eval(['ht_total.ht_',layer_name,'=ht_hold_out;']);

        

  
    
   
end
% file_hold_out_estimate=[path_new_tree,tree_model_file_name,'_hold_out_estiamte_split.mat'];
% 
% save(file_hold_out_estimate,'-struct','ht_total','-v7.3')
toc./60
end
function parsave_holdout_estimate(filename,ht_estimate,ht_hold_out,hold_out_mat)
%          ht_estimate=single(ht_estimate);

         save (filename,'ht_estimate','ht_hold_out', 'hold_out_mat','-v7.3')

end
function pardelete_tree(filename)

         delete(filename)

end
function [model_all]=parload_model(filename)
    
    load(filename,'model_all')     
end

function [hold_out_mat,ht_hold_out]=parload_holdout(filename)
    
    load(filename,'hold_out_mat','ht_hold_out')     
end




