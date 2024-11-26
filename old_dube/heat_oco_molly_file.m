
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
load htanom_oco_realtime_1993_2008

ind_good=find(time <= 2008.5 & time>=1995.5);

ht_2008=htdiff(:,:,ind_good)./1e9;
one_insitu=one(:,:,ind_good);
hc_insitu=ht(:,:,ind_good)./1e9;





%ncload('htanom_diff_realtime_jan_2008_3_error_2005_2005.nc','lat','lon','time','one','htdiff');
%ncload('htanom_q1_no_te_1950_2007_2005_2005.nc','lat','lon','time','one','htdiff');



tgrid=time(ind_good);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load in the in the Aviso estimate %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ../../HC/hregress_reatime alpha alat alon
alpha=interp2(alat,alon,alpha,lat_tpx,lon_tpx');clear alon alat

ssh_total=ones(length(lon_tpx),length(lat_tpx),53)*NaN;
ssh_total_mean=ones(length(lon_tpx),length(lat_tpx),2)*NaN;
hc_aviso=ones(length(lon_tpx),length(lat_tpx),length(tgrid))*NaN;
hc_combined=hc_aviso;
for i=1:length(tgrid) 
    i
    sshave=zeros(length(lon_tpx),length(lat_tpx));
    
    ii=find(abs(tgrid(i)-syr)<=.5);
  for j=1:length(ii)
    load(['../../Mtpers/realtime/',s(ii(j)).name],'sshanom')
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
  
  
 
  hc_aviso(:,:,i)=sshave.*alpha./1e9;
  corrhc=interp2(lat,lon,squeeze(ht_2008(:,:,i)),lat_tpx,lon_tpx');
  
  corrhc(isnan(corrhc))=0;
  corrhc=(sshave.*alpha./1e9)+corrhc;
  corrhc(isnan(msk2(2:end-1,:)))=NaN;
  hc_combined(:,:,i)=corrhc;
  
     
 
  
  end % for years  

lat_aviso=lat_tpx;
lon_aviso=lon_tpx;
lat_insitu=lat;
lon_insitu=lon;
time=tgrid;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s
%%%                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /Users/johnlyman/data

save molly_hc hc_combined hc_insitu hc_aviso lon_aviso lat_aviso time one_insitu lon_insitu lat_insitu

