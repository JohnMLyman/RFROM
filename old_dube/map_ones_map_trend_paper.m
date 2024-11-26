function map_ones_map_trend_paper(year_map)
%start_time=1993
%end_time=2006
%close(1)
%close(2)
load ../../Mtpers/meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);2
clear lon lat

load ../../HC/landmask msk2
%[lon,lat,time,ht]=load_idl_data_mean_heat('../SAL/Floats/mean_1960_2000.nc');
%load 'htanom_1950_2006_3_error.mat'
load 'htanom_1955_2006_trend_paper2.mat'
%error=1-(error-2.2);
 lon2=lon;

 lat2=lat;
nlon=length(lon_tpx);
nlat=length(lat_tpx);
corrhc_one_total=ones(nlon,nlat)*0;


 index=find(time == year_map+.5);


 

%%%figure(i);wysiwyg

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask


corrhc_one=interp2(lat,lon,one(:,:,index),lat_tpx,lon_tpx');
corrhc_one(isnan(corrhc_one))=0.;
corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
%show ice
%corrhc_one(isnan(sshmean))=NaN;



lon=lon_tpx;
lat=lat_tpx;
Area=sum(arw(~isnan(corrhc_one)));
% compute the area average heatcontent across the globe.






% % % 
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
% % % corrhc=[corrhc(jj,:);corrhc(ii,:)];
% % % colormap jet(256)
% % % 
% % % pcolor(lon,lat,corrhc')
% % % caxis([min_val max_val])
% % % shading flat
% % % 
% % % t1=text(70,50,[num2str(time(i))],'fontsize',16,'fontweight','bold');
% % % axis([30 390 -90 90])
% % % axis equal
% % % axis([30 390 -90 90])
% % % set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
% % % hold on
% % % j=axes('pos',[.13 .85 .775 .02]);
% % % colormap jet(256)
% % % 
% % % [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
% % % set(h,'edgecolor','none')
% % % set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
% % % caxis([min_val max_val])
% % % xlabel('heat Content [J 10^9 m^-2]')
% % % 
% % % 
% % % 
% % % %%Plot the ones map

% put into the proper coordinates

figure(1);wysiwyg

min_val=0
max_val=1
del_val=.2

corrhc=[corrhc_one(jj,:);corrhc_one(ii,:)];
colormap(flipud( jet(256)))

pcolor(lon,lat,corrhc')
caxis([min_val max_val])
shading flat

t1=text(70,50,[num2str(time(index)-.5)],'fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
j=axes('pos',[.13 .85 .775 .02]);
colormap(flipud( jet(256)))

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('fraction of area')




times_string=[num2str(time(index)-.5)];
eval(['print -dpng -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/map_one_trend2_',times_string])
