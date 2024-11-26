% this code loads all the heat content into one file
tic
path='/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/'

original=cd(path);
%You to update this file so that it only 
year_of_oco_pub=2019; %  NEED TO CHANGE year_of_oco_pub OR TREND WONT CHANGE AND PLOTS WILL BE WRITEN OVER

file_name2='argo_2018_12_6_QC'
file_name='argo_2019_4_16_QC'
file_name_argo='pfloat_sal_greg_jan_2019_QC';
file_name_argo='pfloat_sal_greg_jan_2020_QC';
file_name='argo_2018_12_6_QC'
file_name='argo_2019_4_16_QC'
file_name='argo_2019_1_06_QC'

layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000] % layer_bounds must be in assending order
layer_bounds=[0,40,90,190,290,450,700];

depth_top_plot=0;
depth_bot_plot=700;
slope_min_year=1993;
slope_max_year=2019;
max_trend_length=slope_max_year-slope_min_year+1;
OHCA_map_name=['hdata_new_layers__ishii_EN3_2014_',file_name,'1990_2019_'] %NEED TO CHANGE TO MATCH OUTPUT OF OCO_MAPS_2017_2

eval(['load  ../../Mtpers/meanssh_oco_realtime_',file_name,'  lat lon gmo sshcyc '])

%load ../../Mtpers/meanssh_oco_realtime_2016 lat lon sshcyc gmo
%load /Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/aviso_cycle lon lat sshcyc

lon=lon';
lon_tpx=[lon(721:end)-360;lon(1:720)];
%lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

sshcyc=[sshcyc(721:end,:,:);sshcyc(1:720,:,:)];

load /Volumes/ThunderBay/Data/OHCA_curves/mask_layers
load ../../HC/landmask msk2 lon2 lat2
mask2=interp2(lat2,lon2,msk2,lat_tpx,lon_tpx);


% load the data

%load slope_heat_2007

%heat_slope_oco_realtime_tpx_700_layers_2016


path='/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/'

original=cd(path);

path_ssh='../../Mtpers/realtime_oco/';

s=sdir([path_ssh,'ssh*.mat']);
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday


[alat,alon,alpha_0_40]=load_layer_alpha(file_name,layer_bounds,0,40);
[alat,alon,alpha_40_90]=load_layer_alpha(file_name,layer_bounds,40,90);
[alat,alon,alpha_90_190]=load_layer_alpha(file_name,layer_bounds,90,190);
[alat,alon,alpha_190_290]=load_layer_alpha(file_name,layer_bounds,190,290);
[alat,alon,alpha_290_450]=load_layer_alpha(file_name,layer_bounds,290,450);

[alat,alon,alpha_450_700]=load_layer_alpha(file_name,layer_bounds,450,700);

alpha_0_40=interp2(alat,alon,alpha_0_40,lat_tpx,lon_tpx);
alpha_40_90=interp2(alat,alon,alpha_40_90,lat_tpx,lon_tpx);
alpha_90_190=interp2(alat,alon,alpha_90_190,lat_tpx,lon_tpx);
alpha_190_290=interp2(alat,alon,alpha_190_290,lat_tpx,lon_tpx);
alpha_290_450=interp2(alat,alon,alpha_290_450,lat_tpx,lon_tpx);
alpha_450_700=interp2(alat,alon,alpha_450_700,lat_tpx,lon_tpx);


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



[lat,lon,ht,htdiff_0_40,one,time,tpx]=load_layer_OHCA_half(OHCA_map_name,layer_bounds,0,40);
[lat,lon,ht,htdiff_40_90,one,time,tpx]=load_layer_OHCA_half(OHCA_map_name,layer_bounds,40,90);
[lat,lon,ht,htdiff_90_190,one,time,tpx]=load_layer_OHCA_half(OHCA_map_name,layer_bounds,90,190);
[lat,lon,ht,htdiff_190_290,one,time,tpx]=load_layer_OHCA_half(OHCA_map_name,layer_bounds,190,290);
[lat,lon,ht,htdiff_290_450,one,time,tpx]=load_layer_OHCA_half(OHCA_map_name,layer_bounds,290,450);
[lat,lon,ht,htdiff_450_700,one,time,tpx]=load_layer_OHCA_half(OHCA_map_name,layer_bounds,450,700);


