function read_ssh_matfiles_yearly_seasonal_anom_orca_vert_sal(TreeSetUp)

% Loads Set up
% load_TreeSetUp
%%

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
tree_model_file_name_combined_withcycle=TreeSetUp.tree_model_file_name_combined_withcycle;

tree_model_file_name_season_temp=TreeSetUp.tree_model_file_name_season_temp;
tree_model_file_name_combined_temp=TreeSetUp.tree_model_file_name_combined_temp;
tree_model_file_name_combined_withcycle_temp=TreeSetUp.tree_model_file_name_combined_withcycle_temp;

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
path_new_tree_combined=TreeSetUp.path_new_tree_combined;
path_new_tree_combined_withcycle=TreeSetUp.path_new_tree_combined_withcycle;
path_new_tree_combined_temp=TreeSetUp.path_new_tree_combined_temp;
path_new_tree_combined_withcycle_temp=TreeSetUp.path_new_tree_combined_withcycle_temp;


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
path_new_tree=path_new_tree_yearly;
tree_model=tree_model_file_name_yearly;

tree_model_withcycle_temp=tree_model_file_name_combined_withcycle_temp;
path_new_tree_withcycle_temp=path_new_tree_combined_withcycle_temp;

if ~exist(path_new_tree,'dir')
    mkdir(path_new_tree)
end

% set up the files sytem for reading ssh and sst

s_allfiles=dir([path_ssh,'matlab_files\new_ssh*.mat']);
s=s_allfiles(1:7:length(s_allfiles));
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));


sday=sday+datenum(1950,1,1);
datevec_sday=datevec(sday);
aviso_day=sday-datenum(datevec_sday(:,1),1,1)+1;
syr=datevec_sday(:,1)+(aviso_day-1)./yeardays(datevec_sday(:,1));

clear sday

