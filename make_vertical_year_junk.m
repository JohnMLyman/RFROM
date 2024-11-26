function [ht_estimate_vert,lat_tpx,lon_tpx,time_aviso]=...
    make_vertical_year_junk(path_tree,tree_model,year_load,TreeSetUp)



var_type=TreeSetUp.var_type;
layer_bounds=TreeSetUp.layer_bounds;



%%
% tree_model=tree_model_file_name_season;
%%
ht_estimate_vert=[];

nlayer=length(layer_bounds);
load('D:\data\topo_tpx_new.mat','topo_tpx_new')

 topo_tpx_new=-1.*topo_tpx_new;

for ilayer=2:2

    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    tree_file_name_out=[tree_model,'_',layer_name,'_',num2str(year_load)];
    
    load([path_tree,tree_file_name_out,'_split_7day_junk.mat'] ,'ht_estimate_year','lon_tpx', 'lat_tpx','time_aviso')
    nlon_tpx=length(lon_tpx);
    nlat_tpx=length(lat_tpx);

    scale=ones(nlon_tpx,nlat_tpx);
   
    depth_min=layer_bounds(ilayer-1);
    depth_mean=(layer_bounds(ilayer-1)+layer_bounds(ilayer))/2.;
    %     depth_max=layer_bounds(ilayer);
    
    shallow=topo_tpx_new < depth_min;
    %find depths that are shallower than the mean depth/pressure of the layer 
   
    

    if var_type=='t' || var_type=='s'
       mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_mean;
       scale(mid)=NaN;
   
    else
        % this is the case for a vertical integral like heat content it is
        % likely to fail here because no var.type
        depth_max=layer_bounds(ilayer);
        mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
        scale(mid)=scale(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
    end
    
    scale(shallow)=NaN;
    

    
    ht_estimate_year=ht_estimate_year.*scale;
    ht_estimate_vert=cat(4,ht_estimate_vert,ht_estimate_year);
 
end



ht_estimate_vert=permute(ht_estimate_vert,[ 1 2 4 3]);

