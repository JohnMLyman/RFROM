

load ../../Mtpers/meanssh lat lon
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat

load ../../HC/landmask msk2
%[lon,lat,time,ht]=load_idl_data_mean_heat('../SAL/Floats/mean_1960_2000.nc');
load 'htanom_1993_2006_3_error.mat'
 lon2=lon;

 lat2=lat;

for i=1:length(time)
%i=3
figure(i);wysiwyg

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask

corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx')./1e9;
corrhc(isnan(msk2(2:end-1,:)))=NaN;

corrhc_one=interp2(lat,lon,one(:,:,i),lat_tpx,lon_tpx');
corrhc_one(isnan(msk2(2:end-1,:)))=NaN;

lon=lon_tpx;
lat=lat_tpx;
Area=sum(arw(~isnan(corrhc)));
% compute the area average heatcontent across the globe.

hc(i)=1e9.*nansum(arw(:).*corrhc(:))/sum(arw(~isnan(corrhc)));
hc_one(i)=nansum(arw(:).*corrhc_one(:))/sum(arw(~isnan(corrhc_one)));

time_hc(i)=time(i);

% put into the proper coordinates
min_val=-2
max_val=2
del_val=.2

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
colormap jet(256)

pcolor(lon,lat,corrhc')
caxis([min_val max_val])
shading flat

t1=text(70,50,[num2str(time(i))],'fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
j=axes('pos',[.13 .85 .775 .02]);
colormap jet(256)

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('mean heat Content [m]')



%%Plot the ones map

% put into the proper coordinates

figure(i+100);wysiwyg

min_val=0
max_val=1
del_val=.2

corrhc=[corrhc_one(jj,:);corrhc_one(ii,:)];
colormap jet(256)

pcolor(lon,lat,corrhc')
caxis([min_val max_val])
shading flat

t1=text(70,50,[num2str(time(i))],'fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
j=axes('pos',[.13 .85 .775 .02]);
colormap jet(256)

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('one')







%%% print plot

%eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/fresh_',num2str(time(i))])

%close all
%%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg

end
figure(i+1)
mean_hc=mean(hc);

plot(time,(hc-mean_hc)*3.4e14)
