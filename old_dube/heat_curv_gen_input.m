function [hc1,time,hc_one]=heat_curv_gen_input(lat,lon,time,ht,one)
lat_in=lat;
lon_in=lon;

load /Volumes/Data/Globalhc/Mtpers/meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat

load /Volumes/Data/Globalhc/HC/landmask msk2
%[lon,lat,time,ht]=load_idl_data_mean_heat('../SAL/Floats/mean_1960_2000.nc');
%load 'htanom_1950_2006_3_error.mat'
%load 'htanom_1993_2006_3_error_jan_2007'
%load 'htanom_2001_2006_3_error_jan_2007'

% load 'htanom_2003_2006_3_error_jan_2007'
 %load 'htanom_2003_2006_3_error_jan_2007_argo'
%load htanom_2003_2006_3_error_josh
 
 % good=find(time < 100000);
 %time=time(good);
 %ht=ht(:,:,good);
% one=one(:,:,good);
% error=error(:,:,good);

% 
% ncload('htanom_diff_realtime_high_vert_jan_2007_3_error_2002_2006.nc','lat','lon','ht','time','one','error')
% 
%ncload('htanom_argo_john_cool_subwarm_2002_2006.nc','lat','lon','ht','time','one','error');
%ncload('htanom_argo_john_warm_subcool_2002_2006.nc','lat','lon','ht','time','one','error')
%ncload('htanom_argo_john_warm_subjosh_2002_2006.nc','lat','lon','ht','time','one','error')
%ncload('htanom_john2_2002_2006.nc','lat','lon','ht','time','one','error')
%ncload('htanom_filter_2002_2006.nc','lat','lon','ht','time','one','error')
%ncload(file_name,'lat','lon','ht','time','one')
% % ncload('htanom_josh_feb_2000_2006.nc','lat','lon','ht','time','one','error')
% % 
% % 
% ht=permute(ht,[3 2 1]);
% % 
% one=permute(one,[3 2 1]);
% % 
% error=permute(error,[3 2 1]);
%$load 'htanom_no_te_q1_2000_2006'
%load 'htanom_q1_take2_1993_2006'

%load htanom_no_te2_2002_2006'
%load 
%error=1-(error-2.2);

%load 'htanom_fliter_2002_2006.mat'
 lon2=lon_in;

 lat2=lat_in;

 
for i=1:length(time)

%%%figure(i);wysiwyg

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask

corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx')./1e9;
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;

corrhc_one=interp2(lat,lon,one(:,:,i),lat_tpx,lon_tpx');
corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one(isnan(sshmean))=NaN;

% corrhc_error=interp2(lat,lon,error(:,:,i),lat_tpx,lon_tpx');
% corrhc_error(isnan(msk2(2:end-1,:)))=NaN;
% corrhc_error(isnan(sshmean))=NaN;

%corrhc_one_total=corrhc_one_total+corrhc_one;


lor=lon_tpx;
lat=lat_tpx;
Area=sum(arw(~isnan(corrhc)));
% compute the area average heatcontent across the globe.

hc(i)=1e9.*nansum(arw(:).*corrhc(:))/sum(arw(~isnan(corrhc)));
hc_one(i)=nansum(arw(:).*corrhc_one(:))/sum(arw(~isnan(corrhc_one)));

time_hc(i)=time(i);

% put into the proper coordinates
% % % min_val=-2
% % % max_val=2
% % % del_val=.2
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
% % % xlabel('heat Content [J 10^9 m^-2]')
% % % 
% % % 
% % % 
% % % %%Plot the ones map
% % % 
% % % % put into the proper coordinates
% % % 
% % % figure(i+100);wysiwyg
% % % 
% % % min_val=0
% % % max_val=1
% % % del_val=.2
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
% % % xlabel('one')
% % % 
% % % 
% % % 
% % % 
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


end
%figure(i+1)

area_of_earth=5.1e14;
hc1=hc*3.4e14;



 hc_one=hc1./hc_one;
% plot(time,(hc)*3.4e14)
% 
%  [ym2,yme2,se2,slope2]=j_fit(time,hc2,1);
%  slope2=slope2./86400./365.5./area_of_earth;
%  se2=se2./86400./365.5./area_of_earth;
% 
%  [ym,yme,se,slope]=j_fit(time,hc1,1);
%  slope=slope./86400./365.5./area_of_earth;
%  se=se./86400./365.5./area_of_earth;
%  
% tgrid=time;
%save ../../HC/hcseries_1950_2006 hc tgrid
