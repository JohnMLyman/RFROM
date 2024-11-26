openfunction   tree_movie_split_temp_al_newl_a16(TreeSetUp)
%%
%% load vars into TreeSetUp

nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;


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

%%

path_figs='H:\Figs\'

% this is the time range of the maps that are to be saved and outputted

cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);

 
tree_model_file_name=tree_model_file_name_combined;

nlayer=length(layer_bounds);

 file_sum_name=[path_tree,tree_model_file_name,'_a16_all.mat'];

if ~exist(file_sum_name,'file')
%%



load('D:\data\topo_tpx_new.mat','topo_tpx_new','lon_topo')
 topo_tpx_new=-1.*topo_tpx_new;

ilayer=2;
nlayers=length(layer_bounds);
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name=[tree_model_file_name,'_',layer_name];
load([path_tree,tree_file_name,'_split_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')


nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);

tgrid=time_aviso;

% pick out a latitude

[~,pos_lon]=min(abs(lon_tpx-335));
[~,pos_lon_topo]=min(abs(lon_topo-335));
bottom_depth=topo_tpx_new(pos_lon,:);

npos=nlat_tpx;

ht_out_total=nans(npos,nlayers-1,ntime_tpx);
ht_out_mean=nans(npos,nlayers-1);
% arw=areavec(lon_tpx,lat_tpx);
% layer_curve=nans(endlayer-startlayer+1,ntime_tpx);
%compute basin curves
% % [LON,LAT]=ndgrid(lon_tpx,lat_tpx);
% % [global_basins_aviso]=find_basin_paige(LON,LAT);
% % nbasin=length(global_basins_aviso);
% % scale=ones(nlon_tpx,nlat_tpx);
% basin_layer_curve=nans(nbasin,endlayer-startlayer+1,ntime_tpx);

ngroup_layer=4;
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
   
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]

    %%

    tree_file_name_season=[tree_model_file_name_season,'_',layer_name];

    [ht_cycle,ht_mean,~]=load_cycle([path_tree,tree_file_name_season,'_seasonal_cycle_split.mat']...
        ,nlon_tpx,nlat_tpx,ntime_tpx,time_aviso,center_year);


%     load([path_tree,tree_file_name,'_seasonal_cycle_split.mat'],...
%         'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
%         'amp_third_total','phase_third_total','slope_total','mean_total');
%     ht_cycle=nans(nlon_tpx,nlat_tpx,ntime_tpx);
%     ht_mean=mean_total+slope_total.*center_year;
%     ht_trend=ht_cycle;
%     
%     for itime=1:ntime_tpx
% 
% 
%         if isfinite(time_aviso(itime))
%             good_t=time_aviso(itime);
%             ht_cycle(:,:,itime)=amp_annual_total.*sin((2*pi.*good_t./period)+...
%                 phase_annual_total)+amp_semi_total.*sin((2.*good_t*pi./period2)+phase_semi_total)+...
%                 amp_third_total.*sin((2*pi.*good_t./period3)+phase_third_total);
%             ht_trend(:,:,itime)=slope_total.*good_t-slope_total.*center_year;
%         end
% 
%     end

    %%
% 
%     tree_file_name=[tree_model_file_name,'_',layer_name];
%     load([path_tree,tree_file_name,'_split_7day.mat'], 'ht_estimate','time_aviso');

  tree_file_name=[tree_model_file_name,'_',layer_name];
  [ht_estimate,~]=load_htestimate([path_tree,tree_file_name,'_split_7day.mat']);
    
   ht_out_total(:,ilayer-1,:)=ht_estimate(pos_lon,:,:)+...
      ht_cycle(pos_lon,:,:)+ht_mean(pos_lon,:);
   ht_out_mean(:,ilayer-1)=ht_mean(pos_lon,:);
  
   
   
end
    end

for ilayer=2:nlayers
    bad=layer_bounds(ilayer-1)>bottom_depth;
      ht_out_mean(bad,ilayer-1)=nan;
      ht_out_total(bad,ilayer-1,:)=nan;
end

clearvars ht_estimate ht_mean ht_trend ht_cycle

ht_estimate_mean=ht_out_total;
clear ht_out_total ht_junk
% file_sum_name=[path_tree,tree_model_file_name,'_',num2str(min_layer),'_',num2str(max_layer),'_split_7day.mat'];

depth=(layer_bounds(1:end-1)+layer_bounds(2:end))./2;

save(file_sum_name,'ht_estimate_mean','ht_out_mean','depth','lat_tpx','time_aviso','-v7.3')




%%

 else
    load(file_sum_name,'ht_estimate_mean','ht_out_mean','lat_tpx','time_aviso','depth')
end


%%

 % put into the proper coordinates
    
    min_val=-2;
    max_val=28.;
v=VideoWriter([path_figs,'tree_a16_all.avi']);
v.FrameRate = 10;
open(v)
nframe=length(time_aviso);
for iframe=1:nframe
%%     
b=figure(1);
set(b, 'Position', [100 100 1200 400])
clf

    set(gcf,'color','white');
   
    
    
    
    
%     corrhc=ht_estimate(:,:,iframe)./1e9;
   corrhc=ht_out_mean;
   corrhc=ht_estimate_mean(:,:,iframe);
    
    
    
    
    % put into the proper coordinates
    
    cont_level=[min_val:.2:5 6:max_val];
    val_level=[min_val:1:5 7:2:max_val];
    del_cont=abs(cont_level(end)-cont_level(end-1));
    
    
    colormap(cold_to_hot_colormap) 
    
    
   
    %colormap(fresh_to_salty_colormap) 
    [cs1,h1]=contourf(lat_tpx,-1.*depth,corrhc',...
        [-1000,min_val:del_cont:max_val]);
    a=gca;
    set(a,'xtick',[],'ytick',[])
        set(a,'tickdir','out','xtick',[-60:5:65],'ytick',[-2000:50:0],...
            'XAxisLocation','bottom');
    yticklabels(([2000:-50:0]))
    axis(a,[-62 70 -2000 0])
    apos=get(a,'pos');
   title(['A16 on ',num2str(time_aviso(iframe))])
    set(a,'pos',apos-[0 -.1 0 .1])

 
%     save 'OHCA_2019_tpx.mat' lon lat corrhc
    hold on
%     set(h1,'linecolor','none')
    hold on
%     m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none');
    
    
    %[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
    a=gca;
    hold on
   
%     t1=m_text(30,100,[' ', num2str(time_aviso(iframe))],'fontsize',12);
%     %t3=m_text(50,45,[num2str(depth_top_plot),'-',num2str(depth_bot_plot)],'fontsize',12);
%      t2=m_text(170,-150,'(10^9 J m ^{-2})','fontsize',10);
    
    caxis([min_val max_val-del_cont])
% %     
    hold off
    
    ja=axes('pos',[.262 .90-.0475 .51 .01]);
    %colormap jet(256)
    
    colormap(cold_to_hot_colormap) 
    
    [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],cont_level);
    set(h,'edgecolor','none')
    set(ja,'tickdir','out','xaxisl','top','xtick',val_level,'ytick',[])
    caxis([min_val max_val-del_cont])
    japos=get(ja,'pos');
    set(ja,'XAxisLocation','bottom','pos',japos-[.075 .77 -.15 -.015])
%% 
    frame=getframe(gcf);
    writeVideo(v,frame)




end
close(v)


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

function [ht_estimate,time_aviso]=load_htestimate(filename)

    load(filename, 'ht_estimate','time_aviso')
  
    

end
