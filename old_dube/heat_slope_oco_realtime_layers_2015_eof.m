% this code loads all the heat content into one file

%You to update this file so that it only 
min_year=1950;
max_year=2014;


path='/Volumes/Data/Globalhc/SAL/Floats/'

original=cd(path);



s=sdir('../../Mtpers/realtime_2015/ssh*.mat');
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday

load ../../Mtpers/meanssh_oco_realtime_2015 lat lon sshcyc gmo
lon=lon';
lon_tpx=[lon(721:end)-360;lon(1:720)];
%lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

sshcyc=[sshcyc(721:end,:,:);sshcyc(1:720,:,:)];

clear lon lat




load ../../HC/landmask msk2 lat2 lon2
msk3=interp2(lat2,lon2,msk2,lat_tpx,lon_tpx);
msk3(isfinite(msk3))=1;
msk2=msk3; clear msk3 lat2 lon2

%load hdata_oco_realtime_jan_clim_2012_700_real2
%load hdata_oco_realtime_jan_clim_2011t_2012_700_real2
load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2015_QC1950_2014_100_real
good=find(time>=min_year+.5 & time <=max_year+.5);

ht1=ht(:,:,good);
load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2015_QC1950_2014_100_300_real

ht2=ht(:,:,good);
load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2015_QC1950_2014_300_700_real

ht3=ht(:,:,good);
load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2015_QC1950_2014_900_real

ht4=ht(:,:,good);
load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2015_QC1950_2014_1800_real

ht5=ht(:,:,good);
 
time=time(good);


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
% % % load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_100_2.mat')
% % % load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_100_300_2.mat')
% % % load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_300_700_2.mat')
% % % load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_900_2.mat')
% % % load('/Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_1800_2.mat')
% % % 
% % % %load ../../HC/hregress_reatime alpha alat alon
% % % alpha_100=-1*interp2(alat,alon,alpha_100,lat_tpx,lon_tpx);
% % % alpha_100_300=-1*interp2(alat,alon,alpha_100_300,lat_tpx,lon_tpx);
% % % alpha_300_700=-1*interp2(alat,alon,alpha_300_700,lat_tpx,lon_tpx);
% % % 
% % % alpha_900=-1*interp2(alat,alon,alpha_900,lat_tpx,lon_tpx);
% % % alpha_1800=-1*interp2(alat,alon,alpha_1800,lat_tpx,lon_tpx);
% % % 
% % % clear alon alat
% 
% alpha=alpha_100+alpha_100_300+alpha_300_700;

nlat_tpx=length(lat_tpx);
nlon_tpx=length(lon_tpx);

% % % 
% % % 
% % % ssh_total=ones(length(lon_tpx),length(lat_tpx),53)*NaN;
% % % ssh_total_mean=ones(length(lon_tpx),length(lat_tpx),2)*NaN;
% % % tpxest_100=ones(length(lon_tpx),length(lat_tpx),ntime)*NaN;
% % % tpxest_100_300=ones(length(lon_tpx),length(lat_tpx),ntime)*NaN;
% % % tpxest_300_700=ones(length(lon_tpx),length(lat_tpx),ntime)*NaN;
% % % tpxest_900=ones(length(lon_tpx),length(lat_tpx),ntime)*NaN;
% % % tpxest_1800=ones(length(lon_tpx),length(lat_tpx),ntime)*NaN;
% % % 
% % % 
% % % 
% % % 
% % % 
% % % for i=1:length(tgrid) 
% % %     i
% % %     sshave=zeros(length(lon_tpx),length(lat_tpx));
% % %     
% % %     ii=find(abs(tgrid(i)-syr)<=.5);
% % %   for j=1:length(ii)
% % %     load(['../../Mtpers/realtime_2015/',s(ii(j)).name],'sshanom')
% % %     mo=str2num(s(ii(j)).name(end-8:end-4));
% % %     mo=mo+datenum(1950,1,1)-datenum(1992,1,1);
% % %     mo=mod(mo/365.25*12,12);
% % %     sshc=squeeze(0*sshcyc(:,:,1));
% % %     for k=1:length(gmo)
% % % 	jj=zeros(1,length(gmo));jj(k)=1;
% % % 	w(k)=interp1(gmo,jj,mo,'*cubic');
% % % 	sshc=sshc+sshcyc(:,:,k)*w(k);
% % %     end %for 
% % %     sshanom=[sshanom(721:end,:);sshanom(1:720,:)];
% % %     sshanom=sshanom-sshc;
% % %    % ssh_total(:,:,j)=sshanom;
% % %     sshave=sshave+sshanom/length(ii);
% % %     
% % %     
% % %   end  %for months
% % % 
% % % 
% % %   % make aviso estimate
% % %   sshave(isnan(sshave))=0;
% % %   %sshave(isnan(msk2(2:end-1,:)))=NaN;
% % %   ssh_total_mean(:,:,i)=sshave;
% % %   
% % %   
% % %   
% % %       tpxest_100(:,:,i)=sshave.*alpha_100;
% % %       tpxest_100_300(:,:,i)=sshave.*alpha_100_300;
% % %       tpxest_300_700(:,:,i)=sshave.*alpha_300_700;
% % %       tpxest_900(:,:,i)=sshave.*alpha_900;
% % %       tpxest_1800(:,:,i)=sshave.*alpha_1800;
% % %   
% % %   
% % %   end % for years  
%%%%%%%%%%%%%%%%%%
%                %
%%%%%%%%%%%%%%%%%
%%
hc_100=ones(nlon_tpx,nlat_tpx,ntime).*NaN;
hc_100_300=ones(nlon_tpx,nlat_tpx,ntime).*NaN;
hc_300_700=ones(nlon_tpx,nlat_tpx,ntime).*NaN;
hc_1800=ones(nlon_tpx,nlat_tpx,ntime).*NaN;
hc_900=ones(nlon_tpx,nlat_tpx,ntime).*NaN;


