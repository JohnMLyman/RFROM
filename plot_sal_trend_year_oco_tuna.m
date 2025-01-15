
% path='C:\data\SAL\'
path='K:\data\SAL\';
path_tpx_means='C:\Users\jlyma\OneDrive - University of Hawaii\Documents\OHCA_2020\tpest_test\tpxtest\';
path_figs='H:\Figs\sal\';
path_tpx_means='G:\C_drive\Documents\OHCA_2020\tpest_test\tpxtest\';
fresh_to_salty_colormap=[[1,146,191]'/255,[255,255,255]'/255,[255,158,15]'/255]';
fresh_to_salty_colormap=interp1([0:1/2:1],fresh_to_salty_colormap,[0:1/255:1]);
fresh_to_salty_colormap=diverging_map([0:1/201:1],[20 43 140]/255,[204 85 0]/255);
original=cd(path);

load([path_tpx_means,'meanssh.mat'], 'lat', 'lon')
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
load([path_tpx_means,'landmask.mat'], 'msk2')

% load the data
file_name_slope_salt=[path_sal,'slope_salt_',file_surface_name,'_', num2str(year_of_oco_pub),'.mat'];
% salt_slope_oco_tuna
if ~exist(file_name_slope_salt,'file')
    
    salt_slope_oco_tuna
    
else
    eval(['load ',file_name_slope_salt])
end


corrhc=interp2(lat,lon,slope,lat_tpx,lon_tpx');



land_mask=msk2(2:end-1,:);
corrhc(isnan(msk2(2:end-1,:)))=NaN;

slope=corrhc;

corrhc=interp2(lat,lon,error,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc(isnan(msk2(2:end-1,:)))=NaN;

error=corrhc;
lon=lon_tpx;
lat=lat_tpx;
% put into the proper coordinates

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];

land_mask=[land_mask(jj,:);land_mask(ii,:)];
slope=[slope(jj,:);slope(ii,:)];
error=[error(jj,:);error(ii,:)];

% % get rid of some junk in error
% 
% ii=find(isfinite(slope)==0);
% error(ii)=NaN;

% make a ratio of slope to error in slope

r=(slope)./error;
r2=abs(slope)-abs(error);


%figure(1);  wysiwyg;orient tall


m_proj('Equidistant Cylindrical','lon',[30 390],'lat',[-90 90]);

set(gcf,'color','white');
% Mapset up
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
% put into the proper coordinates
min_val=-.15
max_val=.15
del_val=.05
del_cont=.01;
miss_val= (min_val-max_val)./100;
subplot(3,1,3)

colormap(fresh_to_salty_colormap) 
%mask missing

slope(slope>max_val)=max_val;
slope(slope<min_val)=min_val;
slope(~isfinite(slope))=NaN; 
patch_m=slope;
patch_m(isfinite(patch_m))=0;
patch_m(~isfinite(patch_m))=2;
%pathc_m(patch_m==0)=NaN;

%slope(~isfinite(land_mask))=NaN;
%min_val+miss_val;

%pcolor(lon,lat,slope')
[cs,h]=m_contour(lon,lat,r2',[0 0],'k','linew',0.1);
hold on
% [cs3,h3]=m_contourf(lon,lat,patch_m',[1 1]);
% hold on
[cs1,h1]=m_contourf(lon,lat,slope',[-.15:del_cont:.15]);
hold on
%set(h1,'linewidth',.00001,'linecolor','w')
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none','fontname','arial','fontsize',12,'box','on','linew',1);

m_coast('patch',.999*[1 1 1]);
t1=m_text(30,100,['(c) ',num2str(slope_min_year),'-',num2str(year_of_oco_pub-1),' trend'],'fontsize',12,'fontname','arial','linew',0.1);
t2=m_text(320,-115,['(PSS-78 yr ^{-1})'],'fontsize',12,'fontname','arial');

colormap(fresh_to_salty_colormap) 

%[cs,h]=m_contour(lon,lat,r2',[0 0],'k');

%set(h,'linecolor','none')
% % m_coast('patch',[1 1 1]);
% % t1=m_text(60,54,'a)','fontsize',11,'fontweight','bold');
caxis([min_val max_val-del_cont])
hold off
%offset=-1.*(25/255);

%caxis([(-8+offset) 8])





%caxis([min_val max_val])


%  c=colormap;
%  c(1,:)=2/3;
%  colormap(c)






%shading flat
%plot_coasts_black
% 
% axis([30 390 -90 90])
% axis equal
% axis([30 390 -90 90])
% set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
c=gca;
%cpos=get(c,'pos');
%set(c,'pos',cpos+[0 -.08 0 0],'linew',3)
%drawnow
% %set(a,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
% set(a,'xtick',[30:30:390],'tickdir','out','XtickLabel', {'30E' '60E' '90E' '120E' '150E' '180' '150W' '120W' '90W' '60W' '30W' '0' '30E'},'ytick',[-90:30:90],...
%     'YtickLabel',{'90S' '60S' '30S' '0' '30N' '60N' '90N'},'fontsize',9)

hold on



%%% stipled

nlat=length(lat);
nlon=length(lon);
% put dots on 1 degree grid

[~,good_lat]=unique(floor(lat));
[~,good_lon]=unique(floor(lon));

good_lat=good_lat(1:2:end);
good_lon=good_lon(1:2:end);

lats=repmat(lat',1080,1);
lons=repmat(lon,1,915);
rf=r;
rf(abs(r)>=1)=nan;
rf(abs(r)<1)=1;
llons=lons(good_lon,good_lat);
llats=lats(good_lon,good_lat);
rrf=rf(good_lon,good_lat);
%mlp=m_plot(llons(isfinite(rrf)),llats(isfinite(rrf)),'k.','MarkerSize',.5)
m_scatter(llons(:),llats(:),rrf(:),'k','filled')

%%%%

%ja=axes('pos',[.13 .85 .775 .02]);

[cs,h]=m_contour(lon,lat,r2',[0 0],'k','linew',0.1);
jc=axes('pos',[.262 .90-.0475 .51 .01]);
%colormap jet(256)


%[cs,h]=contourf([-8:.01:8],[0 1],[1 1]'*[(-8-(offset)):.01:(8-(offset))],[-8:(8+8)/254:8]);
[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);

set(h,'edgecolor','none')
set(jc,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[],'fontsize',12,'fontname','arial')

%caxis([-12 12])
%xlabel('2005-2015 Surface Salinity Trend (PSS-78 yr ^{-1})','fontsize',12,'fontname','arial')
caxis([min_val max_val-del_cont])
%%
% % % % % subplot(2,1,2)
% % % % % colormap(fresh_to_salty_colormap) 
% % % % % %colormap(jet)
% % % % % 
% % % % % %% rescale r
% % % % % 
% % % % % 
% % % % % m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
% % % % % 
% % % % % min_val=-3;
% % % % % max_val=3;
% % % % % del_cont=2/3;
% % % % % r3=r;
% % % % % r3(r3>3)=3;
% % % % % r3(r3<-3)=-3;
% % % % % r3((r3>=-1) & (r3<=1))=0;
% % % % % r3((r3<-1))=(r3(r3<-1)+1)*(3/2);
% % % % % r3((r3>1))=(r3(r3>1)-1)*(3/2);
% % % % % %%
% % % % % 
% % % % % miss_val=-6./100
% % % % % r3(~isfinite(r3))=NaN;
% % % % % 
% % % % % %pcolor(lon,lat,r3')
% % % % % [cs2,h2]=m_contourf(lon,lat,r3',[-1000, -3:del_cont:3]);
% % % % % hold on
% % % % % set(h2,'linecolor','none')
% % % % % 
% % % % % %shading flat
% % % % % % pcolor(lon,lat,r')
% % % % % % shading flat
% % % % % m_grid('xtick',[60:60:360],'ytick',[-90:30:90],'box','on','tickdir','out','linestyle','none','fontname','arial','fontsize',12,'linew',1);
% % % % % 
% % % % % m_coast('patch',.999*[1 1 1]);
% % % % % t1=m_text(30,100,'(b)','fontname','arial','fontsize',12,'linew',0.1);
% % % % % 
% % % % % caxis([min_val max_val-del_cont])
% % % % % % caxis([-3+miss_val 3])
% % % % % % axis([30 390 -90 90])
% % % % % % axis equal
% % % % % % axis([30 390 -90 90])
% % % % % b=gca;
% % % % % bpos=get(b,'pos');
% % % % % set(b,'pos',bpos+[0 .065 0 0],'linew',3)
% % % % % drawnow%set(b,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
% % % % % 
% % % % % hold on
% % % % % % % fool with the colormap
% % % % % % 
% % % % % %  c=colormap;
% % % % % %  c(1,:)=2/3;
% % % % % %  c(1,:)=1;
% % % % % % colormap(c)
% % % % % 
% % % % % jb=axes('pos',[.262 .125 .51 .01]);
% % % % % %colormap(c)
% % % % % 
% % % % % junk=[-3:.01:3];
% % % % % junkv=junk;
% % % % % junkv(junkv>-1 &junkv<1)=0;
% % % % % [cs,h]=contourf(junk,[0 1],[1 1]'*junkv,[-3:del_cont:3]);
% % % % % 
% % % % % set(h,'edgecolor','none')
% % % % % set(jb,'tickdir','out','xtick',[-3:del_cont:3],'ytick',[],'xticklabel',...
% % % % %    {'-3' ' ' ' ' '-1' ' ' ' ' '1' ' ' ' ' '3'},'fontname','arial','fontsize',12)
% % % % % %caxis([-2 2])
% % % % % xlabel('Ratio of Surface Salinity Trend to 95% Uncertainty','fontname','arial','fontsize',12)
% % % % % caxis([min_val max_val-del_cont])
% % % % % % now shift the plots around on the page
% % % % % 
% % % % % %%%sort the polots
% % % % % 
% % % % % % apos=get(a,'pos')
% % % % % % 
% % % % % % bpos=get(b,'pos')
% % % % % % set(b,'pos',bpos+[0 .03+.035 0 0],'xticklabel',[])
% % % % % % set(a,'pos',apos+[0 -.05-.03 0 0])
% % % % % % set(jb,'XAxisLocation','bottom')
% % % % % 
% % % % % % down=.1
% % % % % % 
% % % % % % q=get(gcf,'children');
% % % % % % a2=get(q(1),'pos');
% % % % % % a4=get(q(2),'pos');
% % % % % % a3=get(q(3),'pos');
% % % % % % a5=get(q(4),'pos');
% % % % % % 
% % % % % % aa=(1-a2(4)*2)/2;
% % % % % % a2(2)=aa;
% % % % % % a4(2)=aa+a2(4);
% % % % % % set(q(2),'pos',a4-[0 (down+.25) 0 0]);
% % % % % % set(q(1),'pos',a2-[0 (down+.3) 0 0]);
% % % % % % 
% % % % % % set(q(3),'pos',a3-[0 (down-.1) 0 0]);
% % % % % % set(q(4),'pos',a5-[0 (down) 0 0]);
% % % % % 
% % % % % %eval(['print -depsc -f1 /home/shoko/C/','''IDL ps''','/heat/agu/hc_change_2005_agu'])
% % % % % %eval(['print -dpng -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/hc_14_year_change'])
% % % % % % eval(['print -dpng -f1 /Users/johnlyman/figs/oco/Sal/sal_5_year_change2'])
% % % % % % eval(['print -dtiff -r600 -f1 /Users/johnlyman/figs/oco/Sal/sal_6_year_change2_2010'])
% % % % % 
% % % % % 
% % % % % %%
% % % % % % wysiwyg;orient tall
% % % % % % %    eval(['print -dpng -f1 /Users/johnlyman/figs/oco/Sal/sal_8_year_change2_2013_m'])
% % % % % % %    eval(['print -dtiff -f1  -r300 /Users/johnlyman/figs/oco/Sal/sal_8_year_change2_2013_m'])
% % % % %    eval(['print -dpdf -f1   /Users/lyman/figs/oco/Sal/sal_11_year_change2_2016_m_new'])
% % % % %    eval(['print -dtiff -f1  -r300    /Users/lyman/figs/oco/Sal/sal_11_year_change2_2016_m_new'])
% % % % %  % eval(['print -depsc2 -r600 -f1 /Users/johnlyman/figs/oco/Sal/sal_8_year_change2_2012_M'])

