function []=heat_map_oco_2011_diff_2_pannel_gen_insitu(year_start,year_end)

start_year=year_start+.5
end_year=year_end+.5


cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get information on Aviso files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /Users/johnlyman/data/Globalhc/SAL/Floats/

s=sdir('../../Mtpers/realtime/ssh*.mat');
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday

load ../../Mtpers/meanssh_oco_realtime lat lon sshcyc gmo
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

sshcyc=[sshcyc(542:end,:,:);sshcyc(1:541,:,:)];

clear lon lat




load ../../HC/landmask msk2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Load in situ - aviso estimate       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ncload('htanom_diff_realtime_jan_2007_3_error_2005_2007.nc','lat','lon','time','one','htdiff');
% htdiff=permute(htdiff,[3 2 1])./1e9;
% one=permute(one,[3 2 1]);
% 
% ind_2007=find(time == 2007.5);
% ind_2005=find(time == 2005.5);
% 
% ht_2007=htdiff(:,:,ind_2007);
% ht_2005=htdiff(:,:,ind_2005);


%ncload('htanom_diff_realtime_jan_2007_3_error_2007_2007.nc','lat','lon','time','one','htdiff');
%ncload('htanom_q1_no_te_1950_2007_2007_2007.nc','lat','lon','time','one','htdiff');
%load htanom_1993_2007_oco_greg_josh
%load htanom_2007_2007_oco_greg_josh
%load htanom_oco_realtime_2010_2008_2010
%load htanom_oco_realtime_1993_2010
load hdata_oco_realtime_jan_2011_700_real
ind_2008=find(time == start_year);

ht_2008=htdiff(:,:,ind_2008)./1e9;
one_2008=one(:,:,ind_2008);

%mask out bad data
bad=find(one_2008 <= .8);
%ht_2008(bad)=NaN;


%ncload('htanom_diff_realtime_jan_2008_3_error_2005_2005.nc','lat','lon','time','one','htdiff');
%ncload('htanom_q1_no_te_1950_2007_2005_2005.nc','lat','lon','time','one','htdiff');

ind_2007=find(time == end_year);

ht_2007=ht(:,:,ind_2007)./1e9;
one_2007=one(:,:,ind_2007);

% mask out bad data
bad=find(one_2007 <= .8);
%ht_2007(bad)=NaN;

