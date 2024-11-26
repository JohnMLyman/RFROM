



% this sets up the code must be the same as make_all_the_bagged_trees
set_up_sal_atl_temp1

path_figs='C:\JUNK\'
year_of_oco_pub=2022;
slope_min_year=1993;
% this is the time range of the maps that are to be saved and outputted
max_year_maps_out=2021;
min_year_maps_out=1993;
cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);
fresh_to_salty_colormap=diverging_map([0:1/100:1],[20 43 140]/255,[204 85 0]/255); 

 
tree_model_file_name=tree_model_file_name_combined;

nlayers=length(layer_bounds);

 file_sum_name=[path_tree_junk,'netcdf\sal\matlab\mean_sal_yearly\',tree_model_file_name_season,'_mean_a16.mat'];

if ~exist(file_sum_name,'file')
    bagged_tree_ohca_maps_7_day_split_sal_mean

 else
    load(file_sum_name,'ht_estimate_mean','lat_tpx','time_aviso','depth')
end


%%


v=VideoWriter([path_figs,'tree_a16_sal_temp1.avi']);
v.FrameRate = 10;
open(v)
nframe=length(time_aviso);
for iframe=1:nframe
%%     
b=figure(1);
set(b, 'Position', [100 100 1200 400])
clf
    set(gcf,'color','white');
    m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
    
    
    
    
%     corrhc=ht_estimate(:,:,iframe)./1e9;
   
   corrhc=ht_estimate_mean(:,:,iframe);
    
    
    
    
    % put into the proper coordinates
    
    min_val=33.9;
    max_val=37.3
    
    
    cont_level=[min_val:.1:max_val];
    val_level=[min_val:.2:max_val];
    del_cont=abs(cont_level(end)-cont_level(end-1));
    colormap(fresh_to_salty_colormap) 
    
    
   
    %colormap(fresh_to_salty_colormap) 
    [cs1,h1]=contourf(lat_tpx,-1.*depth,corrhc',...
        [-1000,cont_level]);
    a=gca;
    set(a,'xtick',[],'ytick',[])
        set(a,'tickdir','out','xtick',[-60:5:65],'ytick',[-2000:100:0],...
            'XAxisLocation','bottom');
    yticklabels(([2000:-100:0]))
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
    
    colormap(fresh_to_salty_colormap) 
    
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
