% this code loads all the heat content into one file
path='/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/'

original=cd(path);
%You to update this file so that it only 
year_of_oco_pub=2019; %  NEED TO CHANGE year_of_oco_pub OR TREND WONT CHANGE AND PLOTS WILL BE WRITEN OVER

file_name='argo_2018_12_6_QC'
layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000] % layer_bounds must be in assending order
file_name_argo='pfloat_sal_greg_jan_2019_QC';
depth_top_plot=0;
depth_bot_plot=700;
slope_min_year=1993;
OHCA_map_name=['hdata_new_layers__ishii_EN3_2014_',file_name,'1990_2018_'] %NEED TO CHANGE TO MATCH OUTPUT OF OCO_MAPS_2017_2
eval(['load  ../../Mtpers/meanssh_oco_realtime_',file_name,'  lat lon gmo sshcyc '])

%load ../../Mtpers/meanssh_oco_realtime_2016 lat lon sshcyc gmo
%load /Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/aviso_cycle lon lat sshcyc

lon=lon';
lon_tpx=[lon(721:end)-360;lon(1:720)];
%lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

sshcyc=[sshcyc(721:end,:,:);sshcyc(1:720,:,:)];



load ../../HC/landmask msk2 lon2 lat2
mask2=interp2(lat2,lon2,msk2,lat_tpx,lon_tpx);


% load the data

%load slope_heat_2007

%heat_slope_oco_realtime_tpx_700_layers_2016

heat_slope_file=['slope_heat_',num2str(year_of_oco_pub),'_tpx_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)];
path='/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/'

original=cd(path);

path_ssh='../../Mtpers/realtime_oco/';

s=sdir([path_ssh,'ssh*.mat']);
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday


[alat,alon,alpha]=load_layer_alpha(file_name,layer_bounds,depth_top_plot,depth_bot_plot);
alpha=interp2(alat,alon,alpha,lat_tpx,lon_tpx);
eval(['load  ../../Mtpers/meanssh_oco_realtime_',file_name,'  lat lon gmo sshcyc '])

%load ../../Mtpers/meanssh_oco_realtime_2013 lat lon sshcyc gmo

lat_tpx=lat;
lon=lon';
lon_tpx=[lon(721:end)-360;lon(1:720)];
sshcyc=[sshcyc(721:end,:,:);sshcyc(1:720,:,:)];
%sshcyc=[sshcyc(542:end,:,:);sshcyc(1:541,:,:)];

clear lon lat




load ../../HC/landmask msk2

%load hdata_oco_realtime_jan_clim_2012_700_real2
%load hdata_oco_realtime_jan_clim_2011t_2012_700_real2
% % load ../../HC/hdata_new__ishii_EN3_pfloat_sal_greg_jan_20132010_2012_100_real
% % 
% % htdiff1=ht;
% % load ../../HC/hdata_new__ishii_EN3_pfloat_sal_greg_jan_20132010_2012_100_300_real
% % 
% % htdiff2=ht;
% % load ../../HC/hdata_new__ishii_EN3_pfloat_sal_greg_jan_20132010_2012_300_700_real
% % 
% % htdiff3=ht;
% % htdiff=htdiff1+htdiff2+htdiff3;
% % ht_2013=htdiff;
% % time_2013=time;
% % 
% % %load hdata_oco_realtime_jan_clim_2011t_2012_700_real2
% % load ../../HC/hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_100_real
% % 
% % htdiff1=ht;
% % load ../../HC/hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_100_300_real
% % 
% % htdiff2=ht;
% % load ../../HC/hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_300_700_real
% % 
% % htdiff3=ht;
% % htdiff=htdiff1+htdiff2+htdiff3;
% % 
% % ht_2012=htdiff;
% % time_2012=time;
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% % ht=cat(3,ht_2012,ht_2013);
% % time=[time_2012;time_2013];
% % 
% % 
[lat,lon,ht,htdiff,one,time,tpx]=load_layer_OHCA(OHCA_map_name,layer_bounds,depth_top_plot,depth_bot_plot);
htdiff_2013=htdiff;
time_2013=time;
% % % 
% % % load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1950_2015_100_real
% % % 
% % % htdiff1=ht;
% % % load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1950_2015_100_300_real
% % % 
% % % htdiff2=ht;
% % % load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1950_2015_300_700_real
% % % 
% % % htdiff3=ht;
% % % 
% % % htdiff=htdiff1+htdiff2+htdiff3;
% % % 
% % % 
% % % ht=htdiff;

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
  sshave(isnan(sshave))=0;
  %sshave(isnan(msk2(2:end-1,:)))=NaN;
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
    
corrhc=interp2(lat,lon,htdiff_junk,lat_tpx,lon_tpx);
corrhc(isnan(corrhc))=0;
corrhc=corrhc+tpxest(:,:,itime);
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
hc_tpx(:,:,itime)=corrhc;


end

%%%%

% this part of the code fits a line to each point in space


lat=lat_tpx;
lon=lon_tpx;

slope=nans(nlon_tpx,nlat_tpx);
error=slope;
auto_corr_scale=slope;




% this might need to changed if j_fit doesn't work.
time=time';
time_or=time;

for del_year=2:25
    
    for start_slope=1993:2018-del_year

        end_year=start_slope+del_year;

       
            time=time_or;
            good=find(time>=start_slope & time<end_year+1);
            ntime=length(good);
            time=time(good);
            for ilon=1:nlon_tpx
                for ilat=1:nlat_tpx

                    hc=reshape(hc_tpx(ilon,ilat,good),1,ntime);


                    if length(find(isfinite(hc) ==0))<1 & length(find(hc == 0))< ntime


                    [jy_model,jy_model_err_95,jslope_error,jslope,jauto_corr_scale]=j_fit_greg(time,hc);
                    slope(ilon,ilat)=jslope;
                    auto_corr_scale(ilon,ilat)=jauto_corr_scale;
                    error(ilon,ilat)=jslope_error;
                    end

                end
            end


        eval(['save ',heat_slope_file,'_',num2str(del_year),'_yeartrend_',num2str(start_slope),' slope error auto_corr_scale time lat lon'])
       
    end
end
cd,original

