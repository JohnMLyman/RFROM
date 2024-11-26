function [ohca,depth,lat_tpx,lon_tpx]=grab_ohca_anomtemp_vert_nossh(year_grab)

tic
path_tree='J:\tree_temp_vert_nossh\t_trees\'
tree_file_name_season='tree_temp_vert_nossh_yearly_overlap_seasonal';
pathvert='J:\tree_temp_vert_nossh\t_trees\tree_temp_vert_nossh_yearly_overlap_seasonal_anom\';

 layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000];% layer_bounds must be in assending order
depth=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;
nlayers=length(layer_bounds);
max_year_fit=2021;
min_year_fit=2008;
center_year=(max_year_fit+min_year_fit)./2;
ohca=[];
 for ilayer=2:nlayers
      layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
      load([pathvert,'tree_temp_vert_nossh_yearly_overlap_seasonal_anom_',layer_name,'_',num2str(year_grab),'_split_7day.mat'],...
          'lon_tpx','lat_tpx','ht_estimate_year','time_aviso')
      nlon_tpx=length(lon_tpx);
      nlat_tpx=length(lat_tpx);
      ntime_tpx=length(time_aviso);
       [ht_cycle,ht_mean,~]=load_cycle([path_tree,tree_file_name_season,'_',layer_name,'_seasonal_cycle_split.mat']...
            ,nlon_tpx,nlat_tpx,ntime_tpx,time_aviso,center_year);
        ht_estimate_year=ht_estimate_year+ht_cycle+ht_mean;
      
      ohca=cat(4,ohca,ht_estimate_year);
 end
toc./60

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