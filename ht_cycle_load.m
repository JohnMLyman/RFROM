function [lon_tpx,lat_tpx,time_aviso,depth,ht_cycle_all,ht_mean_all]=ht_cycle_load(TreeSetUp,path_junk)

% path_junk is an obtional 

tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;

tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
path_new_tree_combined=TreeSetUp.path_new_tree_combined;

path_tree=TreeSetUp.path_tree;
layer_bounds=TreeSetUp.layer_bounds;

if exist("path_junk",'var')
    path_tree=path_junk;
end

nlayer=length(layer_bounds);
depth=.5*(layer_bounds(1:end-1)+layer_bounds(2:end));

tree_model=tree_model_file_name_combined;
path_new_tree=path_new_tree_combined;
center_year=TreeSetUp.center_year;

ilayer=2;
year_load=2010;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
        tree_file_name_out=[tree_model,'_',layer_name,'_',num2str(year_load)];


[ht_estimate_year,time_aviso,lon_tpx,lat_tpx]=load_ht_estimate([path_new_tree,tree_file_name_out,'_split_7day.mat']);
s_ht=size(ht_estimate_year);
nlon_tpx=s_ht(1);
nlat_tpx=s_ht(2);
ntime_tpx=53;
time_aviso=time_aviso(1:ntime_tpx);
ht_cycle_all=nans(nlon_tpx,nlat_tpx,nlayer-1,ntime_tpx);
ht_mean_all=nans(nlon_tpx,nlat_tpx,nlayer-1);
tic
for ilayer=2:nlayer
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
           
    tree_file_name_season=[tree_model_file_name_season,'_',layer_name];
    
    [ht_cycle,ht_mean,~]=load_cycle([path_tree,tree_file_name_season,'_seasonal_cycle_split.mat']...
                ,nlon_tpx,nlat_tpx,ntime_tpx,time_aviso,center_year);
    ht_cycle_all(:,:,ilayer-1,:)=ht_cycle;
    ht_mean_all(:,:,ilayer-1)=ht_mean;
ilayer
toc./60

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

