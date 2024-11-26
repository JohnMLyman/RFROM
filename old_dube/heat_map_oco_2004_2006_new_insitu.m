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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    Load in situ - aviso estimate       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ncload('htanom_diff_realtime_jan_2007_3_error_2005_2006.nc','lat','lon','time','one','htdiff');
% htdiff=permute(htdiff,[3 2 1])./1e9;
% one=permute(one,[3 2 1]);
% 
% ind_2006=find(time == 2006.5);
% ind_2005=find(time == 2005.5);
% 
% ht_2006=htdiff(:,:,ind_2006);
% ht_2005=htdiff(:,:,ind_2005);


%ncload('htanom_diff_realtime_jan_2007_3_error_2006_2006.nc','lat','lon','time','one','htdiff');
%ncload('htanom_josh_march_2002_2006.nc','lat','lon','time','one','ht');
ncload('htanom_no_te2_2006_2006.nc','lat','lon','time','one','ht');
htdiff=permute(ht,[3 2 1])./1e9;
one=permute(one,[3 2 1]);
ind_2006=find(time == 2006.5);

ht_2006=htdiff(:,:,ind_2006);
one_2006=one(:,:,ind_2006);

%mask out bad data
%bad=find(one_2006 <= .8);
%ht_2006(bad)=NaN;


%ncload('htanom_diff_realtime_jan_2007_3_error_2005_2005.nc','lat','lon','time','one','htdiff');
%ncload('htanom_q1_no_te_1950_2006_2000_2004.nc','lat','lon','time','one','ht');
ncload('htanom_no_te2_2005_2005.nc','lat','lon','time','one','ht');
htdiff=permute(ht,[3 2 1])./1e9;
one=permute(one,[3 2 1]);

ind_2005=find(time == 2005.5);

ht_2005=htdiff(:,:,ind_2005);
one_2005=one(:,:,ind_2005);

% mask out bad data
bad=find(one_2005 <= .8);
%ht_2005(bad)=NaN;


tgrid=[2005.5,2006.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load in the in the Aviso estimate %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ht_change=(ht_2006-ht_2005);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s
%%                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


lon2=lon;
 lat2=lat;


%i=3


%corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx');
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
%corrhc(isnan(sshmean))=NaN;


% plot the heat content for 2006
figure(1);wysiwyg
lon=lon2;
lat=lat2;


corrhc=interp2(lat,lon,ht_2006,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc(isnan(msk2(2:end-1,:)))=NaN;

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


t1=text(70,50,'2006','fontsize',16,'fontweight','bold');
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
lon=lon2;
lat=lat2;


corrhc=interp2(lat,lon,ht_change,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;

corrhc=(corrhc).*1e9./((2*60*60*24*365.5));
corrhc(isnan(msk2(2:end-1,:)))=NaN;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-80
max_val=80
del_val=10

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

t1=text(60,50,'2006-2005','fontsize',16,'fontweight','bold');
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
xlabel('1-year Heat Content Change (in situ)  [W m^{-2}]')




%%% print plot

eval(['print -dpng -f1 /home/shoko/C/','''IDL ps''','/heat/oco/2006/oco_insitu_heat_content_john_2006'])
eval(['print -dpng -f2 /home/shoko/C/','''IDL ps''','/heat/oco/2006/oco_insitu_heat_change_john_2006_2004'])


%close all
%%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg

