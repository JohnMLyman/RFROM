

function [syear]=sal_map_oco_2009_2010_6deg_2_pannel_multi_label_WOD09_m_map(fyear)

syear=fyear-1;
cd '/Volumes/Data/Globalhc/SAL/Floats/'
fresh_to_salty_colormap=[[1,146,191]'/255,[255,255,255]'/255,[255,158,15]'/255]';
fresh_to_salty_colormap=interp1([0:1/2:1],fresh_to_salty_colormap,[0:1/255:1]);
fresh_to_salty_colormap=diverging_map([0:1/100:1],[20 43 140]/255,[204 85 0]/255); 

cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);

load /Volumes/Data/Globalhc/Mtpers/meanssh lat lon
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

clear lon lat

load /Volumes/Data/Globalhc/HC/landmask msk2
%[lon,lat,time,fresh]=load_idl_data_fresh('fresh_aviso_2003_2005.nc');

%ncload('surface_sal_anom_3_error_2004_2005.nc','lat','lon','sal','time','one');
load 'surface_sal_jan_2012_2002_2012_6_deg.mat' lat lon time one sal;
% 
% 
% ncid=netcdf.open('surface_sal_anom_3_error_6_deg_jan_2004_2010.nc','NC_NOWRITE');
% 
% varid = netcdf.inqVarID(ncid,'lat');
% lat=netcdf.getVar(ncid,varid);
% 
% varid = netcdf.inqVarID(ncid,'lon');
% lon=netcdf.getVar(ncid,varid);
% 
% varid = netcdf.inqVarID(ncid,'time');
% time=netcdf.getVar(ncid,varid);
% 
% varid = netcdf.inqVarID(ncid,'sal');
% sal=netcdf.getVar(ncid,varid);
% 
% varid = netcdf.inqVarID(ncid,'one');
% one=netcdf.getVar(ncid,varid);
% 
% varid = netcdf.inqVarID(ncid,'error');
% error=netcdf.getVar(ncid,varid);
% 
% netcdf.close(ncid)
%one=permute(one,[3 2 1]);
%errorw=permute(error,[3 2 1]);
surface_sal=sal;

ind_2006=find(time == syear+.5);
ind_2007=find(time == fyear+.5);


surface_sal_2006=surface_sal(:,:,ind_2006);
one_2006=one(:,:,ind_2006);
surface_sal_2007=surface_sal(:,:,ind_2007);
one_2007=one(:,:,ind_2007);

% Mask loaction with less than a 80% coverage

bad=find(one_2006 <= .8);
surface_sal_2006(bad)=NaN;
bad=find(one_2007 <= .8);
surface_sal_2007(bad)=NaN;



% this section is because a grided lon=180 and not lon=-180, this sets data
% at -180 to the same values as 180...
%surface_sal(end+1,:,1)=surface_sal(1,:,1);
%lon(end+1)=-180.0;
 lon2=lon;
 lat2=lat;


%i=3
load /Volumes/Data/WOA09/salinity_annual_1deg_cont.mat sal_cont lat_cont lon_cont

%corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx');
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
%corrhc(isnan(sshmean))=NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the heat content for 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);wysiwyg;orient tall
set(gcf,'color','white');
lon=lon2;
lat=lat2;
subplot(2,1,1)
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);

corrhc=interp2(lat,lon,surface_sal_2007,lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;

land_mask=msk2(2:end-1,:);

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-.5
max_val=.5
del_val=.25
del_cont=.05
miss_val= (min_val-max_val)./100;
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
land_mask=[land_mask(jj,:);land_mask(ii,:)];

corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(fresh_to_salty_colormap) 

corrhc(corrhc>max_val)=max_val;
corrhc(corrhc<min_val)=min_val;
corrhc(~isfinite(corrhc))=NaN;
sal_cont=double(sal_cont);
%sal_cont(~isfinite(corrhc))=NaN;
%corrhc(~isfinite(land_mask))=NaN;
%contour_mean_sal_no_label_WOD09_m_map
%[cs12,h12]=m_contour(lon,lat,corrhc',[min_val:del_cont:max_val],'k');
%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont','c');

hold on

%colormap(fresh_to_salty_colormap) 
[cs1,h1]=m_contourf(lon,lat,corrhc',[-10000, min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none');

wysiwyg;orient tall
contour_mean_sal_no_label_WOD09_m_map
%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');

hold on
m_coast('patch',[1 1 1]);
t1=m_text(60,54,['a) ',num2str(fyear)],'fontsize',11,'fontweight','bold');

caxis([min_val max_val-del_cont])

hold off


%contour_mean_sal_WOD09
%contour_mean_sal_no_label

 
% axis([30 390 -90 90])
% axis equal
% axis([30 390 -90 90])
a=gca;
%set(a,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
% set(a,'xtick',[30:30:390],'tickdir','out','XtickLabel', {'30E' '60E' '90E' '120E' '150E' '180' '150W' '120W' '90W' '60W' '30W' '0' '30E'},'ytick',[-90:30:90],...
%     'YtickLabel',{'90S' '60S' '30S' '0' '30N' '60N' '90N'},'fontsize',9)


hold on
ja=axes('pos',[.262 .90-.0475 .51 .01]);
%colormap jet(256)

colormap(fresh_to_salty_colormap)

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
xlabel('Surface Salinity Anomaly [PSS-78]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % plot surface_sal for 2006%%
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % 
% % % 
% % % figure(2);wysiwyg
% % % lon=lon2;
% % % lat=lat2;
% % % 
% % % 
% % % corrhc=interp2(lat,lon,surface_sal_2006,lat_tpx,lon_tpx');
% % % corrhc(isnan(msk2(2:end-1,:)))=NaN;
% % % 
% % % 
% % % lon=lon_tpx;
% % % lat=lat_tpx;
% % % 
% % % 
% % % % put into the proper coordinates
% % % min_val=-.5
% % % max_val=.5
% % % del_val=.25
% % % 
% % % ii=find(lon<30);
% % % jj=find(lon>=30);
% % % lon=[lon(jj);lon(ii)+360];
% % % corrhc=[corrhc(jj,:);corrhc(ii,:)];
% % % %colormap jet(256)
% % % colormap(fresh_to_salty_colormap)
% % % 
% % % pcolor(lon,lat,corrhc')
% % % 
% % % 
% % % 
% % % caxis([min_val max_val])
% % % shading flat
% % % 
% % % contour_mean_sal
% % % plot_coasts_black
% % % 
% % % 
% % % t1=text(60,50,'2007','fontsize',16,'fontweight','bold');
% % % axis([30 390 -90 90])
% % % axis equal
% % % axis([30 390 -90 90])
% % % set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
% % % hold on
% % % j=axes('pos',[.13 .85 .775 .02]);
% % % %colormap jet(256)
% % % colormap(fresh_to_salty_colormap)
% % % 
% % % [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
% % % set(h,'edgecolor','none')
% % % set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
% % % caxis([min_val max_val])
% % % xlabel('Surface Salinity Anomaly [PSS-78]]')
% % % 
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot 1-year surface_sal  cange 2008 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


subplot(2,1,2)
colormap(fresh_to_salty_colormap)
lon=lon2;
lat=lat2;


corrhc=interp2(lat,lon,surface_sal_2007-surface_sal_2006,lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;
land_mask=msk2(2:end-1,:);

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-.5
max_val=.5
del_val=.25
miss_val= (min_val-max_val)./100;

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
land_mask=[land_mask(jj,:);land_mask(ii,:)];

%colormap jet(256)
colormap(fresh_to_salty_colormap)


corrhc(corrhc>max_val)=max_val;
corrhc(corrhc<min_val)=min_val;
corrhc(~isfinite(corrhc))=NaN;

[cs1,h1]=m_contourf(lon,lat,corrhc',[-10000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'xticklabel',[],'ytick',[-90:30:90],'linestyle','none');


contour_mean_sal_no_label_WOD09_m_map
%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');

hold on
m_coast('patch',[1 1 1]);
t1=m_text(55,54,['b) ',num2str(fyear),'-',num2str(syear)],'fontsize',11,'fontweight','bold');
caxis([min_val max_val-del_cont])
b=gca;
apos=get(a,'pos')

bpos=get(b,'pos')
set(b,'pos',bpos+[0 .03+.035 0 0],'xticklabel',[])
set(a,'pos',apos+[0 -.05-.03 0 0])

%contour_mean_sal_WOD09
%contour_mean_sal_no_label


hold on
jb=axes('pos',[.262 .10+.06 .51 .01]);
%colormap jet(256)
colormap(fresh_to_salty_colormap)
%  c=colormap;
%  c(1,:)=2/3;
%  colormap(c)
[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(jb,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
xlabel('1-year Surface Salinity Change [PSS-78 yr ^{-1}]')


set(jb,'XAxisLocation','bottom')
set(b,'xticklabel',[])


%%%%%%%%%%%%%%%%%%
%%% print plots  %
%%%%%%%%%%%%%%%%%%
wysiwyg;orient tall
%eval(['print -dtiff -f1 /Users/johnlyman/figs/oco/Sal/oco_2008_oct_surface_sal_6deg_jan_2008'])
%%eval(['print -dtiff -f2 /Users/johnlyman/figs/oco/Sal/oco_2008_oct_surface_sal_6deg_jan_2007'])
%%eval(['print -dtiff -r600 -f1 /Users/johnlyman/figs/oco/Sal/oco_2008_oct_surface_sal_6deg_change_jan_2008_2007_2_pannel_test'])
eval(['print -dpng -f1 /Users/johnlyman/figs/oco/Sal/oco_',num2str(fyear),'_jan_surface_sal_6deg_change_2013'])
eval(['print -depsc2 -r300 -f1 /Users/johnlyman/figs/oco/Sal/oco_',num2str(fyear),'_jan_surface_sal_6deg_change_2013'])

%eval(['print -dtiff -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/oco/oco_surface_sal_6deg_2006'])
%eval(['print -dtiff -f2 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/oco/oco_surface_sal_6deg_2005'])
%eval(['print -dtiff -f3 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/oco/oco_surface_sal_6deg_change_2006_2005'])

%close all
%%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg

