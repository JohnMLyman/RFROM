cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get information on Aviso files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


s=sdir('../../Mtpers/ssh*.mat');
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday

load ../../Mtpers/meanssh lat lon sshcyc gmo
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

sshcyc=[sshcyc(542:end,:,:);sshcyc(1:541,:,:)];

clear lon lat




load ../../HC/landmask msk2


%ncload('htanom_diff_realtime_jan_2007_3_error_2006_2006.nc','lat','lon','time','one','htdiff');
ncload('htanom_josh_march_2002_2006.nc','lat','lon','time','one','ht');
%ncload('htanom_no_te2_2003_2004.nc','lat','lon','time','one','ht');
htdiff=permute(ht,[3 2 1])./1e9;
ind_2003=find(time == 2003.5);

ht_2003_slow=htdiff(:,:,ind_2003);

lat_slow=lat;
lon_slow=lon;
clear lat lon
% compute the fast ie gausian smoothed version of the map
cd ../../HC
[map,lon_fast,lat_fast,time_fast]=fast_map('allheat_josh_march.mat',2003,2004);
%[map,lon_fast,lat_fast,time_fast]=fast_map('allheat_no_te2.mat',2003,2006);
cd ../SAL/Floats
ind_2003=find(time == 2003.5);

ht_2003_fast=map(:,:,ind_2003)./1e9;








% plot the heat content for 2003 slow (ie using an inverse method)
figure(1);wysiwyg


corrhc=interp2(lat_slow,lon_slow,ht_2003_slow,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc(isnan(msk2(2:end-1,:)))=NaN;

ht_slow=corrhc;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-3
max_val=3
del_val=.5

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


t1=text(70,50,'2003 slow','fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
j=axes('pos',[.13 .85 .775 .02]);
%colormap jet(256)

colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('Upper Ocean Heat Content Anomaly [J m^{-2} x 10^9]')



% plot the heat content for 2003 fast (ie gausian smoother)
figure(3);wysiwyg


corrhc=interp2(lat_fast,lon_fast,ht_2003_fast,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc(isnan(msk2(2:end-1,:)))=NaN;

ht_fast=corrhc;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-3
max_val=3
del_val=.5

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


t1=text(70,50,'2003 fast','fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
j=axes('pos',[.13 .85 .775 .02]);
%colormap jet(256)

colormap(cold_to_hot_colormap)

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('Upper Ocean Heat Content Anomaly [J m^{-2} x 10^9]')

















% plot the heat content change of 2006-2005
figure(2);wysiwyg


corrhc=ht_fast-ht_slow;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-3
max_val=3
del_val=.5

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

t1=text(60,50,'2003 fast-slow','fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
j=axes('pos',[.13 .85 .775 .02]);
%colormap jet(256)

colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])

xlabel('Upper Ocean Heat Content Anomaly [J m^{-2} x 10^9]')


%%% print plot

eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/oco/2006/oco_insitu_heat_content_test_josh_2003_slow_march'])
eval(['print -dpng -f3 /home/shoko/C/','''IDL ps''','/heat/oco/2006/oco_insitu_heat_content_test_josh_2003_fast_march'])
eval(['print -dpng -f2 /home/shoko/C/','''IDL ps''','/heat/oco/2006/oco_insitu_heat_contentdiff_test_josh_2003_fastslow_march'])


%close all
%%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg

