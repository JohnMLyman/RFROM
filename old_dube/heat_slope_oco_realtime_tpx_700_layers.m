% this code loads all the heat content into one file

%You to update this file so that it only 

path='/Volumes/Data/Globalhc/SAL/Floats/'

original=cd(path);



s=sdir('../../Mtpers/realtime_2013/ssh*.mat');
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday

load ../../Mtpers/meanssh_oco_realtime_2013 lat lon sshcyc gmo
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

sshcyc=[sshcyc(542:end,:,:);sshcyc(1:541,:,:)];

clear lon lat




load ../../HC/landmask msk2

%load hdata_oco_realtime_jan_clim_2012_700_real2
%load hdata_oco_realtime_jan_clim_2011t_2012_700_real2
load ../../HC/hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131991_2012_100_real

htdiff1=htdiff;
load ../../HC/hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131991_2012_100_300_real

htdiff2=htdiff;
load ../../HC/hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20131991_2012_300_700_real

htdiff3=htdiff;
htdiff=htdiff1+htdiff2+htdiff3;
htdiff_2013=htdiff;
time_2013=time;


% load ../../HC/hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20132011_2012_100_real
% 
% htdiff1=htdiff;
% load ../../HC/hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20132011_2012_100_300_real
% 
% htdiff2=htdiff;
% load ../../HC/hdata_new__ishii_EN3_2013_pfloat_sal_greg_jan_20132011_2012_300_700_real
% 
% htdiff3=htdiff;
% htdiff=htdiff1+htdiff2+htdiff3;
% htdiff_2013(:,:,end-1:end)=htdiff;
htdiff=htdiff_2013;
time=time_2013;
%load hdata_oco_realtime_jan_clim_2011t_2012_700_real2
% load ../../HC/hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_100_real
% 
% htdiff1=htdiff;
% load ../../HC/hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_100_300_real
% 
% htdiff2=htdiff;
% load ../../HC/hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_300_700_real
% 
% htdiff3=htdiff;
% htdiff=htdiff1+htdiff2+htdiff3;
% 
% htdiff_2012=htdiff;
% time_2012=time;
% 
% htdiff=cat(3,htdiff_2012,htdiff_2013);
% time=[time_2012;time_2013];


tgrid=time;
nlat=length(lat);
ntime=length(time);
nlon=length(lon);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load in the in the Aviso estimate %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load ../../HC/hregress_reatime alpha alat alon
% alpha=interp2(alat,alon,alpha,lat_tpx,lon_tpx');clear alon alat


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load in the in the Aviso estimate %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_100_2.mat')
load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_100_300_2.mat')
load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_300_700_2.mat')

%load ../../HC/hregress_reatime alpha alat alon
alpha_100=interp2(alat,alon,alpha_100,lat_tpx,lon_tpx');
alpha_100_300=interp2(alat,alon,alpha_100_300,lat_tpx,lon_tpx');
alpha_300_700=interp2(alat,alon,alpha_300_700,lat_tpx,lon_tpx');clear alon alat

alpha=alpha_100+alpha_100_300+alpha_300_700;

nlat_tpx=length(lat_tpx);
nlon_tpx=length(lon_tpx);



ssh_total=ones(length(lon_tpx),length(lat_tpx),53)*NaN;
ssh_total_mean=ones(length(lon_tpx),length(lat_tpx),2)*NaN;
tpxest=ones(length(lon_tpx),length(lat_tpx),ntime)*NaN;

for i=1:length(tgrid) 
    i
    sshave=zeros(length(lon_tpx),length(lat_tpx));
    
    ii=find(abs(tgrid(i)-syr)<=.5);
  for j=1:length(ii)
    load(['../../Mtpers/realtime_2013/',s(ii(j)).name],'sshanom')
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
  
  
  
      tpxest(:,:,i)=sshave.*alpha;
  
  
  end % for years  
%%%%%%%%%%%%%%%%%%
%                %
%%%%%%%%%%%%%%%%%
%%
hc_tpx=ones(nlon_tpx,nlat_tpx,ntime).*NaN;

for itime=1:ntime

    htdiff_junk=reshape(htdiff(:,:,itime),nlon,nlat);
    
corrhc=interp2(lat,lon,htdiff_junk,lat_tpx,lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc=corrhc+tpxest(:,:,itime);
corrhc(isnan(msk2(2:end-1,:)))=NaN;
hc_tpx(:,:,itime)=corrhc;


end

%%

% this part of the code fits a line to each point in space


lat=lat_tpx;
lon=lon_tpx;

slope=nans(nlon_tpx,nlat_tpx);
error=slope;





% this might need to changed if j_fit doesn't work.
time=time';
good=find(time>=1993);
ntime=length(good);
time=time(good);
for ilon=1:nlon_tpx
    for ilat=1:nlat_tpx
        
        hc=reshape(hc_tpx(ilon,ilat,good),1,ntime);
        
        
        if length(find(isfinite(hc) ==0))<1 & length(find(hc == 0))< ntime
            
           
        [jy_model,jy_model_err_95,jslope_error,jslope]=j_fit(time,hc);
        slope(ilon,ilat)=jslope;
        error(ilon,ilat)=jslope_error;
        end
        
    end
end


save slope_heat_2013_tpx_700_new_new_new slope error time lat lon


cd,original

