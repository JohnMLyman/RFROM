cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);

cd /Users/johnlyman/data/Globalhc/SAL/Floats/

load ../../HC/landmask msk2

load ../../Mtpers/meanssh lat lon sshcyc gmo
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

load annual_and_semi_2004_2007_1deg  amp_annual phase_annual lon lat

%plot amplitude
figure(11);wysiwyg

junk=abs(amp_annual);

corrhc=interp2(lat,lon,junk,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=NaN;
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc=corrhc/1e9;
lon_annual=lon;
lat_annual=lat;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates


min_val=0
max_val=2
del_val=.25

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
colormap jet(256)

%colormap(cold_to_hot_colormap) ;
pcolor(lon,lat,corrhc')
caxis([min_val max_val])
shading flat

plot_coasts_black


t1=text(70,50,'AMP','fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
j=axes('pos',[.13 .85 .775 .02]);


%colormap(cold_to_hot_colormap) 
colormap(jet(256));
[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val])
xlabel('Annual Cycle Amplitude of Upper Ocean Heat Content Anomaly [J m^{-2} x 10^9]')



%%%%%%%%%%%%%%%plot phase
figure(12);wysiwyg

neg=find(amp_annual < 0);
p2=phase_annual;
p2(neg)=p2(neg)+pi;
hi=find(p2>pi);
p2(hi)=p2(hi)-2*pi;


junk=p2;

corrhc=interp2(lat_annual,lon_annual,junk,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=NaN;
corrhc(isnan(msk2(2:end-1,:)))=NaN;

lon_annual=lon;
lat_annual=lat;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-pi
max_val=pi
del_val=pi/2.;

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(hsv(16)) ;
pcolor(lon,lat,corrhc')
caxis([min_val max_val])
shading flat

plot_coasts_black


t1=text(65,50,'phase','fontsize',16,'fontweight','bold');
axis([30 390 -90 90])
axis equal
axis([30 390 -90 90])
set(gca,'xtick',[30:30:390],'tickdir','out','xticklabel', [30:30:180,-150:30:30],'ytick',[-90:30:90])
hold on
j=axes('pos',[.13 .85 .775 .02]);


colormap(hsv(16)) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:(max_val-min_val)/254:max_val]);
set(h,'edgecolor','none')
set(j,'tickdir','out','xaxisl','top','xtick',[-pi,-pi/2,0,pi/2,pi-.001],'ytick',[],...
    'XTickLabel',{'-Pi';'-Pi/2';'0';'Pi/2';'Pi'},'XLimMode','manual','Xlim',[-pi,pi])
caxis([min_val max_val])
xlabel('Annual Cycle Phase of Upper Ocean Heat Content Anomaly [rads]')





