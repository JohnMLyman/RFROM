le_name_argo='pfloat_sal_greg_nov_2022_QC'
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'
%%  YOU MUST DOWNLOAD ARGO AND AVISO DATA AND PUT THEM IN THE CORRECT LOCATIONS!!!!
%%%%  Do I need the next line I dont think so!!!  11/14/2017

%%
% YOU MUST CHANE THE FILE_NAME TO THE CURRNET DATE EVERY TIME YOU CHANGE
% LAYERBOUNDS AND/OR FILE_NAME_ARGO SO THAT THE FILES DO NOT GET OVER WRITEN!!!!!
% file_nmae=argo_year_month_day_qc





path_figs='C:\data\OHCA\figs\';
year_of_oco_pub=2023;
slope_min_year=1993;
file_name='argo_2022_11_30_QC'

% this is the time range of the maps that are to be saved and outputted]
max_year_maps_out=2022;
min_year_maps_out=1993;

% this is the time range of the maps that were made by oco_maps* and are in
% the file name that has to be read
max_year_maps=2022;
min_year_maps=1990;
layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
depth_top_plot=0;
depth_bot_plot=700;
 [ht_maps,one_maps,httpx_maps,lon_tpx,lat_tpx,time_grid]=...
    oco_new_load_ohca_map(file_name,min_year_maps,max_year_maps,...
    min_year_maps_out,max_year_maps_out,depth_top_plot,depth_bot_plot,layer_bounds);

 % remove the mean over all time period of the maps out

  mean_httpx=repmat(nanmean(httpx_maps,3),1,1,length(time_grid));
%    mean_httpx=repmat(squeeze(httpx_maps(:,:,15)),1,1,length(time_grid));
 httpx_maps=httpx_maps-mean_httpx; 
  

cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);
for iyear=2021:2022
    
    pos_year=find(time_grid==iyear+.5);
    % plot the heat content for 2008
    figure(1);wysiwyg;orient tall
    set(gcf,'color','white');
    m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
    subplot(3,1,1)
    
    
    
    corrhc=httpx_maps(:,:,pos_year)./1e9;
    fyear=time_grid(pos_year)-.5;
    
    
    lon=lon_tpx;
    lat=lat_tpx;
    scale_fac=1;
    
    % put into the proper coordinates
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
    save 'OHCA_2019_tpx.mat' lon lat corrhc
    hold on
    set(h1,'linecolor','none')
    hold on
    m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none','xticklabel',[]);
    
    
    %[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
    a=gca;
    hold on
    m_coast('patch',[1 1 1]);
    t1=m_text(30,100,['(a) ', num2str(fyear)],'fontsize',12);
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
    
    
    
    % plot the heat content change of 2008-2007
    subplot(3,1,2)
    
    
    corrhc=(httpx_maps(:,:,pos_year)-httpx_maps(:,:,pos_year-1))./((60*60*24*365.5));
    syear=time_grid(pos_year-1)-.5;
    lon=lon_tpx;
    lat=lat_tpx;
    
    scale_fac_rate=1;
    % put into the proper coordinates
    min_val=-95./scale_fac_rate;
    max_val=95./scale_fac_rate;
    del_val=10./scale_fac_rate;
    del_cont=10./scale_fac_rate;
    ii=find(lon<30);
    jj=find(lon>=30); 
    lon=[lon(jj),lon(ii)+360];
    corrhc=[corrhc(jj,:);corrhc(ii,:)];
    %colormap jet(256)
    
    colormap(cold_to_hot_colormap)
    
    [cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);
    
    hold on
    set(h1,'linecolor','none')
    hold on
    m_grid('tickdir','out','xtick',[30:60:390],'xticklabel',[],'ytick',[-90:30:90],'linestyle','none');
    
    
    %[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
    b=gca;
    hold on
    m_coast('patch',[1 1 1]);
    t1=m_text(30,100,['(b) ' num2str(fyear) ' minus ' num2str(syear)],'fontsize',12);
    t2=m_text(320,-105,['(W m ^{-2})'],'fontsize',12);
    
    % subplot deletes hadle of the axis
    caxis([min_val max_val-del_cont])
    
    jb=axes('pos',[.262 .10+.06 .51 .01]);
    colormap(cold_to_hot_colormap) 
    
    [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
    set(h,'edgecolor','none')
    set(jb,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
    caxis([min_val max_val-del_cont])
    xlabel('1-year Heat Content Change (W m ^{-2})')
    
    % subplot deletes hadle of the axis in
    % greg_map_hc_20_year_2016_instu_scatter_plot this next line make sure that
    % the axis max and min are correct
    
    
    mmin_val=min_val;
    mmax_val=max_val;
    mdel_val=del_val;
    mdel_cont=del_cont;
    
    greg_map_hc_20_year_tpx_scatter_plot_oco_tuna
    
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
    eval(['print -dpng -f1 ',path_figs,'oco_heat_m_',num2str(year_of_oco_pub),'_fixed_tpx_',num2str(fyear),'_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)])
    eval(['print -dtiff -r600 -f1 ',path_figs,'oco_heat_m_',num2str(year_of_oco_pub),'_fixed_tpx_',num2str(fyear),'_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)])
    
    eval(['print -depsc2 -f1 ',path_figs,'oco_heat_m_',num2str(year_of_oco_pub),'_fixed_tpx_',num2str(fyear),'_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)])
   close(1)
end
