function baggedtree_yearly_overlap_seasonal_split_orca_sal_mean_nossh(TreeSetUp)


nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;


file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;


tree_prefix_temp=TreeSetUp.tree_prefix_temp;
path_mat_nc=TreeSetUp.path_mat_nc;

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
nlayer_use=TreeSetUp.nlayer_use;
%%


% tree_model_file_name=tree_model_file_name_yearly;
fname_nc=fname_nc_season;
% path_new_tree=path_new_tree_yearly;
start_year=start_yearly_maps;
end_year=end_yearly_maps;

nlayer=length(layer_bounds);


coords=[];
tpx=[];
yr=[];
sst=[];

load(fname_nc);

nlayer=length(layer_bounds);

if ~exist([fname_nc,'_sst.mat'],'file')
    [sst]=find_oisst_4_mean_orca(coords(:,1),coords(:,2),yr,path_oisst);
    save([fname_nc,'_sst.mat'],'sst','coords','yr','-v7.3')
else
    load([fname_nc,'_sst.mat'],'sst')
end

ht_all_junk=cell(nlayer-1,1);
temp_all_junk=cell(nlayer-1,1);
layer_off_all_junk=cell(nlayer-1,1);
use_all_junk=cell(nlayer-1,1);
nextra_all_junk=zeros(1,nlayer-1);
if ~exist(path_new_tree_season,'dir')
    mkdir(path_new_tree_season)
end



coords_old=coords;
tpx_old=tpx;
sst_old=sst;
yr_old=yr;
layer_offset_old=zeros(size(tpx));


for ilayer=2:nlayer

    coords=coords_old;
    tpx=tpx_old;
    sst=sst_old;
    yr=yr_old;
    layer_offset=layer_offset_old;
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    
    
   
     ht_use=eval([var_type,'_',layer_name]);
     temp_use=eval(['t_',layer_name]);
    
    top_level_use=min(ilayer-1,nlayer_use+1)-1;
    bot_level_use=min(nlayer-ilayer,nlayer_use);
%%
    % compute top layer
    for ilayer_extra=1:top_level_use
        ilayer_off=ilayer-ilayer_extra;
        layer_name_extra=[num2str(layer_bounds(ilayer_off-1)),'_',num2str(layer_bounds(ilayer_off))];
        ht_use_junk=eval([var_type,'_',layer_name_extra]);
        temp_use_junk=eval(['t_',layer_name_extra]);
        temp_use=cat(1,temp_use,temp_use_junk);
        coords=cat(1,coords,coords_old);
        tpx=cat(1,tpx,tpx_old);
        sst=cat(1,sst,sst_old);
        yr=cat(1,yr,yr_old);
        ht_use=cat(1,ht_use,ht_use_junk);
        layer_offset=cat(1,layer_offset,layer_offset_old-ilayer_extra);
        nextra_all_junk(ilayer-1)=nextra_all_junk(ilayer-1)+1;
    
    end

        % compute the deep layer temp
    for ilayer_extra=1:bot_level_use
        ilayer_off=ilayer+ilayer_extra;
        layer_name_extra=[num2str(layer_bounds(ilayer_off-1)),'_',num2str(layer_bounds(ilayer_off))];
        ht_use_junk=eval([var_type,'_',layer_name_extra]);
        temp_use_junk=eval(['t_',layer_name_extra]);
        
        temp_use=cat(1,temp_use,temp_use_junk);
        coords=cat(1,coords,coords_old);
        tpx=cat(1,tpx,tpx_old);
        sst=cat(1,sst,sst_old);
        yr=cat(1,yr,yr_old);
        ht_use=cat(1,ht_use,ht_use_junk);
        layer_offset=cat(1,layer_offset,layer_offset_old+ilayer_extra);
        nextra_all_junk(ilayer-1)=nextra_all_junk(ilayer-1)+1;
    end
%%
    ht_all_junk{ilayer-1}=ht_use;
    temp_all_junk{ilayer-1}=temp_use;
    layer_off_all_junk{ilayer-1}=layer_offset;
    nprof=length(coords(:,1));
    good_all_yr=(yr>start_year-.5 & yr<= end_year+.5);

    % hold out 10% of good data for each layer
    % hold out the same profiles every year
    ht_use=ht_all_junk{ilayer-1}; 
    good_prof=isfinite(ht_use)&isfinite(temp_use);
    main_layer=layer_offset==0;
    use=true(nprof,1);
    
    hold_out=false(nprof,1);
    
    
    pos_ht_finite=find(good_prof&good_all_yr&main_layer);
    n_finite=length(pos_ht_finite);
    ranpos=randperm(n_finite);
    nhold=floor(0.1*n_finite);
    use(pos_ht_finite(ranpos(1:nhold)))=0;
    hold_out(pos_ht_finite(ranpos(1:nhold)))=1;
    
     
    clear pos_ht_finite ranpos
    
    file_hold_out=[path_new_tree_season,tree_model_file_name_season,'_hold_out_data_',layer_name,'_split.mat'];
    
    
    
    hold_out_mat=nans(nhold,5);
    hold_out_mat(:,1)=yr(hold_out);
    hold_out_mat(:,2)=coords(hold_out,1);
    hold_out_mat(:,3)=coords(hold_out,2);
    hold_out_mat(:,4)=tpx(hold_out);
    hold_out_mat(:,5)=sst(hold_out);
    hold_out_mat(:,6)=temp_use(hold_out);
    hold_out_mat(:,7)=layer_offset(hold_out);
    ht_hold_out=ht_use(hold_out);
    
    %             save(file_hold_out,'hold_out_mat','ht_hold_out','-v7.3')
     parsave_holdout(file_hold_out,hold_out_mat,ht_hold_out)
     use_all_junk{ilayer-1}=use;


end
clearvars 'good_prof' 'ht_use' 'use'





 










for iyear_mod=start_year:.5:end_year
     
     year_file_name=num2str(10*iyear_mod)
tic
    parfor ilayer=2:nlayer
% for ilayer=2:nlayer
        coords=coords_old;
%         tpx=tpx_old;
%         sst=sst_old;
        yr=yr_old;
        layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
        
       
       ht_use=ht_all_junk{ilayer-1}; 
       temp_use=temp_all_junk{ilayer-1};
       layer_offset=layer_off_all_junk{ilayer-1};
        use=use_all_junk{ilayer-1};
        good_prof=isfinite(ht_use);
        for ilayer_extra_junk=1:nextra_all_junk(ilayer-1)
            
            coords=cat(1,coords,coords_old);
%             tpx=cat(1,tpx,tpx_old);
%             sst=cat(1,sst,sst_old);
            yr=cat(1,yr,yr_old);
            
        end
        good_yr=(yr>iyear_mod-.5 & yr<= iyear_mod+.5);
              
    
%         [model_all]=make_trees_mean(use,ht_use,tpx,sst,coords,yr,nbasins_use,good_yr,good_prof);
        [model_all]=make_trees_mean_sal_nosstssh(use,ht_use,temp_use,layer_offset,coords,yr,nbasins_use,good_yr,good_prof);
        
    
        file_big_model=[path_new_tree_season,tree_model_file_name_season,'_model_',layer_name,'_',year_file_name,'_split.mat'];

        parsave_model_all(file_big_model,model_all)

        
    
      
        
    
    end
       toc./60
end
end

function parsave_holdout(filename,hold_out_mat,ht_hold_out)
         

         save (filename,'hold_out_mat','ht_hold_out','-v7.3')

end

function parsave_model_all(filename,model_all)
         

         save (filename,'model_all','-v7.3')

end



