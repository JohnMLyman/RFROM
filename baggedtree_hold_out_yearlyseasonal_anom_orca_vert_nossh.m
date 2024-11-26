function []=baggedtree_hold_out_yearlyseasonal_anom_orca_vert_nossh(TreeSetUp)

% Loads Set up

nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;

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
ilayer_depth_use_sst=TreeSetUp.ilayer_depth_use_sst;


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

path_new_tree=path_tree_junk;
start_year=start_yearly_maps;
end_year=end_yearly_maps;

nlayer=length(layer_bounds);


coords=[];
tpx=[];
yr=[];
sst=[];






% if ~exist([fname_nc,'.mat'],'file')

    interptpx_seasonal_anom_tuna_split_new
% else
%     load(fname_nc);
% end


% if ~exist([fname_nc,'_sst.mat'],'file')
    [sst]=find_oisst_4_orca(coords(:,1),coords(:,2),yr,path_oisst);
    save([fname_nc,'_sst.mat'],'sst','coords','yr','-v7.3')
% else
%     load([fname_nc,'_sst.mat'],'sst')
% end

ht_all_junk=cell(nlayer,1);

use_all_junk=cell(nlayer-1,1);
nprof=length(coords(:,1));
good_all_yr=(yr>start_year_mean-.5 & yr<= end_year_mean+.5);
if ~exist(path_new_tree,'dir')
    mkdir(path_new_tree)
end


for ilayer=2:nlayer
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    ht_all_junk{ilayer-1}=eval([var_type,'_',layer_name]);
     % hold out 10% of good data for each layer
        % hold out the same profiles every year
%       ht_use=ht_all_junk{ilayer-1}; 
%      good_prof=isfinite(ht_use);
     use=true(nprof,1);

%             hold_out=false(nprof,1);
%         
%             
%             pos_ht_finite=find(good_prof&good_all_yr);
%             n_finite=length(pos_ht_finite);
%             ranpos=randperm(n_finite);
%             nhold=floor(0.1*n_finite);
%             use(pos_ht_finite(ranpos(1:nhold)))=0;
%             hold_out(pos_ht_finite(ranpos(1:nhold)))=1;
%            clear pos_ht_finite ranpos
% % 
%            file_hold_out=[path_new_tree_season,tree_model_file_name_season,'_hold_out_data_',layer_name,'_split.mat'];
% %        
%             
%             
%             hold_out_mat=nans(nhold,5);
%             hold_out_mat(:,1)=yr(hold_out);
%             hold_out_mat(:,2)=coords(hold_out,1);
%             hold_out_mat(:,3)=coords(hold_out,2);
%             hold_out_mat(:,4)=tpx(hold_out);
%             hold_out_mat(:,5)=sst(hold_out);
%             ht_hold_out=ht_use(hold_out);
%             
% %             save(file_hold_out,'hold_out_mat','ht_hold_out','-v7.3')
%              parsave_holdout(file_hold_out,hold_out_mat,ht_hold_out)
             use_all_junk{ilayer-1}=use;
% 
% 
end
% 
% clearvars 'good_prof' 'ht_use' 'use'
% 
% 
% 
% 
%  
% 
% 
% 
% 
parfor ilayer=2:nlayer

    for iyear_mod=start_year:.5:end_year
good_yr=(yr>iyear_mod-.5 & yr<= iyear_mod+.5);
year_file_name=num2str(10*iyear_mod)


layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]


   
ht_use=ht_all_junk{ilayer-1}; 
use=use_all_junk{ilayer-1};
good_prof=isfinite(ht_use);



if ilayer==2
    [model_all]=make_trees_mean(use,ht_use,tpx,sst,coords,yr,nbasins_use,good_yr,good_prof,'a');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_a_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

    [model_all]=make_trees_mean(use,ht_use,tpx,sst,coords,yr,nbasins_use,good_yr,good_prof,'b');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_b_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

    [model_all]=make_trees_mean(use,ht_use,tpx,sst,coords,yr,nbasins_use,good_yr,good_prof,'c');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_c_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

    [model_all]=make_trees_mean(use,ht_use,tpx,sst,coords,yr,nbasins_use,good_yr,good_prof,'d');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_d_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

elseif ilayer<=ilayer_depth_use_sst
    ht_predict=ht_all_junk{ilayer-2}; 
    good_prof=isfinite(ht_use)&isfinite(ht_predict);

    [model_all]=make_trees_mean_vert(use,ht_use,tpx,sst,ht_predict,coords,yr,nbasins_use,good_yr,good_prof,'a');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_a_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

     [model_all]=make_trees_mean_vert(use,ht_use,tpx,sst,ht_predict,coords,yr,nbasins_use,good_yr,good_prof,'b');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_b_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

     [model_all]=make_trees_mean_vert(use,ht_use,tpx,sst,ht_predict,coords,yr,nbasins_use,good_yr,good_prof,'c');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_c_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

     [model_all]=make_trees_mean_vert(use,ht_use,tpx,sst,ht_predict,coords,yr,nbasins_use,good_yr,good_prof,'d');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_d_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)
else
     ht_predict=ht_all_junk{ilayer-2}; 
    good_prof=isfinite(ht_use)&isfinite(ht_predict);

    [model_all]=make_trees_mean_vert_nosst_nossh(use,ht_use,ht_predict,coords,yr,nbasins_use,good_yr,good_prof,'a');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_a_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

     [model_all]=make_trees_mean_vert_nosst_nossh(use,ht_use,ht_predict,coords,yr,nbasins_use,good_yr,good_prof,'b');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_b_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

     [model_all]=make_trees_mean_vert_nosst_nossh(use,ht_use,ht_predict,coords,yr,nbasins_use,good_yr,good_prof,'c');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_c_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

     [model_all]=make_trees_mean_vert_nosst_nossh(use,ht_use,ht_predict,coords,yr,nbasins_use,good_yr,good_prof,'d');
    file_big_model=[path_new_tree,tree_model_file_name,'_model_d_',layer_name,'_',year_file_name,'_split.mat'];
    parsave_model_all(file_big_model,model_all)

end






end

end

end

function parsave_holdout(filename,hold_out_mat,ht_hold_out)
         

         save (filename,'hold_out_mat','ht_hold_out','-v7.3')

end

function parsave_model_all(filename,model_all)
         

         save (filename,'model_all','-v7.3')

end
