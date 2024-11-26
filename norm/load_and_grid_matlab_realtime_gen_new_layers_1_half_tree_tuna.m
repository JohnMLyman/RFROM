%load_and_grid_matlab
function [iyear]=load_and_grid_matlab_realtime_gen_new_layers_1_half_tree_tuna(file_path,file_name,tree_model_file_name,depth_layer,lat_grid,lon_grid,time_grid)

load([file_path,file_name],['htdiff_',depth_layer],'tpx', 'yr', 'coords', ['ht_',depth_layer])
load([file_path,file_name,'_',tree_model_file_name,'.mat'],['htdiff_tree_',depth_layer])




ntime=length(time_grid);
nlon=length(lon_grid);
nlat=length(lat_grid);

ht_out=ones(nlon,nlat,ntime)*NaN;
htdiff_out=ht_out;
one_out=ht_out;
error_out=ht_out;
tpx_out=ht_out;
htdiff_tree_out=ht_out;




%% 

tic,for iyear=1:ntime
    depth_layer
    iyear
    

    max_year=(time_grid(iyear))+.5;
    min_year=(time_grid(iyear))-.5;
    good_data=find((yr >= min_year) & (yr < max_year));
    ngood=length(good_data);
    one_map=ones(1,ngood);
    data=ones(ngood,5)*NaN;
    
    eval(['data(:,1)=ht_',depth_layer,'(good_data);']);
    eval(['data(:,2)=htdiff_',depth_layer,'(good_data);']);
%     data(:,2)=htdiff_100(good_data);
    data(:,3)=one_map;
    data(:,4)=tpx(good_data);
    eval(['data(:,5)=htdiff_tree_',depth_layer,'(good_data);']);
    time_junk=yr(good_data);
    cds_junk=coords(good_data,:);
    toc,'before objective map'
    [data_grid]=objective_map_annual_tuna(lon_grid,lat_grid,data,cds_junk);
    toc,'out of objective map'
    ht_out(:,:,iyear)=data_grid(:,:,1);
    
     htdiff_out(:,:,iyear)=data_grid(:,:,2);
      one_out(:,:,iyear)=data_grid(:,:,3);
       tpx_out(:,:,iyear)=data_grid(:,:,4);
        htdiff_tree_out(:,:,iyear)=data_grid(:,:,5);
      clear data_grid data
      toc,'next step'
end



time=time_grid';
ht=ht_out;
htdiff=htdiff_out;
htdiff_tree=htdiff_tree_out;
tpx=tpx_out;
one=one_out;
lon=lon_grid';
lat=lat_grid';
file_name_out=[file_name,num2str(time_grid(1)-.5),'_',num2str(time_grid(end)-.5)];
eval(['save ',file_path,file_name_out,'_',depth_layer,'_tree_half.mat ht htdiff htdiff_tree tpx one lon lat time'])


    
