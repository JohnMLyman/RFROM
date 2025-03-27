function read_ssh_matfiles_all_years_season_orca_vert_eqbox(TreeSetUp)

% Loads Set up
% load_TreeSetUp
%%
scale_box_deg_lat=TreeSetUp.scale_box_deg_lat;
scale_box_eq=TreeSetUp.scale_box_eq;
lat_change=TreeSetUp.lat_change;

nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;

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
ilayer_depth_use_ssh=TreeSetUp.ilayer_depth_use_ssh;


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

start_year=start_yearly_maps;
end_year=end_yearly_maps;
path_new_tree=path_new_tree_season;
tree_model=tree_model_file_name_season;

% set up the files sytem for reading ssh and sst
if ~exist(path_new_tree,'dir')
    mkdir(path_new_tree)
end

s_allfiles=dir([path_ssh,'matlab_files\new_ssh*.mat']);
s=s_allfiles;

sday_allfiles=strjust(strvcat(s_allfiles(:).name),'right');
sday_allfiles=str2num(sday_allfiles(:,end-8:end-4));
diff_sday_allfiles=sday_allfiles(3)-sday_allfiles(2);

if diff_sday_allfiles==7
    sday=sday_allfiles;
elseif diff_sday_allfiles==1
    sday=sday_allfiles(1:7:length(s_allfiles));
    s=s(1:7:length(s));
else
    disp('SSH files are not spaced correctly!! 1 or 7 day spacing!!')
    pause
end



sday=sday+datenum(1950,1,1);

if isfield(TreeSetUp,'data_type')
    switch TreeSetUp.data_type
        case ('NCAR') %no leapyear
             syr=(sday-1)./365;
             aviso_day=sday-365.*floor(syr)+1;
        otherwise
            datevec_sday=datevec(sday);
          aviso_day=sday-datenum(datevec_sday(:,1),1,1)+1;
         syr=datevec_sday(:,1)+(aviso_day-1)./yeardays(datevec_sday(:,1));
            
    end
else
  

    
    
    
    
    datevec_sday=datevec(sday);
    aviso_day=sday-datenum(datevec_sday(:,1),1,1)+1;
    syr=datevec_sday(:,1)+(aviso_day-1)./yeardays(datevec_sday(:,1));
end
%%
clear sday

