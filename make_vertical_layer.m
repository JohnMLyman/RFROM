function [ht_estimate_vert,lat_tpx,lon_tpx,time_aviso_vert]=...
    make_vertical_layer(path_tree,tree_model,layer_bounds,start_year,end_year,ilayer)

%




%%

% start_year=start_year_mean;
% end_year=end_year_mean;
% 
% tree_model=tree_model_file_name_season;

%%
start_year_ssh=floor(start_year);

if floor(start_year)==start_year
    start_year_ssh=start_year-1;
end

end_year_ssh=floor(end_year);

ht_estimate_vert=[];
time_aviso_vert=[];
for year_load=start_year_ssh:end_year_ssh
    
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    tree_file_name_out=[tree_model,'_',layer_name,'_',num2str(year_load)];
    
    load([path_tree,tree_file_name_out,'_split_7day.mat'] ,'ht_estimate_year','lon_tpx', 'lat_tpx','time_aviso')
    ht_estimate_vert=cat(3,ht_estimate_vert,ht_estimate_year);
    time_aviso_vert=cat(2,time_aviso_vert,time_aviso);
 
end




