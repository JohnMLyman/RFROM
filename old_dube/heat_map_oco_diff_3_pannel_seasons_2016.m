path_EN3='/Volumes/Data/EN3/ishiiXBTMBT_2014/';
 file_EN3_type='_ishii_EN3_2014';
% UNCOMMENT WHEN NEW EN3 IS AVAILBLE 
%  
% getwod_heat_oco_EN3_teos10
% 
 clear all 
% 
 file_WOD_suf='_ishii_EN3_2014'
 path_EN3='/Volumes/Data/EN3/ishiiXBTMBT_2014/';
% 


max_year=2015;
min_year=1950;

file_name='pfloat_sal_greg_jan_2016_QC'
file_name_mean='pfloat_sal_greg_jan_2016_QC'
file_path='/Users/lyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/lyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'

file_path_hdata='/Users/lyman/data/Globalhc/HC/'
allheat_extra='_new';

depth_name=cell(1,7);
depth_name{1}='100';
depth_name{2}='700';
depth_name{3}='1800';
depth_name{4}='300';
depth_name{5}='900';
depth_name{6}='100_300';
depth_name{7}='300_700';


for jdepth=1:length(depth_name);
    idepth=depth_name{jdepth}';
    signal_to_noise=1;
 
%eval(['load ',file_path,file_name,'_',num2str(idepth),'_',num2str(signal_to_noise),'_oa_mean_new.mat ht_out one_out lon lat '])
eval(['load ',file_path,file_name_mean,'_',idepth','_',num2str(signal_to_noise),'_season_gausian_bin_new_mon_dia_off.mat ht_out lat_grid lon_grid time_grid ']);

eval(['mean_heat_oa_',idepth','=ht_out;']);

 end

mh=(mean_heat_oa_100(:,:,2:13)+mean_heat_oa_100_300(:,:,2:13)+mean_heat_oa_300_700(:,:,2:13))./1e8;
mh=nanmean(mh,3);

for imon=[2 5 8 11]


cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);
cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);

lon_tpx=lon_grid';
lat_tpx=lat_grid';
lon2=lon_grid';
lat2=lat_grid';


%corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx');
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
%corrhc(isnan(sshmean))=NaN;


% plot the heat content for 2008
figure(1);wysiwyg;orient tall
set(gcf,'color','white');
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
subplot(3,1,1)

lon=lon2;
lat=lat2;



corrhc=(mean_heat_oa_100(:,:,imon)+mean_heat_oa_100_300(:,:,imon)+mean_heat_oa_300_700(:,:,imon))./1e8;
corrhc=corrhc-mh;
lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-10
max_val=10
del_val=1
del_cont=1
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(cold_to_hot_colormap) 


m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
%colormap(fresh_to_salty_colormap) 
[cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none','xticklabel',[]);


%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
a=gca;
hold on
m_coast('patch',[1 1 1]);
t1=m_text(30,100,['(a) ', num2str(imon)],'fontsize',12);
t2=m_text(320,-105,'[10^8 J m ^{-2}]','fontsize',12);

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

lon=lon2;
lat=lat2;


corrhc=(mean_heat_oa_100(:,:,imon+1)+mean_heat_oa_100_300(:,:,imon+1)+mean_heat_oa_300_700(:,:,imon+1))./1e8;
corrhc=corrhc-mh;
lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-10
max_val=10
del_val=1
del_cont=1
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(cold_to_hot_colormap) 


m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
%colormap(fresh_to_salty_colormap) 
[cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none','xticklabel',[]);


%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
b=gca;
hold on
m_coast('patch',[1 1 1]);
t1=m_text(30,100,['(b) ', num2str(imon+1)],'fontsize',12);
t2=m_text(320,-105,'[10^8 J m ^{-2}]','fontsize',12);

caxis([min_val max_val-del_cont])

hold off

jb=axes('pos',[.262 .90-.0475 .51 .01]);
%colormap jet(256)

colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
%xlabel('Upper Ocean Heat Content Anomaly [J m ^{-2} x 10^9]')



subplot(3,1,3)

lon=lon2;
lat=lat2;


corrhc=(mean_heat_oa_100(:,:,imon+2)+mean_heat_oa_100_300(:,:,imon+2)+mean_heat_oa_300_700(:,:,imon+2))./1e8;
corrhc=corrhc-mh;
lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-10
max_val=10
del_val=1
del_cont=1
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(cold_to_hot_colormap) 


m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
%colormap(fresh_to_salty_colormap) 
[cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none','xticklabel',[]);


%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
c=gca;
hold on
m_coast('patch',[1 1 1]);
t1=m_text(30,100,['(c) ', num2str(imon+2)],'fontsize',12);
t2=m_text(320,-105,'[10^8 J m ^{-2}]','fontsize',12);

caxis([min_val max_val-del_cont])

hold off

jc=axes('pos',[.262 .90-.0475 .51 .01]);
%colormap jet(256)

colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(jc,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
%xlabel('Upper Ocean Heat Content Anomaly [J m ^{-2} x 10^9]')






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

set(ja,'XAxisLocation','bottom','pos',japos-[-.075 .155 .15 0])
set(jb,'XAxisLocation','bottom','pos',jbpos-[-.075 -.225 .15 0])
set(jc,'XAxisLocation','bottom','pos',jcpos-[-.075 .805 .15 0])

%%% print plot
wysiwyg;orient tall
eval(['print -dpng -f1 /Users/lyman/figs/oco/Oceans/oco_heat_2016_2015_2014_3_pannel_season_insitu_',num2str(imon)])
end