ind_all=find(time>1993 & time <2012);
ht_all=ht(:,:,ind_all)./1e9;
tgrid=[1993.5:1:2011.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load in the in the Aviso estimate %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ../../HC/hregress_reatime alpha alat alon
alpha=interp2(alat,alon,alpha,lat_tpx,lon_tpx');clear alon alat
% 
% ssh_total=ones(length(lon_tpx),length(lat_tpx),53)*NaN;
% ssh_total_mean=ones(length(lon_tpx),length(lat_tpx),2)*NaN;
% 
% 
% for i=1:length(tgrid) 
%     i
%     sshave=zeros(length(lon_tpx),length(lat_tpx));
%     
%     ii=find(abs(tgrid(i)-syr)<=.5);
%   for j=1:length(ii)
%     load(['../../Mtpers/realtime_2011/',s(ii(j)).name],'sshanom')
%     mo=str2num(s(ii(j)).name(end-8:end-4));
%     mo=mo+datenum(1950,1,1)-datenum(1992,1,1);
%     mo=mod(mo/365.25*12,12);
%     sshc=squeeze(0*sshcyc(:,:,1));
%     for k=1:length(gmo)
% 	jj=zeros(1,length(gmo));jj(k)=1;
% 	w(k)=interp1(gmo,jj,mo,'*cubic');
% 	sshc=sshc+sshcyc(:,:,k)*w(k);
%     end %for 
%     sshanom=[sshanom(542:end,:);sshanom(1:541,:)];
%     sshanom=sshanom-sshc;
%    % ssh_total(:,:,j)=sshanom;
%     sshave=sshave+sshanom/length(ii);
%     
%     
%   end  %for months
% 
% 
%   % make aviso estimate
%   sshave(isnan(sshave))=0;sshave(isnan(msk2(2:end-1,:)))=NaN;
%   ssh_total_mean(:,:,i)=sshave;
%   
%   
%   if tgrid(i) == end_year 
%       tpxest_2007=sshave.*alpha./1e9;
%   end % if 2007
%   
%   if tgrid(i) == start_year
%       tpxest_2008=sshave.*alpha./1e9;
%   end % if 2008
%   
%   end % for years  
% 
% tpxest_change=(tpxest_2008-tpxest_2007);
ht_change=(ht_2008-ht_2007);

% tpxest_all=nanmean(ssh_total_mean,3).*alpha./1e9;
ht_all_mean=nanmean(ht_all,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s
%%%                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


lon2=lon;
 lat2=lat;


%i=3


%corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx');
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
%corrhc(isnan(sshmean))=NaN;


% plot the heat content for 2008
figure(1);wysiwyg
subplot(2,1,1)

lon=lon2;
lat=lat2;



corrhc=interp2(lat,lon,ht_2008,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc=corrhc;
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


t1=text(60,54,['a) ',num2str(start_year-.5)],'fontsize',11,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
a=gca;
%set(a,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
set(a,'xtick',[30:30:390],'tickdir','out','XtickLabel', {'30E' '60E' '90E' '120E' '150E' '180' '150W' '120W' '90W' '60W' '30W' '0' '30E'},'ytick',[-90:30:90],...
    'YtickLabel',{'90S' '60S' '30S' '0' '30N' '60N' '90N'},'fontsize',9)



hold on


ja=axes('pos',[.262 .90 .51 .01]);
%colormap jet(256)

colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('Upper Ocean Heat Content Anomaly [J m ^{-2} x 10^9]')






% % % % plot the heat content for 2007
% % % figure(3);wysiwyg
% % % lon=lon2;
% % % lat=lat2;
% % % 
% % % 
% % % corrhc=interp2(lat,lon,ht_2007,lat_tpx,lon_tpx');
% % % corrhc(isnan(corrhc))=0;
% % % corrhc=corrhc+tpxest_2007;
% % % corrhc(isnan(msk2(2:end-1,:)))=NaN;
% % % 
% % % lon=lon_tpx;
% % % lat=lat_tpx;
% % % 
% % % 
% % % % put into the proper coordinates
% % % min_val=-3
% % % max_val=3
% % % del_val=.5
% % % 
% % % ii=find(lon<30);
% % % jj=find(lon>=30);
% % % lon=[lon(jj);lon(ii)+360];
% % % corrhc=[corrhc(jj,:);corrhc(ii,:)];
% % % %colormap jet(256)
% % % 
% % % colormap(cold_to_hot_colormap) 
% % % 
% % % pcolor(lon,lat,corrhc')
% % % caxis([min_val max_val])
% % % shading flat
% % % 
% % % plot_coasts_black
% % % 
% % % 
% % % t1=text(70,50,'2007','fontsize',16,'fontweight','bold');
% % % axis([30 390 -90 90])
% % % axis equal
% % % axis([30 390 -90 90])
% % % set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
% % % hold on
% % % j=axes('pos',[.13 .85 .775 .02]);
% % % %colormap jet(256)
% % % 
% % % colormap(cold_to_hot_colormap) 
% % % 
% % % [cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
% % % set(h,'edgecolor','none')
% % % set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
% % % caxis([min_val max_val])
% % % xlabel('Upper Ocean Heat Content Anomaly [J m ^{-2} x 10^9]')

% plot the heat content change of 2008-2007
subplot(2,1,2)
lon=lon2;
lat=lat2;


corrhc=interp2(lat,lon,ht_change,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;

corrhc=(corrhc).*1e9./((60*60*24*365.5));
corrhc(isnan(msk2(2:end-1,:)))=NaN;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-95
max_val=95
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

t1=text(55,54,['b) ',num2str(start_year-.5),'-',num2str(end_year-.5)],'fontsize',11,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
b=gca;
%set(b,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
set(b,'xtick',[30:30:390],'tickdir','out','XtickLabel', {'30E' '60E' '90E' '120E' '150E' '180' '150W' '120W' '90W' '60W' '30W' '0' '30E'},'ytick',[-90:30:90],...
    'YtickLabel',{'90S' '60S' '30S' '0' '30N' '60N' '90N'},'fontsize',9)

hold on


jb=axes('pos',[.262 .1 .51 .01]);
colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(jb,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('1-year Heat Content Change [W m ^{-2}]')


%%%%sort the polots

apos=get(a,'pos')

bpos=get(b,'pos')
set(b,'pos',bpos+[0 .03 0 0],'xticklabel',[])
set(a,'pos',apos+[0 -.05 0 0])
set(jb,'XAxisLocation','bottom')

%%% print plot

eval(['print -dpng -f1 /Users/johnlyman/figs/oco/Oceans/oco_insitu_heat_content_diff_2011_realtime_2010_2p_',num2str(start_year-.5)])
%eval(['print -dtiff -r600 -f1 /Users/johnlyman/figs/oco/Oceans/oco_heat_content_diff_2010_realtime_2010_2p_early'])

% eval(['print -djpeg90 -f1 /Users/johnlyman/figs/oco/Oceans/oco_heat_content_diff_2008_jan_realtime_2008_web_2p'])
% %eval(['print -djpeg90 -f2 /Users/johnlyman/figs/oco/Oceans/oco_heat_change_diff_2008_jan_realtime_2008_2007_web'])
% 
% eval(['print -dpdf -f1 /Users/johnlyman/figs/oco/Oceans/oco_heat_content_diff_2008_jan_realtime_2008_web_2p'])
% %eval(['print -dpdf -f2 /Users/johnlyman/figs/oco/Oceans/oco_heat_change_diff_2008_jan_realtime_2008_2007_web'])
% 
% eval(['print -dtiff -r600 -f1 /Users/johnlyman/figs/oco/Oceans/oco_heat_content_diff_2008_jan_realtime_2008_2_pannel_test_web'])
% eval(['print -dtiff -f3 /Users/johnlyman/figs/oco/Oceans/oco_heat_content_diff_2008_jan_realtime_2007'])
% 
% eval(['print -dtiff -f2 /Users/johnlyman/figs/oco/Oceans/oco_heat_change_diff_2008_jan_realtime_2008_2007'])

%close all
%%%print -djpeg90 -f1 /moala2/josh/Globalhc/paper/f1.jpg

