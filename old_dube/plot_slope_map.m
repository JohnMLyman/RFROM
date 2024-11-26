function [junk]=plot_slope_map(lat,lon,slope,error,fig_number,title_in)
path='/Volumes/Data/Globalhc/SAL/Floats/'
cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);
junk=1;
lat_in=lat;
lon_in=lon;
original=cd(path);

load ../../Mtpers/meanssh_oco_realtime lat lon sshcyc gmo
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
load ../../HC/landmask msk2

% load the data

%load slope_heat_2007
lat=lat_in;
lon=lon_in;
slope=slope./1e9;
error=error./1e9;

corrhc=interp2(lat,lon,slope,lat_tpx,lon_tpx');
%corrhc(isnan(corrhc))=0;
corrhc(isnan(msk2(2:end-1,:)))=NaN;

slope=corrhc;

corrhc=interp2(lat,lon,error,lat_tpx,lon_tpx');
%corrhc(isnan(corrhc))=0;
corrhc(isnan(msk2(2:end-1,:)))=NaN;

error=corrhc;
lon=lon_tpx;
lat=lat_tpx;
% put into the proper coordinates

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
slope=[slope(jj,:);slope(ii,:)];
error=[error(jj,:);error(ii,:)];

% get rid of some junk in error

ii=find(isfinite(slope)==0);
%error(ii)=NaN;

% make a ratio of slope to error in slope

r=(slope)./error;
r2=abs(slope)-abs(error);

slope=slope.*1e9/24/365.25/3600;
too_low=find(slope <= -8);
slope(too_low)=-8.;
% make the figures

figure(fig_number);  wysiwyg
% put into the proper coordinates
min_val=-6
max_val=6
del_val=1.
subplot(2,1,1)
colormap(cold_to_hot_colormap) 



pcolor(lon,lat,slope')
offset=-1.*(25/255)

%caxis([(-8+offset) 8])
caxis([min_val max_val])
shading flat
plot_coasts_black

axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
a=gca;
%set(a,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
set(a,'xtick',[30:30:390],'tickdir','out','XtickLabel', {'30E' '60E' '90E' '120E' '150E' '180' '150W' '120W' '90W' '60W' '30W' '0' '30E'},'ytick',[-90:30:90],...
    'YtickLabel',{'90S' '60S' '30S' '0' '30N' '60N' '90N'},'fontsize',9)

hold on
[cs,h]=contour(lon,lat,r2',[0 0],'k');

%ja=axes('pos',[.13 .85 .775 .02]);

ja=axes('pos',[.262 .90 .51 .01]);
colormap jet(256)

min_colorbar=-8-offset

%[cs,h]=contourf([-8:.01:8],[0 1],[1 1]'*[(-8-(offset)):.01:(8-(offset))],[-8:(8+8)/254:8]);
[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);

set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
%caxis([-12 12])
xlabel([title_in,' [W m^{-2}]'])

%%

subplot(2,1,2)
colormap(cold_to_hot_colormap) 
%colormap(jet)
%% rescale r
r3=r;
r3(r3>3)=3;
r3(r3<-3)=-3;
r3((r3>=-1) & (r3<=1))=0;
r3((r3<-1))=(r3(r3<-1)+1)*(3/2);
r3((r3>1))=(r3(r3>1)-1)*(3/2);
%%

pcolor(lon,lat,r3')
shading flat

plot_coasts_black

caxis([-3 3])
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
b=gca;
%set(b,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
set(b,'xtick',[30:30:390],'tickdir','out','XtickLabel', {'30E' '60E' '90E' '120E' '150E' '180' '150W' '120W' '90W' '60W' '30W' '0' '30E'},'ytick',[-90:30:90],...
    'YtickLabel',{'90S' '60S' '30S' '0' '30N' '60N' '90N'},'fontsize',9)

hold on
% fool with the colormap

c=colormap;
%c(1,:)=2/3;
colormap(c)

jb=axes('pos',[.262 .10 .51 .01]);
colormap(c)

[cs,h]=contourf([[-3:.01:-1],[1:.01:3]],[0 1],[1 1]'*[[-2:.01:0], [0:.01:2]],[-2:(2+2)/256:2]);

%[cs,h]=contourf([1:.01:3],[0 1],[1 1]'*[0:.01:2],[0:(2+2)/255:2]);
set(h,'edgecolor','none')
set(jb,'tickdir','out','xaxisl','bot','xtick',[-3:.5:3],'ytick',[])
caxis([-2 2])
xlabel('Ratio of Heat  Content Trend to 95% Uncertainty')

% now shift the plots around on the page
%%
%%%sort the polots

apos=get(a,'pos')

bpos=get(b,'pos')
set(b,'pos',bpos+[0 .03 0 0],'xticklabel',[])
set(a,'pos',apos+[0 -.05 0 0])
set(jb,'XAxisLocation','bottom')

% down=.1
% 
% q=get(gcf,'children');
% a2=get(q(1),'pos');
% a4=get(q(2),'pos');
% a3=get(q(3),'pos');
% a5=get(q(4),'pos');
% 
% aa=(1-a2(4)*2)/2;
% a2(2)=aa;
% a4(2)=aa+a2(4);
% set(q(2),'pos',a4-[0 (down+.25) 0 0]);
% set(q(1),'pos',a2-[0 (down+.3) 0 0]);
% 
% set(q(3),'pos',a3-[0 (down-.1) 0 0]);
% set(q(4),'pos',a5-[0 (down) 0 0]);

%eval(['print -depsc -f1 /home/shoko/C/','''IDL ps''','/heat/agu/hc_change_2005_agu'])
%eval(['print -dpng -f1 /home/shoko2/wills/globalhc_dirs/Globalhc/figs/hc_14_year_change'])
% eval(['print -dpng -f1 /Users/johnlyman/figs/oco/Oceans/hc_16_year_change_2009_tpx'])
% eval(['print -dtiff -r600 -f1 /Users/johnlyman/figs/oco//Oceans/hc_16_year_change_2009_tpx'])


cd,original
