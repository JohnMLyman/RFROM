function bagged_tree_ohca_curve_split_max_old_SH_NH
min_layer=0;
max_layer=2000;
 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];

tree_model_file_name_season='tree_sst_tpx_yearly_overlap_seasonal';
% tree_model_file_name_combined='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name_combined=['tree_sst_tpx_combined_seasonal_anom'];


tree_model_file_name_old=tree_model_file_name_season;

tree_model_file_name=tree_model_file_name_combined;
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
% % file_name='argo_2020_10_14_QC';
% file_name_season=[file_name,'_seasonal'];
% file_WOD_suf='_cheng_EN4_2014';
% file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];
% 




endlayer=find(layer_bounds==max_layer);
startlayer=find(layer_bounds==min_layer)+1;




for ioff=[50]
    load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new_max.mat','topo_tpx_new_max')
     topo_tpx_new=-1.*topo_tpx_new_max+ioff;
    
    ilayer=2;
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    tree_file_name=[tree_model_file_name,'_',layer_name];
    load([path_tree,tree_file_name,'_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
    nlon_tpx=length(lon_tpx);
    nlat_tpx=length(lat_tpx);
    ntime_tpx=length(time_aviso);
    
    tgrid=time_aviso;
    
    ht_out_total=nans(nlon_tpx,nlat_tpx,ntime_tpx);
    ht_out_total_south=ht_out_total;
    ht_out_total_north=ht_out_total;

    arw=areavec(lon_tpx,lat_tpx);
   
    %compute basin curves
    [LON,LAT]=ndgrid(lon_tpx,lat_tpx);
    [global_basins_aviso]=find_basin_paige(LON,LAT);
   
    
    
    [~,LATall,~]=ndgrid(lon_tpx,lat_tpx,tgrid);
    pos_north=LATall >= 0;

    clear LATall


    for ilayer=startlayer:endlayer
        tic
        layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
        arwj=arw;
        depth_min=layer_bounds(ilayer-1);
        depth_max=layer_bounds(ilayer);
        
        shallow=topo_tpx_new < depth_min;
        mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
        
    
        arwj(mid)=arwj(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
        arwj(shallow)=NaN;
    
        arwj=repmat(arwj,1,1,ntime_tpx);
        arwj=double(arwj);
    
    
        tree_file_name=[tree_model_file_name,'_',layer_name];
        tree_file_name_old=[tree_model_file_name_old,'_',layer_name];
        load([path_tree,tree_file_name,'_7day.mat'], 'ht_estimate','time_aviso')
        load([path_tree,tree_file_name_old,'_seasonal_cycle_expand.mat'],'ht_cycle','ht_mean')
        ht_estimate=ht_estimate+ht_cycle;

        ht_estimate_north=ht_estimate;
        ht_estimate_south=ht_estimate;
        ht_estimate_south(pos_north)=nan;
        ht_estimate_north(~pos_north)=nan;

        clear ht_cycle ht_mean
        
    %     for itime=1:nyears
    %         jyear=tgrid(itime);
    %         ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
    %     end
        
       ht_out=ht_estimate.*arwj;
       test_curve=jnansum(ht_out,1);
       test_curve=squeeze(jnansum(test_curve,2));
       ht_out_total=jnansum(cat(4,ht_out_total,ht_out),4);

       ht_out_south=ht_estimate_south.*arwj;
       test_curve_south=jnansum(ht_out_south,1);
       test_curve_south=squeeze(jnansum(test_curve_south,2));
       ht_out_total_south=jnansum(cat(4,ht_out_total_south,ht_out_south),4);

       ht_out_north=ht_estimate_north.*arwj;
       test_curve_north=jnansum(ht_out_north,1);
       test_curve_north=squeeze(jnansum(test_curve_north,2));
       ht_out_total_north=jnansum(cat(4,ht_out_total_north,ht_out_north),4);
      
      
    
      
    
       
       toc./60
    
    end
    
    
    
    
    
    
    
    
    
    
    
    
    ht_curve=jnansum(ht_out_total,1);
    ht_curve=squeeze(jnansum(ht_curve,2));
    ht_curve_south=jnansum(ht_out_total_south,1);
    ht_curve_south=squeeze(jnansum(ht_curve_south,2));
    ht_curve_north=jnansum(ht_out_total_north,1);
    ht_curve_north=squeeze(jnansum(ht_curve_north,2));


    
%     figure(4)
%     plot(tgrid,ht_curve./1e21)
    
    curve_name=['curve_0_2000_SH_NH_W_',num2str(ioff),'.mat'];
    
    save ([path_tree,curve_name], 'tgrid', 'ht_curve','ht_curve_north','ht_curve_south');
end