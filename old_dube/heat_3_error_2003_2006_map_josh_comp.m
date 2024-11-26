

load ../../Mtpers/meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat

load ../../HC/landmask msk2
%[lon,lat,time,ht]=load_idl_data_mean_heat('../SAL/Floats/mean_1960_2000.nc');
load 'htanom_2003_2006_3_error_josh.mat'
error=1-(error-2.2);
 lon2=lon;

 lat2=lat;
 ht_josh=ht;
 one_josh=one;
 clear one ht
 load htanom_1950_2006_3_error
    error=1-(error-2.2);
 lon2=lon;

 lat2=lat;
time=time(end-3:end);
one=one(:,:,end-3:end);
ht=ht(:,:,end-3:end);

% one=one-one_josh;
% ht=ht-ht_josh;

for i=1:length(time)
%i=3
figure(1);wysiwyg

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask

%josh
corrhc_josh=interp2(lat,lon,ht_josh(:,:,i),lat_tpx,lon_tpx')./1e9;
corrhc_josh(isnan(msk2(2:end-1,:)))=NaN;
corrhc_josh(isnan(sshmean))=NaN;

corrhc_one_josh=interp2(lat,lon,one_josh(:,:,i),lat_tpx,lon_tpx');
corrhc_one_josh(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one_josh(isnan(sshmean))=NaN;

%john


corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx')./1e9;
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;

corrhc_one=interp2(lat,lon,one(:,:,i),lat_tpx,lon_tpx');
corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one(isnan(sshmean))=NaN;

corrhc_error=interp2(lat,lon,error(:,:,i),lat_tpx,lon_tpx');
corrhc_error(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one(isnan(sshmean))=NaN;

lon=lon_tpx;
lat=lat_tpx;
Area=sum(arw(~isnan(corrhc)));
% compute the area average heatcontent across the globe.

hc(i)=1e9.*nansum(arw(:).*corrhc(:))/sum(arw(~isnan(corrhc)));
hc_one(i)=nansum(arw(:).*corrhc_one(:))/sum(arw(~isnan(corrhc_one)));
hc_josh(i)=1e9.*nansum(arw(:).*corrhc_josh(:))/sum(arw(~isnan(corrhc_josh)));
hc_one_josh(i)=nansum(arw(:).*corrhc_one_josh(:))/sum(arw(~isnan(corrhc_one_josh)));

time_hc(i)=time(i);

% % % % put into the proper coordinates
% % % min_val=-.1
% % % max_val=.1
% % % del_val=.05
% % % 
% % % ii=find(lon<30);
% % % jj=find(lon>=30);
% % % lon=[lon(jj);lon(ii)+360];
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
% % % xlabel('heat Content [J 10^9 m^-2] john-josh')
% % % 
% % % 
% % % 
% % % %Plot the ones map
% % % 
% % % %put into the proper coordinates
% % % 
% % % figure(101);wysiwyg
% % % 
% % % min_val=-.1
% % % max_val=.1
% % % del_val=.05
% % % 
% % % corrhc=[corrhc_one(jj,:);corrhc_one(ii,:)];
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
% % % xlabel('one josh (negitive) john (positive)')
% % % 
% % % 
% % % 
% % % 
% % % 
% % % %Plot the error map
% % % 
% % % %put into the proper coordinates
% % % % % % 
% % % % % % figure(i+200);wysiwyg
% % % % % % 
% % % % % % min_val=0
% % % % % % max_val=1
% % % % % % del_val=.2
% % % % % % 
% % % % % % corrhc=[corrhc_error(jj,:);corrhc_error(ii,:)];
% % % % % % colormap jet(256)
% % % % % % 
% % % % % % pcolor(lon,lat,corrhc')
% % % % % % caxis([min_val max_val])
% % % % % % shading flat
% % % % % % 
% % % % % % t1=text(70,50,[num2str(time(i))],'fontsize',16,'fontweight','bold');
% % % % % % axis([30 390 -90 90])
% % % % % % axis equal
% % % % % % axis([30 390 -90 90])
% % % % % % set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
% % % % % % hold on
% % % % % % j=axes('pos',[.13 .85 .775 .02]);
% % % % % % colormap jet(256)
% % % % % % 
% % % % % % [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
% % % % % % set(h,'edgecolor','none')
% % % % % % set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
% % % % % % caxis([min_val max_val])
% % % % % % xlabel('error')
% % % % % % 
% % % % % % 
% % % % % % 
% % % 
% % % %% print plot
% % % 
% % % eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/talk/diff_heat_',num2str(time(i))])
% % % eval(['print -dpng -f101 /home/shoko/C/','''IDL ps''','/heat/talk/diff_one_',num2str(time(i))])
% % % 
close all
%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg


end
mean_hc=mean(hc);

figure(10); clf;orient landscape; wysiwyg
p=plot(time,(hc)*3.4e14./1e21./hc_one)
p4=plot(time,(hc)*3.4e14./1e21,'.')
hold on
p2=plot(time,hc_josh.*3.4e14./1e21./hc_one_josh,'r')
p2=plot(time,hc_josh.*3.4e14./1e21,'r.')

set(p,'linewidth',3)
set(p2,'linewidth',3)
ylabel(' John-Josh Heat content Anomaly [zeta-joules]','fontsize',16);
title('0-750 m Ocean Heat Content Anomaly John-Josh','fontsize',18);
xlabel('Time [years]','fontsize',16)
set(gca,'fontsize',16, 'tickdir','out')



eval(['print -dpng -f10 /home/shoko/C/','''IDL ps''','/heat/talk/ht_diff_one'])
