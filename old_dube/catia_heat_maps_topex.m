
'kat'

cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);
cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get information on Aviso files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /Users/johnlyman/data/Globalhc/SAL/Floats/
path_ssh='../../Mtpers/realtime_2014/';
s=sdir([path_ssh,'ssh*.mat']);
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday

load ../../Mtpers/meanssh_oco_realtime_2014 lat lon sshcyc gmo
lon=lon';
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
load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_20141991_2013_100_real

htdiff_100=htdiff;
one_100=one;





% mask out bad data
%bad=find(one_2007 <= .8);
%ht_2007(bad)=NaN;
load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_20141991_2013_100_300_real
htdiff_100_300=htdiff;
one_100_300=one;


htdiff_100_300=htdiff;


load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_20141991_2013_300_700_real
htdiff_300_700=htdiff;
one_300_700=one;




ind_all=find(time>1993 & time <2014);
ht_all=(htdiff_100(:,:,ind_all)+htdiff_100_300(:,:,ind_all)+htdiff_300_700(:,:,ind_all))./1e9;
tgrid=[1993.5:1:2013.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load in the in the Aviso estimate %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_100_2.mat')
load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_100_300_2.mat')
load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_300_700_2.mat')

%load ../../HC/hregress_reatime alpha alat alon
alpha_100=interp2(alat,alon,alpha_100,lat_tpx,lon_tpx);
alpha_100_300=interp2(alat,alon,alpha_100_300,lat_tpx,lon_tpx);
alpha_300_700=interp2(alat,alon,alpha_300_700,lat_tpx,lon_tpx);clear alon alat

ssh_total=ones(length(lon_tpx),length(lat_tpx),53)*NaN;
ssh_total_mean=ones(length(lon_tpx),length(lat_tpx),2)*NaN;


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
	w(k)=interp1(gmo,jj,mo,'*cubic');
	sshc=sshc+sshcyc(:,:,k)*w(k);
    end %for 
    sshanom=[sshanom(542:end,:);sshanom(1:541,:)];
    sshanom=sshanom-sshc;
   % ssh_total(:,:,j)=sshanom;
    sshave=sshave+sshanom/length(ii);
    
    
  end  %for months


  % make aviso estimate
  sshave(isnan(sshave))=0;sshave(isnan(msk2(2:end-1,:)))=NaN;
  ssh_total_mean(:,:,i)=sshave;
  
  
 
  
  end % for years  

tpxest_all=nanmean(ssh_total_mean,3).*(alpha_100+alpha_100_300+alpha_300_700)./1e9;
ht_all_mean=nanmean(ht_all(:,:,1:end-1),3);

corrhc=interp2(lat,lon,ht_all_mean,lat_tpx,lon_tpx);
corrhc(isnan(corrhc))=0;
corrhc=corrhc+tpxest_all;
corrhc(isnan(msk2(2:end-1,:)))=NaN;
ht_1993_2013_mean=corrhc;


s=size(ssh_total_mean);
ht_tpx=nans(s(1),s(2),s(3));

for i=1:s(3)
       corrhc=interp2(lat,lon,ht_all(:,:,i),lat_tpx,lon_tpx);
       corrhc(isnan(corrhc))=0;
       corrhc=corrhc+ssh_total_mean(:,:,i).*(alpha_100+alpha_100_300+alpha_300_700)./1e9;
       corrhc(isnan(msk2(2:end-1,:)))=NaN;
       ht_tpx(:,:,i)=corrhc-ht_1993_2013_mean;
end
time=tgrid;
save '../../HC/hc_tpx_catia.mat' ht_tpx time lat_tpx lon_tpx