% % % [lat,lon,ht,htdiff2_0_40,one,time2,tpx]=load_layer_OHCA(OHCA_map_name2,layer_bounds,0,40);
% % % [lat,lon,ht,htdiff2_40_90,one,time2,tpx]=load_layer_OHCA(OHCA_map_name2,layer_bounds,40,90);
% % % [lat,lon,ht,htdiff2_90_190,one,time2,tpx]=load_layer_OHCA(OHCA_map_name2,layer_bounds,90,190);
% % % [lat,lon,ht,htdiff2_190_290,one,time2,tpx]=load_layer_OHCA(OHCA_map_name2,layer_bounds,190,290);
% % % [lat,lon,ht,htdiff2_290_450,one,time2,tpx]=load_layer_OHCA(OHCA_map_name2,layer_bounds,290,450);
% % % [lat,lon,ht,htdiff2_450_700,one,time2,tpx]=load_layer_OHCA(OHCA_map_name2,layer_bounds,450,700);
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

% % % htdiff3_0_40=nans(721,361,29*2);
% % % htdiff3_40_90=htdiff3_0_40;
% % % htdiff3_90_190=htdiff3_0_40;
% % % htdiff3_190_290=htdiff3_0_40;
% % % htdiff3_290_450=htdiff3_0_40;
% % % htdiff3_450_700=htdiff3_0_40;
% % % time3=nans(29*2,1);
% % % 
% % % pos2=1:2:29*2;
% % % pos=2:2:29*2+1;
% % % 
% % % time3(pos)=time;
% % % time3(pos2)=time2;
% % % time=time3;
% % % clear time2
% % % 
% % % htdiff3_0_40(:,:,pos)=htdiff_0_40;
% % % htdiff3_0_40(:,:,pos2)=htdiff2_0_40;
% % % htdiff_0_40=htdiff3_0_40;
% % % clear htdiff3_0_40
% % % 
% % % htdiff3_40_90(:,:,pos)=htdiff_40_90;
% % % htdiff3_40_90(:,:,pos2)=htdiff2_40_90;
% % % htdiff_40_90=htdiff3_40_90;
% % % clear htdiff3_40_90
% % % 
% % % htdiff3_90_190(:,:,pos)=htdiff_90_190;
% % % htdiff3_90_190(:,:,pos2)=htdiff2_90_190;
% % % htdiff_90_190=htdiff3_90_190;
% % % clear htdiff3_90_190
% % % 
% % % htdiff3_190_290(:,:,pos)=htdiff_190_290;
% % % htdiff3_190_290(:,:,pos2)=htdiff2_190_290;
% % % htdiff_190_290=htdiff3_190_290;
% % % clear htdiff3_190_290
% % % 
% % % htdiff3_290_450(:,:,pos)=htdiff_290_450;
% % % htdiff3_290_450(:,:,pos2)=htdiff2_290_450;
% % % htdiff_290_450=htdiff3_290_450;
% % % clear htdiff3_290_450
% % % 
% % % htdiff3_450_700(:,:,pos)=htdiff_450_700;
% % % htdiff3_450_700(:,:,pos2)=htdiff2_450_700;
% % % htdiff_450_700=htdiff3_450_700;
% % % clear htdiff3_450_700


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
tpxest_0_40=ones(length(lon_tpx),length(lat_tpx),ntime)*NaN;
tpxest_40_90=tpxest_0_40;
tpxest_90_190=tpxest_0_40;
tpxest_190_290=tpxest_0_40;
tpxest_290_450=tpxest_0_40;
tpxest_450_700=tpxest_0_40;

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
  
  
  
      tpxest_0_40(:,:,i)=sshave.*alpha_0_40;
      tpxest_40_90(:,:,i)=sshave.*alpha_40_90;
      tpxest_90_190(:,:,i)=sshave.*alpha_90_190;
      tpxest_190_290(:,:,i)=sshave.*alpha_190_290;
      tpxest_290_450(:,:,i)=sshave.*alpha_290_450;
      tpxest_450_700(:,:,i)=sshave.*alpha_450_700;
 
