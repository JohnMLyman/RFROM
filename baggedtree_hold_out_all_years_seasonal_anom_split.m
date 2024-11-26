function []=baggedtree_hold_out_all_years_seasonal_anom_split(TreeSetUp)

load_TreeSetUp

tree_model_file_name=tree_model_file_name_all_year;

path_new_tree=path_new_tree_all_year;

nlayer=length(layer_bounds);


if ~exist([fname_nc,'.mat'],'file')
%      load(fname_nc_season);% interptpx_seasonal_anom_tuna_split_new now
%     loads the fnname_nc_season
    interptpx_seasonal_anom_tuna_split
%     mapdiff?  write if want diffenece estimate.
else
    load(fname_nc)
end





if ~exist([fname_nc,'_sst.mat'],'file')
    [sst]=find_oisst_4(coords(:,1),coords(:,2),yr);
    save([fname_nc,'_sst.mat'],'sst','coords','yr','-v7.3')
else
    load([fname_nc,'_sst.mat'],'sst')
end




 
if ~exist(path_new_tree,'dir')
    mkdir(path_new_tree)
end


nprof=length(coords(:,1));





good_yr=(yr>start_year-.5 & yr<= end_year+.5);
    

for ilayer=2:nlayer
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    
    tic
    eval(['ht_use=ht_',layer_name,';'])
         

    % hold out 10% of good data for each layer
    use=true(nprof,1);
    hold_out=false(nprof,1);

    good_prof=isfinite(ht_use);
    pos_ht_finite=find(good_prof&good_yr);
    n_finite=length(pos_ht_finite);
    ranpos=randperm(n_finite);
    nhold=floor(0.1*n_finite);
    use(pos_ht_finite(ranpos(1:nhold)))=0;
    hold_out(pos_ht_finite(ranpos(1:nhold)))=1;
    clear pos_ht_finite ranpos
    




    test_tree_year_mean_split
    
    file_big_model=[path_new_tree,tree_model_file_name,'_model_',layer_name,'_split.mat'];
    file_compact_model=[path_new_tree,tree_model_file_name,'_compact_model_',layer_name,'_split.mat'];
    
    save(file_compact_model,'compact_model_all','-v7.3')
    save(file_big_model,'model_all','-v7.3')
    
    clear model_all compact_model_all
    

    file_hold_out=[path_new_tree,tree_model_file_name,'_hold_out_data_',layer_name,'_split.mat'];
    
    
    
    hold_out_mat=nans(nhold,5);
    hold_out_mat(:,1)=yr(hold_out);
    hold_out_mat(:,2)=coords(hold_out,1);
    hold_out_mat(:,3)=coords(hold_out,2);
    hold_out_mat(:,4)=tpx(hold_out);
    hold_out_mat(:,5)=sst(hold_out);
    ht_hold_out=ht_use(hold_out);
    
    save(file_hold_out,'hold_out_mat','ht_hold_out','-v7.3')

  
    
   toc./60
end




