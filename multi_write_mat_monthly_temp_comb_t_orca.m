
function multi_write_mat_monthly_temp_comb_t_orca(TreeSetUp)

nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;


file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;


tree_prefix_temp=TreeSetUp.tree_prefix_temp;
path_mat_nc=TreeSetUp.path_mat_nc;

tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;

tree_model_file_name_season_temp=TreeSetUp.tree_model_file_name_season_temp;
tree_model_file_name_combined_temp=TreeSetUp.tree_model_file_name_combined_temp;
% 
% file_name_season=[file_name,'_seasonal'];
% file_name_season_anom=[file_name_season,'_anom'];

path_oisst=TreeSetUp.path_oisst;
path_OHCA_data_out=TreeSetUp.path_OHCA_data_out;
path_OHCA_data_in=TreeSetUp.path_OHCA_data_in;
path_ssh=TreeSetUp.path_ssh;

path_tree=TreeSetUp.path_tree;
path_tree_temp=TreeSetUp.path_tree_temp;

path_new_tree_season=TreeSetUp.path_new_tree_season;
path_new_tree_yearly=TreeSetUp.path_new_tree_yearly;
path_new_tree_all_year=TreeSetUp.path_new_tree_all_year;

path_tree_junk=TreeSetUp.path_tree_junk;
path_curve=TreeSetUp.path_curve;

layer_bounds=TreeSetUp.layer_bounds;

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
nlayer_use=TreeSetUp.nlayer_use;
%%
path_mat_nc_temp=[path_mat_nc,'temp/matlab/'];

if ~exist(path_mat_nc_temp)
    mkdir(path_mat_nc_temp)

end
year_start_nc=floor(start_year);
year_end_nc=floor(end_year);

%% test info
% 
% year_start_nc=2021;
% year_end_nc=2022;
% nlayers=2;


% path_tree_temp=[path_OHCA_data_out,'OHCA_trees\',tree_prefix_temp,'\'];
% tree_model_file_name_season_temp=[tree_prefix_temp,'_yearly_overlap_seasonal'];
% tree_model_file_name_combined_temp=[tree_prefix_temp,''

path_new_tree_season_temp=[path_tree_temp,tree_model_file_name_season_temp,'\'];



nlayers=length(layer_bounds);



%%


% load('C:\Users\jlyma\OneDrive - University of Hawaii\data\topo_tpx_new.mat','topo_tpx_new')
%  topo_tpx_new=-1.*topo_tpx_new;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];

tree_file_name_temp=[tree_model_file_name_season_temp,'_',layer_name];
load([path_new_tree_season_temp,tree_file_name_temp,'_split_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
% nlon_tpx=length(lon_tpx);
% nlat_tpx=length(lat_tpx);
% ntime_tpx=length(time_aviso);

year_aviso=floor(time_aviso);
aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
sday=round(aviso_day+datenum(year_aviso,1,1)-1);

days_since_1950=sday-datenum(1950,1,1);%NEED TO CHECK THIS

%check this
[year_data,month_data]=datevec(days_since_1950+datenum(1950,1,1));

tgrid=time_aviso;


% arw=areavec(lon_tpx,lat_tpx);
% scale=ones(nlon_tpx,nlat_tpx);


parfor ilayer=2:nlayers
% for ilayers=2
    tic
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
%     file_nc_prefix=['RFROM_Tmean_',layer_name,'_']
%      scalej=scale;    
%      depth_min=layer_bounds(ilayer-1);
%     depth_max=layer_bounds(ilayer);
%     
%     shallow=topo_tpx_new < depth_min;
%     mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_max;
%     
% 
%     
%     scalej(mid)=scalej(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
%     scalej(shallow)=NaN;
% 
%     scalej=repmat(scalej,1,1,ntime_tpx);


    
    tree_file_name_temp=[tree_model_file_name_season_temp,'_',layer_name];
%     load([path_tree,tree_file_name,'_7day.mat'], 'ht_estimate','time_aviso')
    [ht_estimate,lon_tpx,lat_tpx, time_aviso]=load_season_tree([path_new_tree_season_temp,tree_file_name_temp,'_split_7day.mat']);
%     load([path_new_tree_season_temp,tree_file_name_temp,'_split_7day.mat'], 'ht_estimate','lon_tpx','lat_tpx', 'time_aviso')
%     load([path_tree,tree_file_name_old,'_seasonal_cycle_expand.mat'],'ht_cycle')
%     ht_estimate=ht_estimate+ht_cycle;
   
    
%     for itime=1:nyears
%         jyear=tgrid(itime);
%         ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
%     end
    
%    ht_estimate=ht_estimate.*scalej;
time_aviso_total=time_aviso;
   
   for iyear=year_start_nc:year_end_nc
       for imonth=1:12

           good=find(month_data==imonth & year_data==iyear);

           if ~isempty(good)
               temp_estimate_mon=ht_estimate(:,:,good);
               time_1950=days_since_1950(good);
               time_aviso=time_aviso_total(good);
               file_name_mat_nc_temp=[tree_file_name_temp,'_',num2str(iyear),'_',num2str(imonth)];

               % convert to single 

               time_1950=single(time_1950);
               time_aviso=single(time_aviso);
               temp_estimate_mon=single(temp_estimate_mon);
               lon_tpx=single(lon_tpx);
               lat_tpx=single(lat_tpx);
               save_mat_nc([path_mat_nc_temp,file_name_mat_nc_temp],temp_estimate_mon,time_1950,time_aviso,lon_tpx,lat_tpx)


%                save([path_mat_nc_temp,file_name_mat_nc_temp],'temp_estimate_mon','time_1950','time_aviso','lon_tpx','lat_tpx')
           end

       end
   end
    

  

end

end

function [ht_estimate,lon_tpx,lat_tpx, time_aviso]=load_season_tree(filename)

    load(filename, 'ht_estimate','lon_tpx','lat_tpx', 'time_aviso')

end

function save_mat_nc(filename,temp_estimate_mon,time_1950,time_aviso,lon_tpx,lat_tpx)

               save(filename,'temp_estimate_mon','time_1950','time_aviso','lon_tpx','lat_tpx')


end

