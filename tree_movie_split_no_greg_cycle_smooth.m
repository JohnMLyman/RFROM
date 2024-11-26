path_figs='C:\JUNK\';
tree_model_file_name_season='tree_sst_tpx_yearly_overlap_seasonal';
% tree_model_file_name_combined='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name_combined=['tree_sst_tpx_combined_seasonal_anom'];


tree_model_file_name_old=tree_model_file_name_season;

tree_model_file_name=tree_model_file_name_combined;
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
ioff=50;
maps_name=['maps_0_2000_max_old_',num2str(ioff),'.mat'];

cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);

%  
% tree_model_file_name=tree_model_file_name_combined;
% 
% nlayers=length(layer_bounds);
% endlayer=find(layer_bounds==max_layer);
% startlayer=find(layer_bounds==min_layer)+1;
file_sum_name=[path_tree,'greg_seasonal_no_cycle_2000_minus_max_maps_sum.mat'];

if ~exist(file_sum_name,'file')
    load([path_tree,'greg_seasonal_cycle_2000_minus_max_maps.mat'],...
        'model_map','model_error_map',...
        'time_aviso','lon_tpx','lat_tpx')
    maps_name=['maps_0_2000_max_old_',num2str(ioff),'.mat'];
    load ([path_tree,maps_name], 'tgrid', 'ohca_max', 'ohca_2000', 'lon_tpx','lat_tpx');
    ohca_diff=ohca_2000-ohca_max;
    ohca_diff=ohca_diff(:,:,tgrid>2008);
    time_aviso=tgrid(tgrid>2008);
    nt=length(time_aviso);
    clearvars ohca_2000 ohca_max tgrid


    period=1;
    period2=1/2;
    period3=1/3;
    period4=1/4;
    period5=1/5;
    period6=1/6;

     time_cycle=time_aviso-floor(time_aviso);
     tbig=reshape(time_cycle,[1,1,nt]);
     clearvars model_error_map
     ht_estimate=model_map(:,:,1).*sin(tbig*2*pi/period)+model_map(:,:,2).*cos(tbig*2*pi/period)+model_map(:,:,3).*sin(tbig*2*pi/period2)+model_map(:,:,4).*cos(tbig*2*pi/period2)+...
        model_map(:,:,5).*sin(tbig*2*pi/period3)+model_map(:,:,6).*cos(tbig*2*pi/period3)+...
        model_map(:,:,7).*sin(tbig*2*pi/period4)+model_map(:,:,8).*cos(tbig*2*pi/period4)+model_map(:,:,9).*sin(tbig*2*pi/period5)+model_map(:,:,10).*cos(tbig*2*pi/period5)+...
        model_map(:,:,11).*sin(tbig*2*pi/period6)+model_map(:,:,12).*cos(tbig*2*pi/period6);

     
     clearvars model_map tbig tbig_model
     arw=areavec(lon_tpx,lat_tpx);
     ht_estimate=ohca_diff-ht_estimate;
     save(file_sum_name,'ht_estimate','lon_tpx','lat_tpx','time_aviso','-v7.3')
     

else
    load(file_sum_name,'ht_estimate','lon_tpx','lat_tpx','time_aviso')
end
 arw=areavec(lon_tpx,lat_tpx);
mean_ht=nanmean(ht_estimate,3);
ht_estimate=smoothdata(ht_estimate,3,'loess',104);
%%


v=VideoWriter([path_figs,'ohca_greg_no_cycle_smooth.avi']);
open(v)
nframe=length(time_aviso);
for iframe=1:nframe
    %%
figure(1)
clf
    set(gcf,'color','white');
    m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
    
    
    
    
    corrhc=ht_estimate(:,:,iframe)./1e9./arw;
   
    
    
    lon=lon_tpx';
    lat=lat_tpx';
    scale_fac=1;
    
    % put into the proper coordinates
   
    del_val=2;
    del_cont=.5;
    min_val=-2;
    max_val=2;
    del_val=.5;
    del_cont=.25;
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
%%
    frame=getframe(gcf);
    writeVideo(v,frame)

end
close(v)
