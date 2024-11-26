% Define TreeSetUp first, so that load_TreeSetUp.m can work

% uncomment the first time
% % % bagged_tree_ohca_error_maps_orca

load_TreeSetUp


min_layer=0;
max_layer=700;
syear=2020;
fyear=syear-1;

%

% path_figs='C:\data\OHCA\figs\tree_paper\'
year_of_oco_pub=2022;
slope_min_year=1993;
% file_name='argo_2021_01_01_QC'
% this is the time range of the maps that are to be saved and outputted
max_year_maps_out=2021;
min_year_maps_out=1993;


 
tree_model_file_name=tree_model_file_name_combined


nlayers=length(layer_bounds);
endlayer=find(layer_bounds==max_layer);
startlayer=find(layer_bounds==min_layer)+1;
file_sum_name=[path_tree,tree_model_file_name,'_',num2str(min_layer),'_',num2str(max_layer),'_split_7day.mat'];

if ~exist(file_sum_name,'file')
    bagged_tree_ohca_maps_split_7_day_orca
else
    load(file_sum_name,'ht_estimate','lon_tpx','lat_tpx','time_aviso')
end

mean_ht=nanmean(ht_estimate,3);
good_s=floor(time_aviso)==syear;
map_s=nanmean(ht_estimate(:,:,good_s),3)-mean_ht;
good_f=floor(time_aviso)==fyear;
map_f=nanmean(ht_estimate(:,:,good_f),3)-mean_ht;

% load([path_tree,'junk_map_s.mat'],'map_s','lat_tpx','lon_tpx')

cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);
figure(1);wysiwyg;orient tall
    set(gcf,'color','white');
    m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
    subplot(3,1,1)
    
    
    
    corrhc=map_s./1e9;
   
    
    
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
    m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none','xticklabel',[]);
    
    
    %[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
    a=gca;
    hold on
    m_coast('patch',[1 1 1]);
    t1=m_text(30,100,['(a) ', num2str(syear)],'fontsize',12);
    %t3=m_text(50,45,[num2str(depth_top_plot),'-',num2str(depth_bot_plot)],'fontsize',12);
     t2=m_text(320,-105,'(10^9 J m ^{-2})','fontsize',12);
    
    caxis([min_val max_val-del_cont])
    
    hold off
    
    ja=axes('pos',[.262 .90-.0475 .51 .01]);
    %colormap jet(256)
    
    colormap(cold_to_hot_colormap) 
    
    [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
    set(h,'edgecolor','none')
    set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
    caxis([min_val max_val-del_cont])
    %xlabel('Upper Ocean Heat Content Anomaly [J m ^{-2} x 10^9]')
    %%%
    subplot(3,1,2)
    
    load([path_tree,'error_var_mean_0_700_combined_2021_orca.mat'], 'time_aviso', ...
    'var_error_ht_0_700_2021','mean_error_ht_0_700_2021','lon_tpx','lat_tpx')
    corrhc=(mean_error_ht_0_700_2021./sqrt(12))./((1e8));
    %%
    lon=lon_tpx';
    lat=lat_tpx';
    
    scale_fac=1;
     % put into the proper coordinates
    min_val=0;
    max_val=3;
    del_val=2/scale_fac;
    del_cont=.5/scale_fac;
    min_val=0./scale_fac;
    max_val=3./scale_fac;
    del_val=.5./scale_fac;
    del_cont=.25./scale_fac;
    ii=find(lon<30);
    jj=find(lon>=30);
    lon=[lon(jj),lon(ii)+360];
    corrhc=[corrhc(jj,:);corrhc(ii,:)];
    %colormap jet(256)
    
    colormap(cold_to_hot_colormap) 
    
    
%     m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
    %colormap(fresh_to_salty_colormap) 
    [cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);
    % % 'cat'
%     save 'OHCA_2019_tpx.mat' lon lat corrhc
    hold on
    set(h1,'linecolor','none')
    hold on
    m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none','xticklabel',[]);
    
    
    %[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
    b=gca;
    hold on
    m_coast('patch',[1 1 1]);
    t1=m_text(30,100,['(b) ', num2str(syear),' error'],'fontsize',12);
    %t3=m_text(50,45,[num2str(depth_top_plot),'-',num2str(depth_bot_plot)],'fontsize',12);
     t2=m_text(320,-105,'(10^{8} J m ^{-2})','fontsize',12);
    
    caxis([min_val max_val-del_cont])
    
    hold off
    
   
    jb=axes('pos',[.262 .10+.06 .51 .01]);
    %colormap jet(256)
    
    colormap(cold_to_hot_colormap) 
    
    [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
    set(h,'edgecolor','none')
    set(jb,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
    caxis([min_val max_val-del_cont])
    %xlabel('Upper Ocean Heat Content Anomaly [J m ^{-2} x 10^9]')
    %%%
    
    % subplot deletes hadle of the axis in
    % greg_map_hc_20_year_2016_instu_scatter_plot this next line make sure that
    % the axis max and min are correct
    
    
    mmin_val=min_val;
    mmax_val=max_val;
    mdel_val=del_val;
    mdel_cont=del_cont;


 greg_map_hc_20_year_tree_scatter_plot_oco_orca
    
    min_val=mmin_val;
    max_val=mmax_val;
    del_val=mdel_val;
    del_cont=mdel_cont;
    
    hold off
    jb=axes('pos',[.262 .10+.06 .51 .01]);
    colormap(cold_to_hot_colormap) 
    
    [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
    set(h,'edgecolor','none')
    
    tt=cellstr(num2str([min_val:del_val:max_val]'));
    %tt{2}=[''];tt{4}=[''];tt{6}=[''];tt{8}=[''];tt{10}=[''];tt{11}=[''];tt{13}=[''];tt{15}=[''];tt{17}=[''];tt{19}=[''];
    tt{1}=[''];tt{3}=[''];tt{5}=[''];tt{7}=[''];tt{9}=[''];tt{12}=[''];tt{14}=[''];tt{16}=[''];tt{18}=[''];tt{20}=[''];
    
    set(jb,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[],'XtickLabel',tt)
    caxis([min_val max_val-del_cont])
    %xlabel('1-year Heat Content Change [W m ^{-2}]')
    
    
    %%%%sort the polots
    
    apos=get(a,'pos');
    bpos=get(b,'pos');
    cpos=get(c,'pos');
    japos=get(ja,'pos');
    jbpos=get(jb,'pos');
    jcpos=get(jc,'pos');
    
    
    set(a,'pos',apos+[0 .016 0 .03])
    set(b,'pos',bpos+[0 0 0 .03])
    set(c,'pos',cpos+[0 -.02 0 .03])
    
    set(ja,'XAxisLocation','bottom','pos',japos-[-.075 .149 .15 0])
    set(jb,'XAxisLocation','bottom','pos',jbpos-[-.075 -.225 .15 0])
    set(jc,'XAxisLocation','bottom','pos',jcpos-[-.075 .805 .15 0])
    
    %%% print plot
    wysiwyg_tuna;orient tall
    eval(['print -dpng -r600 -f1 ',path_figs,'oco_heat_tree_error_new2_publish_',num2str(year_of_oco_pub),'_for_',num2str(fyear),'_orca'])
%     eval(['print -dtiff -r600 -f1 ',path_figs,'oco_heat_m_',num2str(year_of_oco_pub),'_fixed_tpx_',num2str(fyear),'_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)])
%     
%     eval(['print -depsc2 -f1 ',path_figs,'oco_heat_m_',num2str(year_of_oco_pub),'_fixed_tpx_',num2str(fyear),'_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)])
%    close(1)






