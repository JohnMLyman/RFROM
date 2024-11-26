 




cd '/Volumes/Data/Globalhc/SAL/Floats/'
fresh_to_salty_colormap=[[1,146,191]'/255,[255,255,255]'/255,[255,158,15]'/255]';
fresh_to_salty_colormap=interp1([0:1/2:1],fresh_to_salty_colormap,[0:1/255:1]);
fresh_to_salty_colormap=diverging_map([0:1/100:1],[20 43 140]/255,[204 85 0]/255); 

cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);

load /Volumes/Data/Globalhc/Mtpers/meanssh lat lon
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

clear lon lat

load /Volumes/Data/Globalhc/HC/landmask msk2
%[lon,lat,time,fresh]=load_idl_data_fresh('fresh_aviso_2003_2005.nc');

%ncload('surface_sal_anom_3_error_2004_2005.nc','lat','lon','sal','time','one');
%load 'surface_sal_jan_2011_2002_2011_6_deg.mat' lat lon time one sal;


%load('/Volumes/Data/Aquaris/Aq_2014/aquarius_apr_oct_not_rev_good.mat')
%load('/Volumes/Data/Aquaris/Aq_2014/aquarius_monthly_sss_2013.mat')
%load('/Volumes/Data/Aquaris/Aq_2014/aquarius_monthly_sss_2013_n.mat')
load('/Volumes/Data/Aquaris/Aq_2014/aquarius_monthly_sss_v281.mat')

%load('/Volumes/Data/Aquaris/Aq_2014/aqv271_apr_oct_2013_smooth.mat')
%shift to -180 to 180 lon
pos_small=find(lon<=180);
pos_big=find(lon>180);
lon(lon>180)=lon(lon>180)-360;
lon=[lon(pos_big),lon(pos_small)];

 apr_sss=squeeze(sss(4+12-1:4+12+1,:,[pos_big,pos_small]));
 oct_sss=squeeze(sss(10+12-1:10+12+1,:,[pos_big,pos_small]));
surface_sal_diff_oct_apr=squeeze(nanmean(oct_sss-apr_sss));
% apr_sss=squeeze(apr_sss(:,[pos_big,pos_small]));
% oct_sss=squeeze(oct_sss(:,[pos_big,pos_small]));
%surface_sal_diff_oct_apr=squeeze(surface_sal_diff_oct_apr(:,[pos_big,pos_small]));

surface_sal_diff_oct_apr=surface_sal_diff_oct_apr';
%ssal=apr_sss';
sname2='Apr';
smonth=4;



%fsal=oct_sss';
fname2='Oct';
year_name='2013';
fmonth=10;





lon=[lon(end-3:end)-360,lon,lon(1:4)+360];
surface_sal_diff_oct_apr=[surface_sal_diff_oct_apr(end-3:end,:);surface_sal_diff_oct_apr;surface_sal_diff_oct_apr(1:4,:)];
%fsal=[fsal(end-3:end,:);fsal;fsal(1:4,:)];

%surface_sal_apr=ssal;

%surface_sal_oct=fsal;



lon_mon=lon;
lat_mon=lat;


%load('/Volumes/Data/Aquaris/Aq_2014/aquarius_sss_2012.mat')
%load('/Volumes/Data/Aquaris/Aq_2014/aquarius_monthly_sss_2013_n.mat')
load('/Volumes/Data/Aquaris/Aq_2014/aquarius_monthly_sss_v281.mat')

sss_2012=(sss(1:12,:,:));
sss_2013=(sss(13:24,:,:));
sss=squeeze(nanmean(sss_2013-sss_2012));
%shift to -180 to 180 lon
pos_small=find(lon<=180);
pos_big=find(lon>180);
lon(lon>180)=lon(lon>180)-360;
lon=[lon(pos_big),lon(pos_small)];

sss=sss(:,[pos_big,pos_small]);

sss_2013_2012=sss';

year_name_2012='2012';
%load('/Volumes/Data/Aquaris/Aq_2014/aquarius_sss_2013.mat')
% load('/Volumes/Data/Aquaris/Aq_2014/aquarius_monthly_sss_2013_n.mat')
% sss=squeeze(nanmean(sss(13:24,:,:)));
% %shift to -180 to 180 lon
% pos_small=find(lon<=180);
% pos_big=find(lon>180);
% lon(lon>180)=lon(lon>180)-360;
% lon=[lon(pos_big),lon(pos_small)];
% 
% sss=sss(:,[pos_big,pos_small]);


% sss_2013=sss';
year_name_2013='2013';

% [lon,lat,ssal]=read_sss(sname);
% [lon,lat,fsal]=read_sss(fname);

