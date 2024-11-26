function []=baggedtree_hold_out_yearly_overlap_seasonal_split_new_sal_greg(TreeSetUp)

% Loads Set up
load_TreeSetUp_new_sal

fname_nc=fname_nc_season;
load(fname_nc);


if ~exist([fname_nc,'_sst.mat'],'file')
    [sst]=find_oisst_4_mean(coords(:,1),coords(:,2),yr);
    save([fname_nc,'_sst.mat'],'sst','coords','yr','-v7.3')
else
    load([fname_nc,'_sst.mat'],'sst')
end




 nlayer=length(layer_bounds);

if ~exist(path_new_tree_season,'dir')
    mkdir(path_new_tree_season)
end







% start_year=2004;
% end_year=2021;

coords_old=coords;
tpx_old=tpx;
sst_old=sst;
yr_old=yr;
layer_offset_old=zeros(size(tpx));


for iyear_mod=start_year_mean:.5:end_year_mean
    
     year_file_name=num2str(10*iyear_mod)

    for ilayer=2:nlayer
        coords=coords_old;
        tpx=tpx_old;
        sst=sst_old;
        yr=yr_old;
        layer_offset=layer_offset_old;
tic
%%         

        layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
        
        
        eval(['ht_use=',var_type,'_',layer_name,';'])
        eval(['temp_use=t_',layer_name,';'])
        
        
        top_level_use=min(ilayer-1,nlayer_use+1)-1;
        bot_level_use=min(nlayer-ilayer,nlayer_use);

        nextra_layers=top_level_use+bot_level_use;

       
       ilayer
        % compute the shallow layer temp
            for ilayer_extra=1:top_level_use
                ilayer_off=ilayer-ilayer_extra;
                layer_name_extra=[num2str(layer_bounds(ilayer_off-1)),'_',num2str(layer_bounds(ilayer_off))]
                eval(['temp_use_junk=t_',layer_name_extra,';'])
                eval(['ht_use_junk=',var_type,'_',layer_name_extra,';'])
                temp_use=cat(1,temp_use,temp_use_junk);
                coords=cat(1,coords,coords_old);
                tpx=cat(1,tpx,tpx_old);
                sst=cat(1,sst,sst_old);
                yr=cat(1,yr,yr_old);
                ht_use=cat(1,ht_use,ht_use_junk);
                layer_offset=cat(1,layer_offset,layer_offset-ilayer_extra);

            end

        % compute the deep layer temp
        for ilayer_extra=1:bot_level_use
            ilayer_off=ilayer+ilayer_extra;
            layer_name_extra=[num2str(layer_bounds(ilayer_off-1)),'_',num2str(layer_bounds(ilayer_off))]
            eval(['temp_use_junk=t_',layer_name_extra,';'])
            eval(['ht_use_junk=',var_type,'_',layer_name_extra,';'])
            temp_use=cat(1,temp_use,temp_use_junk);
            coords=cat(1,coords,coords_old);
            tpx=cat(1,tpx,tpx_old);
            sst=cat(1,sst,sst_old);
            yr=cat(1,yr,yr_old);
            ht_use=cat(1,ht_use,ht_use_junk);
            layer_offset=cat(1,layer_offset,layer_offset+ilayer_extra);
        end




%% 
             
    
        % hold out 10% of good data for each layer
        nprof=length(coords(:,1));
        use=true(nprof,1);
        hold_out=false(nprof,1);


        good_yr=(yr>=iyear_mod-.5 & yr< iyear_mod+.5);    
        good_prof=isfinite(ht_use);
        pos_ht_finite=find(good_prof&good_yr);
        n_finite=length(pos_ht_finite);
        ranpos=randperm(n_finite);
        nhold=floor(0.1*n_finite);
        use(pos_ht_finite(ranpos(1:nhold)))=0;
        hold_out(pos_ht_finite(ranpos(1:nhold)))=1;
        clear pos_ht_finite ranpos
        
    
    
    
    
        test_tree_year_mean_split_sal_greg
        
        file_big_model=[path_new_tree_season,tree_model_file_name_season,'_model_',layer_name,'_',year_file_name,'_split.mat'];
%         file_compact_model=[path_new_tree,tree_model_file_name_season,'_compact_model_',layer_name,'_',year_file_name,'.mat'];
        
%         save(file_compact_model,'compact_model_all','-v7.3')
        save(file_big_model,'model_all','-v7.3')
        
        clear model_all compact_model_all
        
    
        file_hold_out=[path_new_tree_season,tree_model_file_name_season,'_hold_out_data_',layer_name,'_',year_file_name,'_split.mat'];
        
        
        
        hold_out_mat=nans(nhold,7);
        hold_out_mat(:,1)=yr(hold_out);
        hold_out_mat(:,2)=coords(hold_out,1);
        hold_out_mat(:,3)=coords(hold_out,2);
        hold_out_mat(:,4)=tpx(hold_out);
        hold_out_mat(:,5)=sst(hold_out);
        hold_out_mat(:,6)=temp_use(hold_out);
        hold_out_mat(:,7)=layer_offset(hold_out);

        % input the shallow layer temp for holdout
       



        
        ht_hold_out=ht_use(hold_out);

        save(file_hold_out,'hold_out_mat','ht_hold_out','-v7.3')
    
      
        
       toc./60
    end
end



