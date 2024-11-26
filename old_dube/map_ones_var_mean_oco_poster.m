function map_ones_var_mean_oco_poster(start_year,end_year)

%close(1)
%close(2)
cd '/Users/johnlyman/data/Globalhc/SAL/Floats'
load ../../Mtpers/meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);2
clear lon lat

load ../../HC/landmask msk2
%[lon,lat,time,ht]=load_idl_data_mean_heat('../SAL/Floats/mean_1960_2000.nc');
load htanom_2004_2007_mon_975
%load 'htanom_1955_2006_trend_paper2.mat'
%error=1-(error-2.2);
 lon2=lon;

 lat2=lat;
nlon=length(lon_tpx);
nlat=length(lat_tpx);
corrhc_one_total=ones(nlon,nlat)*0;
year_map=floor(time);
mon_map=round(12.*(time-floor(time)))+1;

 start_ind=find(year_map == start_year & mon_map == 1);
end_ind=find(year_map == end_year & mon_map == 12 );
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
junk_map=colormap(jet(256));
junk_map=junk_map([256:-1:1],:);
colormap(junk_map)

pcolor(lon,lat,corrhc')
plot_coasts_black
caxis([min_val max_val])
shading flat

t1=text(70,50,[num2str(start_year),'-',num2str(end_year)],'fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
j=axes('pos',[.13 .85 .775 .02]);
colormap(junk_map)

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);

set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('mean area fraction')



%Plot the map of the standard devation of the ratio of varibilty in the map

corrhc_one_var2=ones(nlon,nlat)*0.;

for itime=1:ntime 
    
    corrhc_one_var2=(corrhc_one_var(:,:,itime)-corrhc_one_total./ntime).^2+corrhc_one_var2;
    
end

corrhc_one_var2=sqrt(corrhc_one_var2./ntime);

figure(2);wysiwyg

min_val=0
max_val=.3
del_val=.05

corrhc=[corrhc_one_var2(jj,:);corrhc_one_var2(ii,:)];
colormap jet(256)

pcolor(lon,lat,corrhc')
plot_coasts_black
caxis([min_val max_val])
shading flat

t1=text(70,50,[num2str(start_year),'-',num2str(end_year)],'fontsize',16,'fontweight','bold');
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
xlabel('area fraction standard devation')





% % % 
% % % %%Plot the error map
% % % 
% % % % put into the proper coordinates
% % % 
% % % figure(i+200);wysiwyg
% % % 
% % % min_val=0
% % % max_val=1
% % % del_val=.2
% % % 
% % % corrhc=[corrhc_error(jj,:);corrhc_error(ii,:)];
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
% % % xlabel('error')
% % % 
% % % 
% % % 
% % % 
% % % %%% print plot
% % % 
% % % %eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/fresh_',num2str(time(i))])
% % % 
% % % %close all
% % % %%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg


%figure(3)
%wysiwyg

%area_of_earth=5.1e14;
%hc1=hc*3.4e14;
%hc2=hc1./hc_one;
%plot(time_hc,(hc)*3.4e14./hc_one,'k')
%hold on
%plot(time_hc,hc_south*3.4e14./hc_one_south,'.-k')
%title('corrected OHCA 0-750m') 


%figure(4)
%wysiwyg

%plot(time_hc,hc_one_south*100)
%title('% of area bellow 30 south')

times_string=[num2str(start_year),'_',num2str(end_year)];
eval(['print -dtiff -f1 /Users/johnlyman/figs/oco/poster/mean_old_one_mon_',times_string])
eval(['print -dtiff -f2 /Users/johnlyman/figs/oco/poster/std_old_one_mon_',times_string])
%eval(['print -dpng -f3 ../figs/trend_paper/south_trend_',times_string])
%eval(['print -dpng -f4 ../figs/trend_paper/per_south_',times_strig])

%  [ym2,yme2,se2,slope2]=j_fit(time_hc,hc2,1);
%  slope2=slope2./86400./365.5./area_of_earth;
%  se2=se2./86400./365.5./area_of_earth;
% 
%  [ym,yme,se,slope]=j_fit(time_hc,hc1,1);
%  slope=slope./86400./365.5./area_of_earth;
%  se=se./86400./365.5./area_of_earth;

 
%save ../../HC/hcseries_ hc tgrid