lon=[lon(end-3:end)-360,lon,lon(1:4)+360];
sss_2013_2012=[sss_2013_2012(end-3:end,:);sss_2013_2012;sss_2013_2012(1:4,:)];


lon_year=lon;
lat_year=lat;


% Mask loaction with less than a 80% coverage



% this section is because a grided lon=180 and not lon=-180, this sets data
% at -180 to the same values as 180...
%surface_sal(end+1,:,1)=surface_sal(1,:,1);
%lon(end+1)=-180.0;
lat=lat_mon;
lon=lon_mon;

 lon2=lon;
 lat2=lat;


%i=3
load /Volumes/Data/WOA09/salinity_annual_1deg_cont.mat sal_cont lat_cont lon_cont

%corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx');
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
%corrhc(isnan(sshmean))=NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the heat content for 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);wysiwyg;orient tall
set(gcf,'color','white');
lon=lon2;
lat=lat2;


subplot(2,1,1)
colormap(fresh_to_salty_colormap)
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);

lon=lon2;
lat=lat2;


corrhc=interp2(lat,lon,(surface_sal_diff_oct_apr)/((fmonth-smonth)./12),lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;
land_mask=msk2(2:end-1,:);

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-2
max_val=2
del_val=1
del_cont=.05
miss_val= (min_val-max_val)./100;

ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
land_mask=[land_mask(jj,:);land_mask(ii,:)];

%colormap jet(256)
colormap(fresh_to_salty_colormap)


corrhc(corrhc>max_val)=max_val;
corrhc(corrhc<min_val)=min_val;
corrhc(~isfinite(corrhc))=NaN;

[cs1,h1]=m_contourf(lon,lat,corrhc',[-10000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on

m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none');
%contour_mean_sal_no_label_WOD09_m_map
%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');

hold on
m_coast('patch',[1 1 1]);
t1=m_text(55,54,['a) SON-MAM'],'fontsize',11,'fontweight','bold');
caxis([min_val max_val-del_cont])
a=gca;

%contour_mean_sal_WOD09
%contour_mean_sal_no_label


hold on
ja=axes('pos',[.262 .90-.0475 .51 .01]);
%colormap jet(256)
colormap(fresh_to_salty_colormap)
%  c=colormap;
%  c(1,:)=2/3;
%  colormap(c)
[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
xlabel(['       SON-MAM Sea Surface Salinity Change [PSS-78 yr ^{-1}]'])



%%%%  Year -year



lat=lat_year;
lon=lon_year;

subplot(2,1,2)

corrhc=interp2(lat,lon,sss_2013_2012,lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;

land_mask=msk2(2:end-1,:);

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-.5
max_val=.5
del_val=.25

del_cont=.05
miss_val= (min_val-max_val)./100;
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
land_mask=[land_mask(jj,:);land_mask(ii,:)];

corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(fresh_to_salty_colormap) 

corrhc(corrhc>max_val)=max_val;
corrhc(corrhc<min_val)=min_val;
corrhc(~isfinite(corrhc))=NaN;
sal_cont=double(sal_cont);

hold on

%colormap(fresh_to_salty_colormap) 
[cs1,h1]=m_contourf(lon,lat,corrhc',[-10000, min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
%m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none');
m_grid('tickdir','out','xtick',[30:30:390],'xticklabel',[],'ytick',[-90:30:90],'linestyle','none');

wysiwyg;orient tall
%contour_mean_sal_no_label_WOD09_m_map
%contour_mean_sal_no_label_argo_2012_m_map
contour_mean_sal_no_label_WOD09_m_map

hold on
m_coast('patch',[1 1 1]);
t1=m_text(55,54,['b) ',year_name_2013,'-',year_name_2012],'fontsize',11,'fontweight','bold');

caxis([min_val max_val-del_cont])

hold off


b=gca;
apos=get(a,'pos')

bpos=get(b,'pos')
set(b,'pos',bpos+[0 .03+.035 0 0],'xticklabel',[])
set(a,'pos',apos+[0 -.05-.03 0 0])


hold on

jb=axes('pos',[.262 .10+.06 .51 .01]);
%colormap jet(256)

colormap(fresh_to_salty_colormap)

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(jb,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
xlabel(['Sea Surface Salinity Change [PSS-78 yr ^{-1}]'])

set(jb,'XAxisLocation','bottom')
set(b,'xticklabel',[])





%
wysiwyg;orient tall

eval(['print -dpng -f1 /Users/johnlyman/figs/oco/Sal/oco_04_10_aquaris_mat_argo_2014_sonmam_3'])
eval(['print -dtiff -r300 -f1 /Users/johnlyman/figs/oco/Sal/oco_04_10_aquaris_mat_argo_2014_sonmam_3'])

