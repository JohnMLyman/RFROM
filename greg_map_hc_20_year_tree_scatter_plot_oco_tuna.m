

cold_to_hot_colormap=diverging_map([0:1/100:1],[20 43 140]/255,[204 0 51]/255);
path_heat_slope='C:\data\OHCA\OHCA_grided\';

heat_slope_file=[path_heat_slope,'slope_heat_',num2str(year_of_oco_pub),'_tree_',num2str(min_layer),'_',num2str(max_layer)];

if ~exist([heat_slope_file,'.mat'],'file')
    
    heat_slope_oco_realtime_tree_700_layers_oco_tuna
    
else
    load([heat_slope_file,'.mat'],'slope','error')
end
    
slope=slope./1e9;
error=error./1e9;

% % % corrhc=interp2(lat,lon,slope,lat_tpx,lon_tpx);
% % % %corrhc(isnan(corrhc))=0;
% % % %corrhc(isnan(msk2(2:end-1,:)))=NaN;
% % % corrhc(isnan(mask2))=NaN;
% % % 
% % % slope=corrhc;
% % % 
% % % corrhc=interp2(lat,lon,error,lat_tpx,lon_tpx);
% % % %corrhc(isnan(corrhc))=0;
% % % %corrhc(isnan(msk2(2:end-1,:)))=NaN;
% % % corrhc(isnan(mask2))=NaN;
% % % 
% % % error=corrhc;
lon=lon_tpx';
lat=lat_tpx';
% put into the proper coordinates


ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj) lon(ii)+360];
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

set(gcf,'color','white');
% put into the proper coordinates
min_val=-6
max_val=6
del_val=1.
del_cont=.5;

subplot(3,1,3)
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);

colormap(cold_to_hot_colormap) 
%[cs,h]=m_contour(lon,lat,r2',[0 0],'k');
hold on

[cs1,h1]=m_contourf(lon,lat,slope',[-1000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:60:390],'ytick',[-90:30:90],'linestyle','none');


%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
c=gca; 
hold on
[cs,h]=m_contour(lon,lat,r2',[0 0],'k','linew',0.1);


nlat=length(lat);
nlon=length(lon);
% put dots on 1 degree grid

[~,good_lat]=unique(floor(lat));
[~,good_lon]=unique(floor(lon));

good_lat=good_lat(1:2:end);
good_lon=good_lon(1:2:end);

lats=repmat(lat,1440,1);
lons=repmat(lon',1,720);
rf=r;
rf(abs(r)>=1)=nan;
rf(abs(r)<1)=1;
llons=lons(good_lon,good_lat);
llats=lats(good_lon,good_lat);
rrf=rf(good_lon,good_lat);
%mlp=m_plot(llons(isfinite(rrf)),llats(isfinite(rrf)),'k.','MarkerSize',.5)
m_scatter(llons(:),llats(:),rrf(:),'k','filled')

m_coast('patch',[1 1 1]);
t1=m_text(30,100,['(c) ',num2str(slope_min_year),'-',num2str(year_of_oco_pub-1),' trend'],'fontsize',12,'fontname','arial','linew',0.1);
t2=m_text(320,-115,['(W m ^{-2})'],'fontsize',12);

caxis([min_val max_val-del_cont])

hold off

jc=axes('pos',[.262 .90-.0475 .51 .01]);
%colormap jet(256)

colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')

set(jc,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
%xlabel('1993-2015 Heat Content Trend [W m^{-2}]')


%%