for itime=1:ntime

    htdiff_junk_100=reshape(ht1(:,:,itime),nlon,nlat);
    htdiff_junk_100_300=reshape(ht2(:,:,itime),nlon,nlat);
    htdiff_junk_300_700=reshape(ht3(:,:,itime),nlon,nlat);
    htdiff_junk_900=reshape(ht4(:,:,itime),nlon,nlat);
    htdiff_junk_1800=reshape(ht5(:,:,itime),nlon,nlat);
    
corrhc_100=interp2(lat,lon,htdiff_junk_100,lat_tpx,lon_tpx);
corrhc_100(isnan(corrhc_100))=0;
corrhc_100(isnan(msk2))=NaN;
hc_100(:,:,itime)=corrhc_100;

corrhc_100_300=interp2(lat,lon,htdiff_junk_100_300,lat_tpx,lon_tpx);
corrhc_100_300(isnan(corrhc_100_300))=0;
corrhc_100_300(isnan(msk2))=NaN;
hc_100_300(:,:,itime)=corrhc_100_300;

corrhc_300_700=interp2(lat,lon,htdiff_junk_300_700,lat_tpx,lon_tpx);
corrhc_300_700(isnan(corrhc_300_700))=0;
corrhc_300_700(isnan(msk2))=NaN;
hc_300_700(:,:,itime)=corrhc_300_700;

corrhc_900=interp2(lat,lon,htdiff_junk_900,lat_tpx,lon_tpx);
corrhc_900(isnan(corrhc_900))=0;
corrhc_900(isnan(msk2))=NaN;
hc_900(:,:,itime)=corrhc_900;

corrhc_1800=interp2(lat,lon,htdiff_junk_1800,lat_tpx,lon_tpx);
corrhc_1800(isnan(corrhc_1800))=0;
corrhc_1800(isnan(msk2))=NaN;
hc_1800(:,:,itime)=corrhc_1800;
end

%%

% this part of the code fits a line to each point in space
lat=lat_tpx;
lon=lon_tpx;
save ../../HC/ohca_100_300_700_900_1800 hc_100 hc_100_300 hc_300_700 hc_900 hc_1800 time lat lon


slope=nans(nlon_tpx,nlat_tpx);
error=slope;


% 
% 
% 
% % this might need to changed if j_fit doesn't work.
% time=time';
% good=find(time>=1993);
% ntime=length(good);
% time=time(good);
% for ilon=1:nlon_tpx
%     for ilat=1:nlat_tpx
%         
%         hc=reshape(hc_tpx(ilon,ilat,good),1,ntime);
%         
%         
%         if length(find(isfinite(hc) ==0))<1 & length(find(hc == 0))< ntime
%             
%            
%         [jy_model,jy_model_err_95,jslope_error,jslope]=j_fit(time,hc);
%         slope(ilon,ilat)=jslope;
%         error(ilon,ilat)=jslope_error;
%         end
%         
%     end
% end
% 
% 
% save slope_heat_2013_tpx_700_2015_n slope error time lat lon
% 
% 
% cd,original

