function []=multi_add_seasonal_cycle_combined_filt_sal(TreeSetUp)



nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

path_ERDDAP=TreeSetUp.path_ERDDAP;       


tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
tree_model_file_name_combined_withcycle=TreeSetUp.tree_model_file_name_combined_withcycle;
% tree_model_file_name_combined_withoutcycle=TreeSetUp.tree_model_file_name_combined_withoutcycle;

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
% path_new_tree_combined_withoutcycle=TreeSetUp.path_new_tree_combined_withoutcycle;

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



%%


tree_model=tree_model_file_name_combined;
tree_model_withcycle=tree_model_file_name_combined_withcycle;
% tree_model_withoutcycle=tree_model_file_name_combined_withoutcycle;
path_new_tree_withcycle=path_new_tree_combined_withcycle;
% path_new_tree_withoutcycle=path_new_tree_combined_withoutcycle;
path_new_tree=path_new_tree_combined;
start_year_file=start_year;
end_year_file=end_year;

% tree_model=tree_model_file_name_yearly;
% path_new_tree=path_new_tree_yearly;
% start_year_file=start_yearly_maps;
% end_year_file=end_yearly_maps;

% tree_file_name=tree_file_name_in;
%%

% because the data is geroup by year if the start year is a whole number
% then the files will start in the pervious year
start_year_ssh=floor(start_year_file);
if floor(start_year_file)==start_year_file
    start_year_ssh=start_year_file-1;
end
end_year_ssh=floor(end_year_file);
time_ssh_load=start_year_ssh:end_year_ssh;
%%
if not(exist(path_new_tree_withcycle,'dir'))
    mkdir(path_new_tree_withcycle)
end
% if not(exist(path_new_tree_withoutcycle,'dir'))
%     mkdir(path_new_tree_withoutcycle)
% end
%%
nlayer=length(layer_bounds);

parfor year_load=time_ssh_load
% for year_load=time_ssh_load




    display(year_load)
    for ilayer=2:nlayer
    
        
        layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
        tree_file_name_out=[tree_model,'_',layer_name,'_',num2str(year_load)];
        tree_file_name_out_withcycle=[tree_model_withcycle,'_',layer_name,'_',num2str(year_load)];
%         tree_file_name_out_withoutcycle=[tree_model_withoutcycle,'_',layer_name,'_',num2str(year_load)];

        tree_file_name_season=[tree_model_file_name_season,'_',layer_name];

        [ht_estimate_year,time_aviso,lon_tpx,lat_tpx]=load_ht_estimate([path_new_tree,tree_file_name_out,'_split_7day.mat']);
        s_ht=size(ht_estimate_year);
        nlon_tpx=s_ht(1);
        nlat_tpx=s_ht(2);
        ntime_tpx=s_ht(3);
        [ht_cycle,ht_mean,~]=load_cycle([path_tree,tree_file_name_season,'_seasonal_cycle_split.mat']...
            ,nlon_tpx,nlat_tpx,ntime_tpx,time_aviso,center_year);
        ht_estimate_year_wc=ht_estimate_year+ht_cycle+ht_mean;
        for itime=1:ntime_tpx
            ht_estimate_year_wc(:,:,itime)=nanmedflit2_globe(ht_estimate_year_wc(:,:,itime),3);
            ht_estimate_year(:,:,itime)=nanmedflit2_globe(ht_estimate_year(:,:,itime),3);

        end

        parsave_tree_year([path_new_tree_withcycle,tree_file_name_out_withcycle,'_split_7day.mat'] ,ht_estimate_year_wc,lon_tpx, lat_tpx,time_aviso)
%         parsave_tree_year([path_new_tree_withoutcycle,tree_file_name_out_withoutcycle,'_split_7day.mat'] ,ht_estimate_year,lon_tpx, lat_tpx,time_aviso)
    end
end

end
function [ht_estimate_year,time_aviso,lon_tpx,lat_tpx]=load_ht_estimate(filename)


    load(filename, 'ht_estimate_year','time_aviso','lon_tpx','lat_tpx');

end

function [ht_cycle,ht_mean,ht_trend]=load_cycle(filename,nlon_tpx,nlat_tpx,ntime_tpx,time_aviso,center_year)

period=1;
period2=1/2;

period3=1/3;

load(filename,...
        'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
        'amp_third_total','phase_third_total','slope_total','mean_total');
    ht_cycle=nans(nlon_tpx,nlat_tpx,ntime_tpx);
    ht_mean=mean_total+slope_total.*center_year;
    ht_trend=ht_cycle;
     for itime=1:ntime_tpx


        if isfinite(time_aviso(itime))
            good_t=time_aviso(itime);
            ht_cycle(:,:,itime)=amp_annual_total.*sin((2*pi.*good_t./period)+...
                phase_annual_total)+amp_semi_total.*sin((2.*good_t*pi./period2)+phase_semi_total)+...
                amp_third_total.*sin((2*pi.*good_t./period3)+phase_third_total);
            ht_trend(:,:,itime)=slope_total.*good_t-slope_total.*center_year;
        end

    end

end

function parsave_tree_year(filename,ht_estimate_year,lon_tpx, lat_tpx,time_aviso)
         ht_estimate_year=single(ht_estimate_year);

         save (filename,'ht_estimate_year','lon_tpx', 'lat_tpx','time_aviso','-v7.3')

end

