function bagged_tree_ohca_curve_combined_split_mask_max_NS_SH(TreeSetUp)
min_layer=0;
max_layer=2000;


load_TreeSetUp

tree_model_file_name_old=tree_model_file_name_season;

tree_model_file_name=tree_model_file_name_combined;


endlayer=find(layer_bounds==max_layer);
startlayer=find(layer_bounds==min_layer)+1;




for ioff=[50]
    load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new_max.mat','topo_tpx_new_max')
     topo_tpx_new=-1.*topo_tpx_new_max+ioff;
    
    ilayer=2;
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    tree_file_name=[tree_model_file_name,'_',layer_name];
    load([path_tree,tree_file_name,'_split_7day_mask.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
    nlon_tpx=length(lon_tpx);
    nlat_tpx=length(lat_tpx);
    ntime_tpx=length(time_aviso);
    
    tgrid=time_aviso;
    
    ht_out_total=nans(nlon_tpx,nlat_tpx,ntime_tpx);
    ht_out_total_south=ht_out_total;
    ht_out_total_north=ht_out_total;
    arw=areavec(lon_tpx,lat_tpx);
    layer_curve=nans(endlayer-startlayer+1,ntime_tpx);
    %compute basin curves
    [LON,LAT]=ndgrid(lon_tpx,lat_tpx);
    
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
        load([path_tree,tree_file_name,'_split_7day_mask.mat'], 'ht_estimate','time_aviso')
        load([path_tree,tree_file_name_old,'_seasonal_cycle_expand_split_mask.mat'],'ht_cycle','ht_mean')
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
      
       ht_out_total=jnansum(cat(4,ht_out_total,ht_out),4);

       ht_out_south=ht_estimate_south.*arwj;
      
       ht_out_total_south=jnansum(cat(4,ht_out_total_south,ht_out_south),4);

       ht_out_north=ht_estimate_north.*arwj;
      
       ht_out_total_north=jnansum(cat(4,ht_out_total_north,ht_out_north),4);
      
      
    
      
    
        
    
       toc./60
    
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    ht_curve=jnansum(ht_out_total,1);
    ht_curve=squeeze(jnansum(ht_curve,2));
    ht_curve_south=jnansum(ht_out_total_south,1);
    ht_curve_south=squeeze(jnansum(ht_curve_south,2));
    ht_curve_north=jnansum(ht_out_total_north,1);
    ht_curve_north=squeeze(jnansum(ht_curve_north,2));
    
   
    
    curve_name=['curve_',tree_prefix,'_0_2000_split_mask_max_SH_NH_W_',num2str(ioff),'.mat'];
    
    save ([path_tree,curve_name], 'tgrid', 'ht_curve','ht_curve_north','ht_curve_south');
end