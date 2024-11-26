function [hc,time,hc_one,one_curve,Area]=heat_curv_gen_mat_2012_new_un_topo_season(file_name_in,depth_min,depth_max)
% load /Volumes/ThunderBay/Data/Globalhc/Mtpers/meanssh lat lon sshmean
% % to get rid of ice
 file_name=[file_name_in,num2str(depth_min),'_',num2str(depth_max),'_real_new_layers'];
% sshmean=[sshmean(542:end,:);sshmean(1:541,:)];
% 
% lon_tpx=[lon(542:end)-360;lon(1:541)];
% lat_tpx=lat;
% arw=areavec(lon_tpx,lat_tpx);
% clear lon lat

% grid topo grids depth on topex grid
% grid_topo

load /Volumes/ThunderBay/Data/Globalhc/topo/topo_tpx

% linear interpilate to topex grid and apply mland mask

topo_tpx=-1.*topo;

shallow=find(topo_tpx < depth_min);
mid=find(topo_tpx>=depth_min & topo_tpx<depth_max);


clear lon_topo lat_topo topo
% load /Volumes/ThunderBay/Data/Globalhc/HC/landmask msk2

eval(['load ' file_name]);
arw=areavec(lon_tpx,lat_tpx);
 lon2=lon;

 lat2=lat;

 
for i=1:length(time)
arw_j=arw;
%%%figure(i);wysiwyg

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask

corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx')./1e9;
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
%corrhc(isnan(sshmean))=NaN;

corrhc(shallow)=NaN;

arw_j(mid)=arw_j(mid).*(topo_tpx(mid)-depth_min)./(depth_max-depth_min);
arw_j(shallow)=NaN;
%corrhc(mid)=corrhc(mid).*(topo_tpx(mid)-depth_min)./(depth_max-depth_min);

corrhc_one=interp2(lat,lon,one(:,:,i),lat_tpx,lon_tpx');
%corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
%corrhc_one(isnan(sshmean))=NaN;
corrhc_one(shallow)=NaN;
%corrhc_one(mid)=corrhc_one(mid).*(topo_tpx(mid)-depth_min)./(depth_max-depth_min);

% corrhc_error=interp2(lat,lon,error(:,:,i),lat_tpx,lon_tpx');
% corrhc_error(isnan(msk2(2:end-1,:)))=NaN;
% corrhc_error(isnan(sshmean))=NaN;

%corrhc_one_total=corrhc_one_total+corrhc_one;


lor=lon_tpx;
lat=lat_tpx;
Area(i)=sum(arw_j(~isnan(arw_j)));
% compute the area average heatcontent across the globe.

one_curve(i)=nansum(arw_j(:).*corrhc_one(:));
hc(i)=1e9.*nansum(arw_j(:).*corrhc(:));
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

%area_of_earth=5.1e14;

%one_curve=one_curve./3.4e14;
one_curve=one_curve./Area;



%offset=nanmean(hc(1:10));
offset=0;
hc=hc-offset;

 hc_one=hc./one_curve;
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
