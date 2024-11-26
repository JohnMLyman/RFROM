
'kat'

% cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
% cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);
% cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get information on Aviso files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /Users/johnlyman/data/Globalhc/SAL/Floats/
path_ssh='../../Mtpers/realtime_2013/';
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

load /Volumes/Data/Globalhc/Mtpers/meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;


load ../../HC/landmask msk2
 
file_name='100';

load(['/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_',file_name,'_2.mat'])
%%%figure(i);wysiwyg

lon=alon;
lat=alat;
%corr=c_1800;
eval(['corr=c_',file_name,';'])


%corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx');
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
%corrhc(isnan(sshmean))=NaN;


% plot the heat content for 2008
figure(1);wysiwyg;orient tall
set(gcf,'color','white');
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
subplot(2,1,1)


corrhc=interp2(lat,lon,corr,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=NaN;
corrhc(isnan(sshmean))=NaN;

corrhc(isnan(msk2(2:end-1,:)))=NaN;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-1
max_val=1
del_val=.2
del_cont=.1
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

%colormap(cold_to_hot_colormap) 
colormap jet(256)



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
%t1=m_text(60,54,'a) 2012','fontsize',11,'fontweight','bold');

caxis([min_val max_val-del_cont])

hold off

ja=axes('pos',[.262 .90-.0475 .51 .01]);
colormap jet(256)

%colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
xlabel('Correlation Coefficient')






apos=get(a,'pos')


%set(b,'pos',bpos+[0 .03+.035 0 0],'xticklabel',[])
set(a,'pos',apos+[0 -.05-.03 0 0])

%set(jb,'XAxisLocation','bottom')

%%% print plot
wysiwyg;orient tall
eval(['print -dpng -f1 /Users/johnlyman/figs/greg/r_0_100'])
eval(['print -dpdf -f1 /Users/johnlyman/figs/greg/r_0_100'])

%eval(['print -dtiff -r300 -f1 /Users/johnlyman/figs/oco/Oceans/oco_heat_2013_web_2012_2011_newtest3_new2'])


