cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get information on Aviso files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


s=sdir('../../Mtpers/ssh*.mat');
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday

load ../../Mtpers/meanssh lat lon sshcyc gmo
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

sshcyc=[sshcyc(542:end,:,:);sshcyc(1:541,:,:)];

nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);

clear lon lat




load ../../HC/landmask msk2

%load htanom_1993_2006_xbt_no_te  
load htanom_1993_2006_no_te_delayed
htdiff=htdiff./1e9;

lat2=lat;
lon2=lon;


tgrid=[1993.5:2005.5];
ntime=length(tgrid);
tpx_est=ones(nlon_tpx,nlat_tpx,ntime)*NaN;
diff_est=tpx_est;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load in the in the Aviso estimate %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ../../HC/hregress2 alpha alat alon
alpha=interp2(alat,alon,alpha,lat_tpx,lon_tpx');clear alon alat

ssh_total=ones(nlon_tpx,nlat_tpx,53)*NaN;
ssh_total_mean=ones(nlon_tpx,nlat_tpx,2)*NaN;


for i=1:length(tgrid) 
    i
    sshave=zeros(length(lon_tpx),length(lat_tpx));
    
    ii=find(abs(tgrid(i)-syr)<=.5);
  for j=1:length(ii)
    load(['../../Mtpers/',s(ii(j)).name],'sshanom')
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
  
  
      tpx_est(:,:,i)=sshave.*alpha./1e9;
	
	lon=lon2;
	lat=lat2;

	idiff=find(time == tgrid(i));

        htdiff_junk=htdiff(:,:,idiff);
	corrhc=interp2(lat,lon,htdiff_junk,lat_tpx,lon_tpx');
	corrhc(isnan(corrhc))=0;
	corrhc(isnan(msk2(2:end-1,:)))=NaN;
	diff_est(:,:,i)=corrhc;    
  
  end % for years  

hc_diff=tpx_est+diff_est;

lon=lon_tpx;
lat=lat_tpx;
%save ./data/ht_diff_1993_2004_xbt_no_te hc_diff diff_est tpx_est tgrid lon lat
save ./data/ht_diff_1993_2004_no_te_delayed hc_diff diff_est tpx_est tgrid lon lat

