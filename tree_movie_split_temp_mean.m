min_layer=0;
max_layer=2000;



path_figs='C:\JUNK\'
year_of_oco_pub=2022;
slope_min_year=1993;
set_up_sst2
% this is the time range of the maps that are to be saved and outputted
max_year_maps_out=2021;
min_year_maps_out=1993;
cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);

 
tree_model_file_name=tree_model_file_name_combined;

nlayers=length(layer_bounds);
endlayer=find(layer_bounds==max_layer);
startlayer=find(layer_bounds==min_layer)+1;
file_sum_name=[path_tree,tree_model_file_name,'_',num2str(min_layer),'_',num2str(max_layer),'_mean_split_7day.mat'];

% if ~exist(file_sum_name,'file')
    bagged_tree_ohca_maps_7_day_split_mean
% else
%     load(file_sum_name,'ht_estimate','lon_tpx','lat_tpx','time_aviso')
% end

mean_ht=nanmean(ht_estimate,3);
ht_estimate=ht_estimate-mean_ht;
%%


v=VideoWriter([path_figs,'ohca_gaps_0_2000_combine5.avi']);
open(v)
nframe=length(time_aviso);
for iframe=1:nframe
figure(1)
clf
    set(gcf,'color','white');
    m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
    
    
    
    
    corrhc=ht_estimate(:,:,iframe)./1e9;
   
    
    
    lon=lon_tpx';
    lat=lat_tpx';
    scale_fac=1;
    
    % put into the proper coordinates
    min_val=0;
    max_val=3;
    del_val=2/scale_fac;
    del_cont=.5/scale_fac;
    min_val=-3./scale_fac;
    max_val=3./scale_fac;
    del_val=.5./scale_fac;
    del_cont=.25./scale_fac;
    ii=find(lon<30);
    jj=find(lon>=30);
    lon=[lon(jj),lon(ii)+360];
    corrhc=[corrhc(jj,:);corrhc(ii,:)];
    %colormap jet(256)
    
    colormap(cold_to_hot_colormap) 
    
    
    m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
    %colormap(fresh_to_salty_colormap) 
    [cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);
    % % 'cat'
%     save 'OHCA_2019_tpx.mat' lon lat corrhc
    hold on
    set(h1,'linecolor','none')
    hold on
    m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none');
    
    
    %[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
    a=gca;
    hold on
    m_coast('patch',[1 1 1]);
    t1=m_text(30,100,[' ', num2str(time_aviso(iframe))],'fontsize',12);
    %t3=m_text(50,45,[num2str(depth_top_plot),'-',num2str(depth_bot_plot)],'fontsize',12);
     t2=m_text(170,-150,'(10^9 J m ^{-2})','fontsize',10);
    
    caxis([min_val max_val-del_cont])
    
    hold off
    
    ja=axes('pos',[.262 .90-.0475 .51 .01]);
    %colormap jet(256)
    
    colormap(cold_to_hot_colormap) 
    
    [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
    set(h,'edgecolor','none')
    set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
    caxis([min_val max_val-del_cont])
    japos=get(ja,'pos');
    set(ja,'XAxisLocation','bottom','pos',japos-[.075 .7 -.15 -.015])

    frame=getframe(gcf);
    writeVideo(v,frame)

end
close(v)