load([s(1).folder,'\',s(1).name],'lat','lon')
lat_tpx=lat;
lon_tpx=lon;


clear lon lat



[weight_a,weight_b,weight_c,weight_d]=round_floor_weight_maps(lon_tpx,lat_tpx);


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
start_year_ssh=floor(start_year);

if floor(start_year)==start_year
    start_year_ssh=start_year-1;
end
end_year_ssh=floor(end_year);
time_ssh_load=start_year_ssh:end_year_ssh;







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

parfor year_load=time_ssh_load
% for year_load=time_ssh_load


    display(year_load)
    
    [ssh_total,time_aviso,nfiles]=read_sshanom_year(s,syr,nlon_tpx,nlat_tpx,year_load,TreeSetUp);
    
    
    %this section makes it so the you only load 2 years when you are
    %at the start and end of the years where models were made
    
    if year_load == start_year-.5
        start_year_mod = start_year;
    elseif year_load== start_year-1
        start_year_mod=year_load+1;
    else
        start_year_mod=year_load;
    end
    
    if year_load == end_year-.5
        end_year_mod=year_load+.5;
    elseif year_load == end_year
        end_year_mod=year_load;
    else
        end_year_mod=year_load+1;
    end
    
    
    for ilayer=2:nlayer
    
        layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
        tree_file_name_out=[tree_model,'_',layer_name,'_',num2str(year_load)];
        tree_file_name_out_withcycle_temp=[tree_model_withcycle_temp,'_',layer_name,'_',num2str(year_load)];
        file_name_temp=[path_new_tree_withcycle_temp,tree_file_name_out_withcycle_temp,'_split_7day.mat'] ;
        [temp_use]=read_temp_use(file_name_temp);

        ht_estimate_a=nan(nlon_tpx,nlat_tpx,nfiles);        
        ht_estimate_b=nan(nlon_tpx,nlat_tpx,nfiles);        
        ht_estimate_c=nan(nlon_tpx,nlat_tpx,nfiles);       
        ht_estimate_d=nan(nlon_tpx,nlat_tpx,nfiles);

        for iyear_mod=start_year_mod:.5:end_year_mod
            year_file_name=num2str(10*iyear_mod);
            if ilayer==2
                file_big_model=[path_tree_junk,tree_model,'_model_a_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_a]=bagged_yearly_tree_temp_SSH_sal(iyear_mod,...
                    time_aviso,ssh_total,temp_use,...
                    nfiles,ht_estimate_a,TreePredictInfo,file_big_model,'a') ;

                file_big_model=[path_tree_junk,tree_model,'_model_b_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_b]=bagged_yearly_tree_temp_SSH_sal(iyear_mod,...
                    time_aviso,ssh_total,temp_use,...
                    nfiles,ht_estimate_b,TreePredictInfo,file_big_model,'b') ;

                file_big_model=[path_tree_junk,tree_model,'_model_c_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_c]=bagged_yearly_tree_temp_SSH_sal(iyear_mod,...
                    time_aviso,ssh_total,temp_use,...
                    nfiles,ht_estimate_c,TreePredictInfo,file_big_model,'c') ;

                file_big_model=[path_tree_junk,tree_model,'_model_d_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_d]=bagged_yearly_tree_temp_SSH_sal(iyear_mod,...
                    time_aviso,ssh_total,temp_use,...
                    nfiles,ht_estimate_d,TreePredictInfo,file_big_model,'d') ;

            
            elseif ilayer<=ilayer_depth_use_ssh
                file_big_model=[path_tree_junk,tree_model,'_model_a_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_a]=bagged_yearly_tree_temp_SSH_vert_sal(iyear_mod,...
                    time_aviso,ssh_total,temp_use,...
                    nfiles,ht_estimate_a,ht_estimate_old,TreePredictInfo,file_big_model,'a') ;
                    
                file_big_model=[path_tree_junk,tree_model,'_model_b_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_b]=bagged_yearly_tree_temp_SSH_vert_sal(iyear_mod,...
                    time_aviso,ssh_total,temp_use,...
                    nfiles,ht_estimate_b,ht_estimate_old,TreePredictInfo,file_big_model,'b') ;
                
                file_big_model=[path_tree_junk,tree_model,'_model_c_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_c]=bagged_yearly_tree_temp_SSH_vert_sal(iyear_mod,...
                    time_aviso,ssh_total,temp_use,...
                    nfiles,ht_estimate_c,ht_estimate_old,TreePredictInfo,file_big_model,'c') ;
                
                file_big_model=[path_tree_junk,tree_model,'_model_d_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_d]=bagged_yearly_tree_temp_SSH_vert_sal(iyear_mod,...
                    time_aviso,ssh_total,temp_use,...
                    nfiles,ht_estimate_d,ht_estimate_old,TreePredictInfo,file_big_model,'d') ;

            else
            
                file_big_model=[path_tree_junk,tree_model,'_model_a_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_a]=bagged_yearly_tree_temp_vert_sal(iyear_mod,...
                    time_aviso,temp_use,...
                    nfiles,ht_estimate_a,ht_estimate_old,TreePredictInfo,file_big_model,'a') ;

                file_big_model=[path_tree_junk,tree_model,'_model_b_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_b]=bagged_yearly_tree_temp_vert_sal(iyear_mod,...
                    time_aviso,temp_use,...
                    nfiles,ht_estimate_b,ht_estimate_old,TreePredictInfo,file_big_model,'b') ;
                    
                file_big_model=[path_tree_junk,tree_model,'_model_c_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_c]=bagged_yearly_tree_temp_vert_sal(iyear_mod,...
                    time_aviso,temp_use,...
                    nfiles,ht_estimate_c,ht_estimate_old,TreePredictInfo,file_big_model,'c') ;
                
                file_big_model=[path_tree_junk,tree_model,'_model_d_',layer_name,'_',year_file_name,'_split.mat'];
                [ht_estimate_d]=bagged_yearly_tree_temp_vert_sal(iyear_mod,...
                    time_aviso,temp_use,...
                    nfiles,ht_estimate_d,ht_estimate_old,TreePredictInfo,file_big_model,'d') ;
     
            
            end
        end
        
        
        
        ht_estimate=ht_estimate_a.*weight_a+ht_estimate_b.*weight_b+ht_estimate_c.*weight_c+ht_estimate_d.*weight_d;
       
        
        
        
        
        parsave_tree_year([path_new_tree,tree_file_name_out,'_split_7day.mat'] ,ht_estimate,lon_tpx, lat_tpx,time_aviso)
        ht_estimate_old=single(ht_estimate);
        
    end

end




end

function parsave_tree_year(filename,ht_estimate_year,lon_tpx, lat_tpx,time_aviso)
         ht_estimate_year=single(ht_estimate_year);

         save (filename,'ht_estimate_year','lon_tpx', 'lat_tpx','time_aviso','-v7.3')

end


function [temp_use]=read_temp_use(file_name_temp)



    load(file_name_temp,'ht_estimate_year')

    temp_use=double(ht_estimate_year);

end

