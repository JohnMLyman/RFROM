
function []=multi_write_mat_monthly_sal_yearly_all(TreeSetUp)


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

% path_nc='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_trees\netcdf\OHCA\';
path_mat_erddap=[path_ERDDAP,'matlab\yearly_all\'];
year_start_nc=1993;
year_end_nc=2022;
if ~exist(path_mat_erddap,'dir')
    mkdir(path_mat_erddap)
end
%% test info
% 
% year_start_nc=2021;
% year_end_nc=2022;
% nlayers=2;



tree_model_file_name=tree_model_file_name_yearly;
% path_OHCA_data_out='C:\data\OHCA\'
% path_OHCA_data_in='C:\OHCA\'
% 
%  layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
%  mean_depth=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;
% 
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];
% 
% file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% path_ssh=[path_OHCA_data_in,'Mtpers\'];


nlayer=length(layer_bounds);



%%


load('D:\data\topo_tpx_new.mat','topo_tpx_new')
 topo_tpx_new=-1.*topo_tpx_new;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name=[tree_model_file_name,'_',layer_name];
load([path_tree,tree_file_name,'_split_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);

 lon_tpx=single(lon_tpx);
lat_tpx=single(lat_tpx);

year_aviso=floor(time_aviso);
aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
sday=round(aviso_day+datenum(year_aviso,1,1)-1);

days_since_1950=sday-datenum(1950,1,1);%NEED TO CHECK THIS

%check this
[year_data,month_data]=datevec(days_since_1950+datenum(1950,1,1));

tgrid=time_aviso;

ht_out_total=nans(nlon_tpx,nlat_tpx,ntime_tpx);
% arw=areavec(lon_tpx,lat_tpx);
scale=ones(nlon_tpx,nlat_tpx);


% parfor ilayer=2:nlayers
ngroup_layer=6;
    if nlayer>= 20
        n_sublayer=ceil(nlayer./ngroup_layer);
        start_sublayer=2:n_sublayer:nlayer;
        end_sublayer=n_sublayer+1:n_sublayer:nlayer;
        if end_sublayer(end)~= nlayer
            end_sublayer(end+1)=nlayer;
        end
    else
        start_sublayer=2;
        end_sublayer=nlayer;
        ngroup_layer=1;
    end
     for isublayer=1:ngroup_layer



% parfor ilayer=2:nlayers
     parfor ilayer=start_sublayer(isublayer):end_sublayer(isublayer)
% for ilayers=2
    tic
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    file_nc_prefix=['RFROM_SAL_',layer_name,'_']
     scalej=scale;    
     depth_min=layer_bounds(ilayer-1);
     depth_mean=(layer_bounds(ilayer-1)+layer_bounds(ilayer))/2.;
%     depth_max=layer_bounds(ilayer);
    
    shallow=topo_tpx_new < depth_min;
    %find depths that are shallower than the mean depth/pressure of the layer 
    mid=topo_tpx_new>=depth_min & topo_tpx_new<depth_mean;
    

    
%     scalej(mid)=scalej(mid).*(topo_tpx_new(mid)-depth_min)./(depth_max-depth_min);
scalej(mid)=NaN;
    scalej(shallow)=NaN;

    scalej=repmat(scalej,1,1,ntime_tpx);


    tree_file_name=[tree_model_file_name,'_',layer_name];
    tree_file_name_season=[tree_model_file_name_season,'_',layer_name];
%     load([path_tree,tree_file_name,'_7day.mat'], 'ht_estimate','time_aviso')
    [ht_estimate,time_aviso]=load_ht_estimate([path_tree,tree_file_name,'_split_7day.mat']);
%     load([path_tree,tree_file_name_old,'_seasonal_cycle_expand.mat'],'ht_cycle')
%     [ht_cycle]=load_cycle([path_tree,tree_file_name_old,'_seasonal_cycle_expand_split.mat'])
 [ht_cycle,ht_mean,~]=load_cycle([path_tree,tree_file_name_season,'_seasonal_cycle_split.mat']...
        ,nlon_tpx,nlat_tpx,ntime_tpx,time_aviso,center_year);

    ht_estimate=ht_estimate+ht_cycle+ht_mean;
%     clear ht_cycle
    
%     for itime=1:nyears
%         jyear=tgrid(itime);
%         ht_out(:,:,itime)=mean(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
%     end
    
   ht_estimate=ht_estimate.*scalej;

   
   for iyear=year_start_nc:year_end_nc
       for imonth=1:12

           good=find(month_data==imonth & year_data==iyear);

           if ~isempty(good)
               sal_estimate_mon=ht_estimate(:,:,good);
               time_1950=days_since_1950(good);
               file_name_mat_nc=[tree_file_name,'_',num2str(iyear),'_',num2str(imonth)];

               % convert to single 

               time_1950=single(time_1950);
               sal_estimate_mon=single(sal_estimate_mon);
%                lon_tpx=single(lon_tpx);
%                lat_tpx=single(lat_tpx);
%                save([path_mat_nc,file_name_mat_nc],'ht_estimate_mon','time_1950','lon_tpx','lat_tpx')
               save_month_nc_sal([path_mat_erddap,file_name_mat_nc],sal_estimate_mon,time_1950,lon_tpx,lat_tpx)
           
           end

       end
   end
    

  

     end
     end


end

function save_month_nc_sal(filename,sal_estimate_mon,time_1950,lon_tpx,lat_tpx)

 save(filename,'sal_estimate_mon','time_1950','lon_tpx','lat_tpx')

end

function [ht_estimate,time_aviso]=load_ht_estimate(filename)


    load(filename, 'ht_estimate','time_aviso')

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
% 
% function [ht_cycle]=load_cycle(filename)
% 
%     load(filename,'ht_cycle')
% end