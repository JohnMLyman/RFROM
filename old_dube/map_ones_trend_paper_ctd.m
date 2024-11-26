function map_ones_trend_paper_ctd(start_time,end_time)
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
load 'htanom_1967_2002_revb.mat'
%error=1-(error-2.2);
 lon2=lon;

 lat2=lat;
nlon=length(lon_tpx);
nlat=length(lat_tpx);
corrhc_one_total=ones(nlon,nlat)*0;


 start_ind=find(time == start_time+.5);
end_ind=find(time == end_time+.5);
ntime=length(time(start_ind:end_ind));
corr_one_var=ones(nlon,nlat,ntime); 

 
for index=start_ind:end_ind
i=index-start_ind+1;
%%%figure(i);wysiwyg

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask

corrhc=interp2(lat,lon,ht(:,:,index),lat_tpx,lon_tpx')./1e9;

corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;

corrhc_one=interp2(lat,lon,one(:,:,index),lat_tpx,lon_tpx');
corrhc_one(isnan(corrhc_one))=0.;

corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one(isnan(sshmean))=NaN;

%corrhc_error=interp2(lat,lon,error(:,:,index),lat_tpx,lon_tpx');
%corrhc_error(isnan(msk2(2:end-1,:)))=NaN;

corrhc_one_total=corrhc_one_total+corrhc_one;
corrhc_one_var(:,:,i)=corrhc_one;

lon=lon_tpx;
lat=lat_tpx;
Area=sum(arw(~isnan(corrhc_one)));
% compute the area average heatcontent across the globe.

hc(i)=1e9.*nansum(arw(:).*corrhc(:))/sum(arw(~isnan(corrhc(:))));
hc_one(i)=nansum(arw(:).*corrhc_one(:))/sum(arw(~isnan(corrhc_one(:))));

good_lat=find(lat <= -30);

arw2=arw(:,good_lat);
corrhcs=corrhc(:,good_lat);
corrhc_ones=corrhc_one(:,good_lat);

hc_south(i)=1e9.*nansum(arw2(:).*corrhcs(:))/sum(arw(~isnan(corrhc(:))));
hc_one_south(i)=nansum(arw2(:).*corrhc_ones(:))/sum(arw(~isnan(corrhc_one(:))));

time_hc(i)=time(index);
end
% put into the proper coordinates
% % % min_val=-2
% % % max_val=2
% % % del_val=.2
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

corrhc=[corrhc_one_total(jj,:);corrhc_one_total(ii,:)]./length(time_hc);
colormap jet(256)

pcolor(lon,lat,corrhc')
caxis([min_val max_val])
shading flat

t1=text(70,50,[num2str(time(start_ind)-.5),'-',num2str(time(end_ind)-.5)],'fontsize',16,'fontweight','bold');
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
xlabel('mean area fraction')



%Plot the map of the standard devation of the ratio of varibilty in the map

corrhc_one_var2=ones(nlon,nlat)*0.;

for itime=1:ntime 
    
    corrhc_one=corrhc_one_var(:,:,itime);
    

corrhc_one_var2=corrhc_one;

figure(2);wysiwyg

min_val=0
max_val=1
del_val=.1

corrhc=[corrhc_one_var2(jj,:);corrhc_one_var2(ii,:)];
colormap jet(256)

pcolor(lon,lat,corrhc')
caxis([min_val max_val])
shading flat

t1=text(70,50,[num2str(time(start_ind+itime-1)-.5)],'fontsize',16,'fontweight','bold');
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
xlabel('area fraction')




%wysiwyg
time_map_string=num2str(time(start_ind+itime-1)-.5)

eval(['print -dpng -f2 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/map_one_revb_',time_map_string])
close(2)
end
time_string=[num2str(time(start_ind)-.5),'_',num2str(time(end_ind)-.5)];
eval(['print -dpng -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/trend_paper/mean_one_trend2_revb_',time_string])
