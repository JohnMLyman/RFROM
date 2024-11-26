function [junk]=seasonal_oco_2010_2_pannel_gen_com(lon,lat,ht,idepth,imonth,itype,inoise,range,del)
lon_ht=lon;
lat_ht=lat;
junk=1;
cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);





load /Volumes/Data/Globalhc/HC/landmask msk2
 load /Volumes/Data/Globalhc/Mtpers/meanssh_oco_realtime lat lon
 lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

corrhc=interp2(lat_ht,lon_ht,ht./1e9,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc(isnan(msk2(2:end-1,:)))=NaN;


% plot the heat content for 2008
figure(1);wysiwyg
subplot(2,1,1)



lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-1.*range
max_val=range
del_val=del

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(cold_to_hot_colormap) 

pcolor(lon,lat,corrhc')
caxis([min_val max_val])
shading flat

plot_coasts_black

axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
a=gca;
%set(a,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
set(a,'xtick',[30:30:390],'tickdir','out','XtickLabel', {'30E' '60E' '90E' '120E' '150E' '180' '150W' '120W' '90W' '60W' '30W' '0' '30E'},'ytick',[-90:30:90],...
    'YtickLabel',{'90S' '60S' '30S' '0' '30N' '60N' '90N'},'fontsize',9)



hold on


ja=axes('pos',[.262 .90 .51 .01]);
%colormap jet(256)

colormap(cold_to_hot_colormap) 

[~,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel(['Upper Ocean Heat Content Anomaly ',num2str(idepth),' m, month ',num2str(imonth),'  [J m ^{-2} x 10^9]'])







%%%%sort the polots

apos=get(a,'pos')

set(a,'pos',apos+[0 -.05 0 0])

%%% print plot

eval(['print -dpng -f1 /Users/johnlyman/figs/oco/seasonal_cycle/seasonal_',num2str(idepth),'m_month_',num2str(imonth),'_sm_',num2str(itype),'deg_',num2str(inoise),'_raito.png'])