end % for years  
%%%%%%%%%%%%%%%%%%
%                %
%%%%%%%%%%%%%%%%%
%%
hc_tpx=ones(nlon_tpx,nlat_tpx,ntime).*NaN;
hc_tpx_total=zeros(nlon_tpx,nlat_tpx,ntime);

for ilayer=1:length(find(layer_bounds<=700))-1
    eval(['htdiff=htdiff_',num2str(layer_bounds(ilayer)),'_',num2str(layer_bounds(ilayer+1)),';'])
    eval(['tpxest=tpxest_',num2str(layer_bounds(ilayer)),'_',num2str(layer_bounds(ilayer+1)),';'])
    eval(['mask_layer=mask_',num2str(layer_bounds(ilayer)),'_',num2str(layer_bounds(ilayer+1)),';'])
    
for itime=1:ntime

    htdiff_junk=reshape(htdiff(:,:,itime),nlon,nlat);
    
corrhc=interp2(lat,lon,htdiff_junk,lat_tpx,lon_tpx);
corrhc(isnan(corrhc))=0;
 corrhc=corrhc+tpxest(:,:,itime);
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
hc_tpx(:,:,itime)=corrhc;


end

hc_tpx=greg_filter(hc_tpx,lon_tpx,lat_tpx);

hc_tpx=hc_tpx.*repmat(mask_layer,1,1,length(time));

eval(['hc_tpx_',num2str(layer_bounds(ilayer)),'_',num2str(layer_bounds(ilayer+1)),'=hc_tpx;'])
    
hc_tpx(~isfinite(hc_tpx))=0;
hc_tpx_total=hc_tpx_total+hc_tpx;


end

hc_tpx=hc_tpx_total;

clear hc_tpx_total

%%%%
%%%%

% this part of the code fits a line to each point in space


lat=lat_tpx;
lon=lon_tpx;
 arw=areavec(lon,lat);
 arw_time=repmat(arw,1,1,length(time));

hc_tpx_0_700=hc_tpx./arw_time;

save greg_tpxest_layers_half_2020.mat hc_tpx_0_700 hc_tpx_0_40 hc_tpx_40_90 hc_tpx_90_190 ...
    hc_tpx_190_290 hc_tpx_290_450 hc_tpx_450_700 lon lat time arw



load greg_tpxest_layers_half_2020.mat
lat_tpx=lat;
lon_tpx=lon;
nlat_tpx=length(lat_tpx);
nlon_tpx=length(lon_tpx);
slope=nans(nlon_tpx,nlat_tpx);
error=slope;
auto_corr_scale=slope;


toc
hc_tpx_0_90= hc_tpx_0_40+hc_tpx_40_90;
hc_tpx_90_290=hc_tpx_90_190+hc_tpx_190_290 ;
hc_tpx_290_700= hc_tpx_290_450+hc_tpx_450_700;
layer_names_trends={'0_700';'0_90';'90_290';'290_700'};
layer_names_trends={'0_700'}
% this might need to changed if j_fit doesn't work.
time=time';
time_or=time;

for ilayer_trend=1:length(layer_names_trends)
    eval(['hc_tpx=hc_tpx_',layer_names_trends{ilayer_trend},';']);
    heat_slope_file=['new2_slope_heat_2020_',num2str(year_of_oco_pub),'_tpx_',layer_names_trends{ilayer_trend}]
    % switched delyear to gregs notation
for del_year=5:max_trend_length
    
    for start_slope=slope_min_year:slope_max_year-del_year+1

        end_year=start_slope+del_year-1;

       
            time=time_or;
            good=find(time>=(start_slope +.5) & time<=(end_year+.5));
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
end
cd,original
toc

close all 
clear all
compute_greg_yearly_coverage_slope_multi_trends_half_2020