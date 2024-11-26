function [hc,time,Area]=heat_curv_gen_mat_topo_new_layers_karina_tpxest_lat(file_name_in,file_name_argo,depth_min,depth_max,lats,latn)


%% load in ohca and make combined estimate

layer_bounds=[0,300,700,2000];
min_year_maps=1993;
max_year_maps=2018;

[alat,alon,alpha]=load_layer_alpha(file_name_argo,layer_bounds,depth_min,depth_max);
cd /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/
eval(['load  ../../Mtpers/meanssh_oco_realtime_',file_name_argo,'  lat lon gmo sshcyc '])

%load ../../Mtpers/meanssh_oco_realtime_2013 lat lon sshcyc gmo

lat_tpx=lat;
lon=lon';
lon_tpx=[lon(721:end)-360;lon(1:720)];
sshcyc=[sshcyc(721:end,:,:);sshcyc(1:720,:,:)];

clear lon lat

alpha=interp2(alat,alon,alpha,lat_tpx,lon_tpx);


%% NEED TO CHANGE 2015 AND 2016 TO MATHC THE YEARS THAT ARE BEING PLOTED



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get information on Aviso files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/
path_ssh='../../Mtpers/realtime_oco/';
s=sdir([path_ssh,'ssh*.mat']);
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday





%load ../../HC/landmask msk2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Load in situ - aviso estimate       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
[lat,lon,ht,htdiff,one,time,tpx]=load_layer_OHCA(file_name_in,layer_bounds,depth_min,depth_max);





ind_all=find(time>min_year_maps & time <max_year_maps+1);
htdiff_all=(htdiff(:,:,ind_all));
%tgrid=[1993.5:1:2018.5];
tgrid=[min_year_maps+.5:1:max_year_maps+.5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load in the in the Aviso estimate %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 


ssh_total=ones(length(lon_tpx),length(lat_tpx),53)*NaN;
ssh_total_mean=ones(length(lon_tpx),length(lat_tpx),2)*NaN;
tpxest=ssh_total_mean;


for i=1:length(tgrid) 
    i
    sshave=zeros(length(lon_tpx),length(lat_tpx));
    
    ii=find(abs(tgrid(i)-syr)<=.5);
    tgrid(i),length(ii)
  for j=1:length(ii)
    load([path_ssh,s(ii(j)).name],'sshanom')
    mo=str2num(s(ii(j)).name(end-8:end-4));
    mo=mo+datenum(1950,1,1)-datenum(1992,1,1);
    mo=mod(mo/365.25*12,12);
    sshc=squeeze(0*sshcyc(:,:,1));
    for k=1:length(gmo)
	jj=zeros(1,length(gmo));jj(k)=1;
	w(k)=interp1(gmo,jj,mo,'*pchip');
	sshc=sshc+sshcyc(:,:,k)*w(k);
    end %for 
    sshanom=[sshanom(721:end,:);sshanom(1:720,:)];
    sshanom=sshanom-sshc;
   % ssh_total(:,:,j)=sshanom;
    sshave=sshave+sshanom/length(ii);
    
    
  end  %for months


  % make aviso estimate
%   sshave(isnan(sshave))=0;
  %sshave(isnan(msk2(2:end-1,:)))=NaN;
  ssh_total_mean(:,:,i)=sshave;
  tpxest(:,:,i)=sshave.*(alpha);
  
  
  
end % for years  
%
  
 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s
%%%                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


lon2=lon;
 lat2=lat;

lon=lon2;
lat=lat2;

time=time(ind_all);
htdiff_new=interp3(lat,lon,time,htdiff_all,double(lat_tpx)',double(lon_tpx)',time);

htdiff_new(isnan(htdiff_new))=0;
ht_tpxest=htdiff_new+tpxest;

lon_ht=lon_tpx;
lat_ht=lat_tpx;





%%  apply mask with depth 

load /Volumes/ThunderBay/Data/Globalhc/Mtpers/meanssh lat lon sshmean
% to get rid of ice
file_name=[file_name_in,num2str(depth_min),'_',num2str(depth_max),'_real_new_layers'];
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat

% grid topo grids depth on topex grid
% grid_topo

load /Volumes/ThunderBay/Data/Globalhc/topo/topo_tpx

% linear interpilate to topex grid and apply mland mask

topo_tpx=-1.*topo;
lat2_tpx=repmat(lat_tpx',[1080,1]);

shallow=find(topo_tpx < depth_min | topo_tpx < 100);
mid=find(topo_tpx>=depth_min & topo_tpx<depth_max);
bad_lat=find(lat2_tpx>latn | lat2_tpx<lats);


clear lon_topo lat_topo topo
load /Volumes/ThunderBay/Data/Globalhc/HC/landmask msk2


 lon2=lon_ht;

 lat2=lat_ht;
ht=ht_tpxest;
 
 
 
 
 
for i=1:length(time)
arw_j=arw;
%%%figure(i);wysiwyg

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask

corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx')./1e9;
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
%corrhc(isnan(sshmean))=NaN;

corrhc(shallow)=NaN;
corrhc(bad_lat)=NaN;

arw_j(mid)=arw_j(mid).*(topo_tpx(mid)-depth_min)./(depth_max-depth_min);
arw_j(shallow)=NaN;
arw_j(bad_lat)=NaN;



lon=lon_tpx;
lat=lat_tpx;
Area(i)=sum(arw_j(~isnan(arw_j)));
% compute the area average heatcontent across the globe.

hc(i)=1e9.*nansum(arw_j(:).*corrhc(:));
time_hc(i)=time(i);


end
