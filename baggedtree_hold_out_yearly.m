tree_model_file_name='tree_sst_tpx_yearly';
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
file_name='argo_2020_10_14_QC';
file_WOD_suf='_cheng_EN4_2014';
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];


fname_nc=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name];
load(fname_nc);


if ~exist([fname_nc,'_sst.mat'],'file')
    [sst]=find_oisst_4(coords(:,1),coords(:,2),yr);
    save([fname_nc,'_sst.mat'],'sst','coords','yr','-v7.3')
else
    load([fname_nc,'_sst.mat'],'sst')
end




 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);

if ~exist(path_new_tree,'dir')
    mkdir(path_new_tree)
end


nprof=length(coords(:,1));




start_year=1993;
end_year=2021;

for iyear_mod=start_year:end_year
     good_yr=(floor(yr)==iyear_mod);
     year_file_name=num2str(iyear_mod)

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
        
    
    
    
    
        test_tree_year_mean
        
        file_big_model=[path_new_tree,tree_model_file_name,'_model_',layer_name,'_',year_file_name,'.mat'];
        file_compact_model=[path_new_tree,tree_model_file_name,'_compact_model_',layer_name,'_',year_file_name,'.mat'];
        
%         save(file_compact_model,'compact_model_all','-v7.3')
        save(file_big_model,'model_all','-v7.3')
        
        clear model_all compact_model_all
        
    
        file_hold_out=[path_new_tree,tree_model_file_name,'_hold_out_data_',layer_name,'_',year_file_name,'.mat'];
        
        
        
        hold_out_mat=nans(nhold,5);
        hold_out_mat(:,1)=yr(hold_out);
        hold_out_mat(:,2)=coords(hold_out,1);
        hold_out_mat(:,3)=coords(hold_out,2);
        hold_out_mat(:,4)=tpx(hold_out);
        hold_out_mat(:,5)=sst(hold_out);
        
        save(file_hold_out,'hold_out_mat','-v7.3')
    
      
        
       toc./60
    end
end



