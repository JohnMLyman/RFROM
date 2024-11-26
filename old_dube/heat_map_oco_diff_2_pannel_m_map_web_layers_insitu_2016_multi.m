for syear=1992:2014

fyear=syear+1;


if syear==1992 
    syear=fyear
end

cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);
cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get information on Aviso files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /Users/lyman/data/Globalhc/SAL/Floats/
path_ssh='../../Mtpers/realtime_2012/';
s=sdir([path_ssh,'ssh*.mat']);
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday

load ../../Mtpers/meanssh_oco_realtime_2013 lat lon sshcyc gmo
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
%load hdata_oco_realtime_jan_2012_700_real2
load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_oct_2015_QC1950_2015_100_real

htdiff_100=ht;
ind_2008=find(time == fyear+.5);

ht_2008_100=ht(:,:,ind_2008)./1e9;
one_2008_100=one(:,:,ind_2008);

%mask out bad data
%bad=find(one_2008 <= .8);
%ht_2008(bad)=NaN;


%ncload('htanom_diff_realtime_jan_2008_3_error_2005_2005.nc','lat','lon','time','one','htdiff');
%ncload('htanom_q1_no_te_1950_2007_2005_2005.nc','lat','lon','time','one','htdiff');

ind_2007=find(time ==  syear+.5);

ht_2007_100=ht(:,:,ind_2007)./1e9;
one_2007_100=one(:,:,ind_2007);

% mask out bad data
%bad=find(one_2007 <= .8);
%ht_2007(bad)=NaN;
load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_oct_2015_QC1950_2015_100_300_real
htdiff_100_300=ht;
one_2008_100_300=one(:,:,ind_2008);
ht_2008_100_300=ht(:,:,ind_2008)./1e9;
ht_2007_100_300=ht(:,:,ind_2007)./1e9;
one_2007_100_300=one(:,:,ind_2007);


load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_oct_2015_QC1950_2015_300_700_real
htdiff_300_700=ht;
one_2008_300_700=one(:,:,ind_2008);
ht_2008_300_700=ht(:,:,ind_2008)./1e9;
ht_2007_300_700=ht(:,:,ind_2007)./1e9;
one_2007_300_700=one(:,:,ind_2007);

ind_all=find(time>1993 & time <2013);
ht_all=(htdiff_100(:,:,ind_all)+htdiff_100_300(:,:,ind_all)+htdiff_300_700(:,:,ind_all))./1e9;
tgrid=[1993.5:1:2014.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load in the in the Aviso estimate %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_100_2.mat')
load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_100_300_2.mat')
load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_300_700_2.mat')

%load ../../HC/hregress_reatime alpha alat alon
alpha_100=interp2(alat,alon,alpha_100,lat_tpx,lon_tpx');
alpha_100_300=interp2(alat,alon,alpha_100_300,lat_tpx,lon_tpx');
alpha_300_700=interp2(alat,alon,alpha_300_700,lat_tpx,lon_tpx');clear alon alat

ssh_total=ones(length(lon_tpx),length(lat_tpx),53)*NaN;
ssh_total_mean=ones(length(lon_tpx),length(lat_tpx),2)*NaN;


% for i=1:length(tgrid) 
%     i
%     sshave=zeros(length(lon_tpx),length(lat_tpx));
%     
%     ii=find(abs(tgrid(i)-syr)<=.5);
%   for j=1:length(ii)
%     load([path_ssh,s(ii(j)).name],'sshanom')
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
%   if tgrid(i) == 2011.5 
%       tpxest_2007_100=sshave.*alpha_100./1e9;
%       tpxest_2007_100_300=sshave.*alpha_100_300./1e9;
%       tpxest_2007_300_700=sshave.*alpha_300_700./1e9;
%       tpxest_2007=tpxest_2007_100+tpxest_2007_100_300+tpxest_2007_300_700;
%  
%   end % if 2007
%   
%   if tgrid(i) == 2012.5
%       tpxest_2008_100=sshave.*alpha_100./1e9;
%       tpxest_2008_100_300=sshave.*alpha_100_300./1e9;
%       tpxest_2008_300_700=sshave.*alpha_300_700./1e9;
%       tpxest_2008=tpxest_2008_100+tpxest_2008_100_300+tpxest_2008_300_700;
%   end % if 2008
%   
%   end % for years  

ht_2008=ht_2008_100+ht_2008_100_300+ht_2008_300_700;
ht_2007=ht_2007_100+ht_2007_100_300+ht_2007_300_700;
  

ht_change=(ht_2008-ht_2007);

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
figure(1);wysiwyg;orient tall
set(gcf,'color','white');
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
subplot(2,1,1)

lon=lon2;
lat=lat2;

corrhc=interp2(lat,lon,ht_all_mean,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc=corrhc;
corrhc(isnan(msk2(2:end-1,:)))=NaN;
ht_1993_2010_mean=corrhc;

corrhc=interp2(lat,lon,ht_2008,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc=corrhc;
corrhc(isnan(msk2(2:end-1,:)))=NaN;

corrhc=corrhc-ht_1993_2010_mean;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-3
max_val=3
del_val=.5
del_cont=.25
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(cold_to_hot_colormap) 


m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
%colormap(fresh_to_salty_colormap) 
[cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none');


%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
a=gca;
hold on
m_coast('patch',[1 1 1]);
t1=m_text(60,54,['a) ', num2str(fyear)],'fontsize',11,'fontweight','bold');

caxis([min_val max_val-del_cont])

hold off

ja=axes('pos',[.262 .90-.0475 .51 .01]);
%colormap jet(256)

colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
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
del_cont=10
ii=find(lon<30);
jj=find(lon>=30); 
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(cold_to_hot_colormap)

[cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'xticklabel',[],'ytick',[-90:30:90],'linestyle','none');


%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
b=gca;
hold on
m_coast('patch',[1 1 1]);
t1=m_text(55,54,['b) ' num2str(fyear) '-' num2str(syear)],'fontsize',11,'fontweight','bold');

caxis([min_val max_val-del_cont])

jb=axes('pos',[.262 .10+.06 .51 .01]);
colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(jb,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
xlabel('1-year Heat Content Change [W m ^{-2}]')


%%%%sort the polots

apos=get(a,'pos')

bpos=get(b,'pos')
set(b,'pos',bpos+[0 .03+.035 0 0],'xticklabel',[])
set(a,'pos',apos+[0 -.05-.03 0 0])

set(jb,'XAxisLocation','bottom')

%%% print plot
wysiwyg;orient tall
eval(['print -dpng -f1 /Users/lyman/figs/oco/Oceans/oco_heat_2016_web_2014_2013_insitu_',num2str(fyear)])
%eval(['print -dpdf -f1 /Users/johnlyman/figs/oco/Oceans/oco_heat_j2015_web_2014_2013_insitu_new'])
%eval(['print -dpng -f1 /Users/johnlyman/figs/oco/Oceans/oco_heat_content_diff_2010_realtime_2010_2p_700'])
%eval(['print -depsc2 -r600 -f1 /Users/johnlyman/figs/oco/Oceans/oco_heat_content_diff_2010_realtime_2010_2p_700'])
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
close all


end