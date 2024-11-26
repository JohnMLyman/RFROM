  

file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_dec_2013_2_1_new'
file_name_mean='pfloat_sal_greg_dec_2013_2_1_new'

file_name='pfloat_sal_greg_jan_2014'
file_name_mean='pfloat_sal_greg_jan_2014'
file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'

max_year=2013;
min_year=2004;



%% load in the meanfields from WOD

depth_name=cell(1,7);
depth_name{1}='100';
depth_name{2}='700';
depth_name{3}='1800';
depth_name{4}='300';
depth_name{5}='900';
depth_name{6}='100_300';
depth_name{7}='300_700';

for jdepth=1:length(depth_name);
    idepth=depth_name{jdepth}';
 signal_to_noise=1;
 
eval(['load ',file_path,file_name_mean,'_',idepth','_',num2str(signal_to_noise),'_oa_mean_new.mat ht_out one_out lon lat '])

eval(['mean_heat_oa_',idepth','=ht_out;']);
lon_grid=lon';
lat_grid=lat';
 end

% remove the mean
np=length(ht_out);
% extend the lon of the mean so that it wraps around assumes globally
% grided mean



%%%


nlon_oa=length(lon_grid);
nlat_oa=length(lat_grid);

lat_grid_oa=lat_grid;
lon_grid_oa=lon_grid;
lat_grid_oa2=repmat(lat_grid,[nlon_oa,1]);
lon_grid_oa2=repmat(lon_grid',[1,nlat_oa]);
eval(['load ',file_path_out,file_name_mean,'_mean_heat_oco_100 mean_heat_1800 mean_heat_100_300 mean_heat_300_700 mean_heat_900 mean_heat_700 mean_heat_300 mean_heat_100 lon_grid lat_grid'])




mean_heat_1800=[mean_heat_1800(end-21:end-1,:,:);mean_heat_1800;mean_heat_1800(2:22,:,:)];
mean_heat_900=[mean_heat_900(end-21:end-1,:,:);mean_heat_900;mean_heat_900(2:22,:,:)];
mean_heat_700=[mean_heat_700(end-21:end-1,:,:);mean_heat_700;mean_heat_700(2:22,:,:)];
mean_heat_300=[mean_heat_300(end-21:end-1,:,:);mean_heat_300;mean_heat_300(2:22,:,:)];
mean_heat_100=[mean_heat_100(end-21:end-1,:,:);mean_heat_100;mean_heat_100(2:22,:,:)];
mean_heat_300_700=[mean_heat_300_700(end-21:end-1,:,:);mean_heat_300_700;mean_heat_300_700(2:22,:,:)];
mean_heat_100_300=[mean_heat_100_300(end-21:end-1,:,:);mean_heat_100_300;mean_heat_100_300(2:22,:,:)];

lon_grid=[lon_grid(end-21:end-1)-360 lon_grid lon_grid(2:22)+360];



mean_total_heat_100=mean_heat_oa_100+interp2(lon_grid,lat_grid,mean_heat_100',lon_grid_oa2,lat_grid_oa2);
mean_total_heat_300=mean_heat_oa_300+interp2(lon_grid,lat_grid,mean_heat_300',lon_grid_oa2,lat_grid_oa2);

mean_total_heat_100_300=mean_heat_oa_100_300+interp2(lon_grid,lat_grid,mean_heat_100_300',lon_grid_oa2,lat_grid_oa2);
mean_total_heat_300_700=mean_heat_oa_300_700+interp2(lon_grid,lat_grid,mean_heat_300_700',lon_grid_oa2,lat_grid_oa2);

mean_total_heat_700=mean_heat_oa_700+interp2(lon_grid,lat_grid,mean_heat_700',lon_grid_oa2,lat_grid_oa2);
mean_total_heat_900=mean_heat_oa_900+interp2(lon_grid,lat_grid,mean_heat_900',lon_grid_oa2,lat_grid_oa2);
mean_total_heat_1800=mean_heat_oa_1800+interp2(lon_grid,lat_grid,mean_heat_1800',lon_grid_oa2,lat_grid_oa2);

% remove the mean


figure(1);wysiwyg;orient tall
wysiwyg;orient tall
set(gcf,'color','white');
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
subplot(2,1,1)

lon=lon_grid_oa';
lat=lat_grid_oa;

corrhc=mean_total_heat_700./1e10;




% put into the proper coordinates
min_val=0
max_val=5.5
del_val=.5
del_cont=.25
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
colormap jet(256)

%colormap(cold_to_hot_colormap) 


m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
%colormap(fresh_to_salty_colormap) 
[cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none');


%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
a=gca;
apos=get(a,'pos')



set(a,'pos',apos+[0 -.05-.03 0 0])

hold on
m_coast('patch',[1 1 1]);
%t1=m_text(60,54,'a) 2013','fontsize',11,'fontweight','bold');

caxis([min_val max_val-del_cont])

hold off

ja=axes('pos',[.262 .90-.0475 .51 .01]);
colormap jet(256)

%colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
xlabel('Mean 0-700 m Ocean Heat Content [J m ^{-2} x 10^{10}]')

eval(['print -dpng -f1 /Users/johnlyman/figs/oco/Oceans/mean_ohc_0_700'])

