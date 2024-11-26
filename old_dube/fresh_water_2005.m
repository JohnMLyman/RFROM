

load ../../Mtpers/meanssh lat lon
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

clear lon lat

load ../../HC/landmask msk2


[lon,lat,time,fresh]=load_idl_data_fresh('fresh_aviso_2003_2005.nc');
 lon2=lon;
 lat2=lat;

for i=1:1
%i=3
figure(1);wysiwyg

lon=lon2;
lat=lat2;


corrhc=interp2(lat,lon,fresh(:,:,i),lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;

lon=lon_tpx;
lat=lat_tpx;



% put into the proper coordinates
min_val=-4
max_val=4
del_val=.5

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
xlabel('Fresh Water Content Anomaly[m]')






%%% print plot

%eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/fresh_',num2str(time(i))])

%close all
%%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg
end