load([s(1).folder,'\',s(1).name],'lat','lon')
lat_tpx=lat;
lon_tpx=lon;


clear lon lat



[weight_a,weight_b,weight_c,weight_d]=round_floor_weight_maps_eqbox(lon_tpx,lat_tpx,TreeSetUp);


nlat_tpx=length(lat_tpx);
nlon_tpx=length(lon_tpx);
lon_model=lon_tpx;
lon_model(lon_model>180)=lon_model(lon_model>180)-360;
        
% LON is from -180 to 180 because that is what is used to make the bagged
% tree  MUST use lon_tpx to output array, becuse I didn't shift the array
        
[LON,LAT]=ndgrid(lon_model,lat_tpx);
[global_basins_aviso]=find_basin_paige(LON,LAT);
[w_art,w_atl]=find_atlantic_artic_overlap_weights(global_basins_aviso,LON,LAT);

LON=single(LON);
LAT=single(LAT);


nlayer=length(layer_bounds);

time_ssh_load=floor(start_year):floor(end_year);





TreePredictInfo.scale_box_deg_lat=scale_box_deg_lat;
TreePredictInfo.scale_box_eq=scale_box_eq;
TreePredictInfo.lat_change=lat_change;


TreePredictInfo.start_year=start_year;
TreePredictInfo.end_year=end_year;
TreePredictInfo.global_basins_aviso=global_basins_aviso;
TreePredictInfo.nlon_tpx=nlon_tpx;
TreePredictInfo.nlat_tpx=nlat_tpx;
TreePredictInfo.LON=LON;
TreePredictInfo.LAT=LAT;
TreePredictInfo.w_art=w_art;
TreePredictInfo.w_atl=w_atl;
TreePredictInfo.nbasin_use=nbasins_use;
TreePredictInfo.path_new_tree=path_new_tree;
TreePredictInfo.tree_model=tree_model;
if ~exist(path_new_tree,'dir')

    mkdir(path_new_tree)
end

parfor year_load=time_ssh_load

    display(year_load)
    iyear_mod=year_load+.5;
%     [ssh_total,sst_total,time_aviso,nfiles]=read_totalssh_sshanom_sstanom_year(s,syr,aviso_day,path_oisst,nlon_tpx,nlat_tpx,year_load,TreeSetUp) ;
      [ssh_total,sst_total,time_aviso,nfiles]=read_totalssh_totalsst_year(s,syr,aviso_day,path_oisst,nlon_tpx,nlat_tpx,year_load,TreePredictInfo);

    for ilayer=2:nlayer
    
        layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
        tree_file_name_out=[tree_model,'_',layer_name,'_',num2str(year_load)];
        
        ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);  
        
  
        if ilayer==2
                
            file_big_model=[path_tree_junk,tree_model,'_model_a_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_SST_paige_eqbox_test(iyear_mod,...
                time_aviso,ssh_total,sst_total,...
                nfiles,ht_estimate_m,TreePredictInfo,file_big_model,'a','all') ;
            ht_estimate=ht_estimate_m.*weight_a;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);


            file_big_model=[path_tree_junk,tree_model,'_model_b_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_SST_paige_eqbox_test(iyear_mod,...
                time_aviso,ssh_total,sst_total,...
                nfiles,ht_estimate_m,TreePredictInfo,file_big_model,'b','all') ;
            ht_estimate=ht_estimate_m.*weight_b+ht_estimate;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);

            file_big_model=[path_tree_junk,tree_model,'_model_c_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_SST_paige_eqbox_test(iyear_mod,...
                time_aviso,ssh_total,sst_total,...
                nfiles,ht_estimate_m,TreePredictInfo,file_big_model,'c','all') ;
            ht_estimate=ht_estimate_m.*weight_c+ht_estimate;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);

            file_big_model=[path_tree_junk,tree_model,'_model_d_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_SST_paige_eqbox_test(iyear_mod,...
                time_aviso,ssh_total,sst_total,...
                nfiles,ht_estimate_m,TreePredictInfo,file_big_model,'d','all') ;
            ht_estimate=ht_estimate_m.*weight_d+ht_estimate;
            

        elseif ilayer<=ilayer_depth_use_sst
            
            file_big_model=[path_tree_junk,tree_model,'_model_a_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_SST_vert_eqbox(iyear_mod,...
                time_aviso,ssh_total,sst_total,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'a','all') ;
             ht_estimate=ht_estimate_m.*weight_a;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);
            
            file_big_model=[path_tree_junk,tree_model,'_model_b_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_SST_vert_eqbox(iyear_mod,...
                time_aviso,ssh_total,sst_total,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'b','all') ;
            ht_estimate=ht_estimate_m.*weight_b+ht_estimate;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);
            
            file_big_model=[path_tree_junk,tree_model,'_model_c_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_SST_vert_eqbox(iyear_mod,...
                time_aviso,ssh_total,sst_total,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'c','all') ;
             ht_estimate=ht_estimate_m.*weight_c+ht_estimate;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);
            
            file_big_model=[path_tree_junk,tree_model,'_model_d_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_SST_vert_eqbox(iyear_mod,...
                time_aviso,ssh_total,sst_total,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'d','all') ;
            ht_estimate=ht_estimate_m.*weight_d+ht_estimate;

        elseif ilayer<=ilayer_depth_use_ssh
        
            file_big_model=[path_tree_junk,tree_model,'_model_a_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_vert_eqbox(iyear_mod,...
                time_aviso,ssh_total,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'a','all') ;
             ht_estimate=ht_estimate_m.*weight_a;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);
                
            file_big_model=[path_tree_junk,tree_model,'_model_b_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_vert_eqbox(iyear_mod,...
                time_aviso,ssh_total,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'b','all') ;
            ht_estimate=ht_estimate_m.*weight_b+ht_estimate;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);
            
            file_big_model=[path_tree_junk,tree_model,'_model_c_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_vert_eqbox(iyear_mod,...
                time_aviso,ssh_total,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'c','all') ;
             ht_estimate=ht_estimate_m.*weight_c+ht_estimate;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);
            
            file_big_model=[path_tree_junk,tree_model,'_model_d_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_SSH_vert_eqbox(iyear_mod,...
                time_aviso,ssh_total,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'d','all');
            ht_estimate=ht_estimate_m.*weight_d+ht_estimate;


        else
            
            file_big_model=[path_tree_junk,tree_model,'_model_a_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_vert_eqbox(iyear_mod,...
                time_aviso,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'a','all') ;
             ht_estimate=ht_estimate_m.*weight_a;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);

            file_big_model=[path_tree_junk,tree_model,'_model_b_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_vert_eqbox(iyear_mod,...
                time_aviso,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'b','all') ;
            ht_estimate=ht_estimate_m.*weight_b+ht_estimate;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);
                
            file_big_model=[path_tree_junk,tree_model,'_model_c_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_vert_eqbox(iyear_mod,...
                time_aviso,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'c','all') ;
             ht_estimate=ht_estimate_m.*weight_c+ht_estimate;
            ht_estimate_m=nan(nlon_tpx,nlat_tpx,nfiles);
            
            file_big_model=[path_tree_junk,tree_model,'_model_d_',layer_name,'_split.mat'];
            [ht_estimate_m]=bagged_yearly_tree_temp_vert_eqbox(iyear_mod,...
                time_aviso,...
                nfiles,ht_estimate_m,ht_estimate_old,TreePredictInfo,file_big_model,'d','all') ;
            ht_estimate=ht_estimate_m.*weight_d+ht_estimate;
 
        end
        

%         ht_estimate=ht_estimate_a.*weight_a+ht_estimate_b.*weight_b+ht_estimate_c.*weight_c+ht_estimate_d.*weight_d;
       
        parsave_tree_year([path_new_tree,tree_file_name_out,'_split_7day.mat'] ,ht_estimate,lon_tpx, lat_tpx,time_aviso)
        ht_estimate_old=single(ht_estimate);
        
    end
end





end

function parsave_tree_year(filename,ht_estimate_year,lon_tpx, lat_tpx,time_aviso)
         ht_estimate_year=single(ht_estimate_year);

         save (filename,'ht_estimate_year','lon_tpx', 'lat_tpx','time_aviso','-v7')

end



