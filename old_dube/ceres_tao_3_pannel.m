year_of_oco_pub=2017; %  NEED TO CHANGE year_of_oco_pub OR TREND WONT CHANGE AND PLOTS WILL BE WRITEN OVER
%      need to make sure that 
%      heat_slope_file=['slope_heat_',num2str(year_of_oco_pub),'_insitu_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)];
%      has been errased if you want the slope to be recomputed
layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
file_name='argo_2017_1_3_QC' % NEED TO CHANGE TO MATCH OCO_MAPS_2016_2 
depth_top_plot=0;
depth_bot_plot=700;
slope_min_year=1993;

[alat,alon,alpha]=load_layer_alpha(file_name,layer_bounds,depth_top_plot,depth_bot_plot);
cd /Volumes/ThunderBay/Data/Globalhc/SAL/Floats/
eval(['load  ../../Mtpers/meanssh_oco_realtime_',file_name,'  lat lon gmo sshcyc '])

%load ../../Mtpers/meanssh_oco_realtime_2013 lat lon sshcyc gmo

lat_tpx=lat;
lon=lon';
lon_tpx=[lon(721:end)-360;lon(1:720)];
sshcyc=[sshcyc(721:end,:,:);sshcyc(1:720,:,:)];

clear lon lat

alpha=interp2(alat,alon,alpha,lat_tpx,lon_tpx);


%% NEED TO CHANGE 2015 AND 2016 TO MATHC THE YEARS THAT ARE BEING PLOTED
for fyear=2015:2016;

scale_fac_rate=1;  % Half the sclae for rate
scale_fac=1;  % half the scale for magnitude
syear=fyear-1;


if syear==1992 
    syear=fyear
end

cold_to_hot_colormap=[[1,146,191]'/255,[255,255,255]'/255,[251,0,38]'/255]';
cold_to_hot_colormap=interp1([0:1/2:1],cold_to_hot_colormap,[0:1/255:1]);
cold_to_hot_colormap=diverging_map([0:1/200:1],[20 43 140]/255,[204 0 51]/255);


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

 
[lat,lon,ht,htdiff,one,time,tpx]=load_layer_OHCA('hdata_new_layers__ishii_EN3_2014_argo_2016_12_5_QC1995_2016_',layer_bounds,depth_top_plot,depth_bot_plot);


%load ../../HC/hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1950_2015_100_real

%htdiff=ht;
ind_2008=find(time == fyear+.5);
ht_2008=htdiff(:,:,ind_2008)./1e9;
%ht_2008=ht(:,:,ind_2008)./1e9;
one_2008=one(:,:,ind_2008);


ind_2007=find(time ==  syear+.5);

ht_2007=htdiff(:,:,ind_2007)./1e9;
one_2007=one(:,:,ind_2007);



ind_all=find(time>1993 & time <2017);
ht_all=(htdiff(:,:,ind_all))./1e9;
tgrid=[1993.5:1:2016.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load in the in the Aviso estimate %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 


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
  
  
  if tgrid(i) == syear+.5
       tpxest_2007=sshave.*alpha/1e9;
  end % if 2007
  
  if tgrid(i) == fyear+.5
      
      tpxest_2008=sshave.*alpha/1e9;
      
  end % if 2008
  
end % for years  
%% 
% ht_2008=ht_2008_100+ht_2008_100_300+ht_2008_300_700;
% ht_2007=ht_2007_100+ht_2007_100_300+ht_2007_300_700;
  
  
tpxest_change=(tpxest_2008-tpxest_2007);
ht_change=(ht_2008-ht_2007);

tpxest_all=nanmean(ssh_total_mean,3).*(alpha)./1e9;



ht_all_mean=nanmean(ht_all,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s
%%%                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


lon2=lon;
 lat2=lat;


%i=3


%corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx');
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
%corrhc(isnan(sshmean))=NaN;


% plot the heat content for 2008
figure(1);wysiwyg;orient tall
set(gcf,'color','white');
m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
subplot(3,1,1)

lon=lon2;
lat=lat2;

corrhc=interp2(lat,lon,ht_all_mean,lat_tpx',lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc=corrhc+tpxest_all;
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
ht_1993_2010_mean=corrhc;

corrhc=interp2(lat,lon,ht_2008,lat_tpx',lon_tpx');
corrhc(isnan(corrhc))=0;
corrhc=corrhc+tpxest_2008;
%corrhc(isnan(msk2(2:end-1,:)))=NaN;

corrhc=corrhc-ht_1993_2010_mean;

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-3./scale_fac;
max_val=3./scale_fac;
del_val=.5./scale_fac;
del_cont=.25./scale_fac;
ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(cold_to_hot_colormap) 


m_proj('Equidistant cylindrical','long',[30 390],'lat',[-90 90]);
%colormap(fresh_to_salty_colormap) 
[cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'ytick',[-90:30:90],'linestyle','none','xticklabel',[]);


%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
a=gca;
hold on
m_coast('patch',[1 1 1]);
t1=m_text(30,100,['(a) ', num2str(fyear)],'fontsize',12);
t3=m_text(50,45,[num2str(depth_top_plot),'-',num2str(depth_bot_plot)],'fontsize',12);
t2=m_text(320,-105,'[10^9 J m ^{-2}]','fontsize',12);

caxis([min_val max_val-del_cont])

hold off

ja=axes('pos',[.262 .90-.0475 .51 .01]);
%colormap jet(256)

colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(ja,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
%xlabel('Upper Ocean Heat Content Anomaly [J m ^{-2} x 10^9]')



% plot the heat content change of 2008-2007
subplot(3,1,2)
lon=lon2;
lat=lat2;


corrhc=interp2(lat,lon,ht_change,lat_tpx,lon_tpx);
corrhc(isnan(corrhc))=0;

corrhc=(corrhc+tpxest_change).*1e9./((60*60*24*365.5));

lon=lon_tpx;
lat=lat_tpx;


% put into the proper coordinates
min_val=-95./scale_fac_rate;
max_val=95./scale_fac_rate;
del_val=10./scale_fac_rate;
del_cont=10./scale_fac_rate;
ii=find(lon<30);
jj=find(lon>=30); 
lon=[lon(jj);lon(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];
%colormap jet(256)

colormap(cold_to_hot_colormap)

[cs1,h1]=m_contourf(lon,lat,corrhc',[-1000,min_val:del_cont:max_val]);

hold on
set(h1,'linecolor','none')
hold on
m_grid('tickdir','out','xtick',[30:30:390],'xticklabel',[],'ytick',[-90:30:90],'linestyle','none');


%[cs12,h12]=m_contour(lon_cont,lat_cont,sal_cont',[32 32],'k');
b=gca;
hold on
m_coast('patch',[1 1 1]);
t1=m_text(30,100,['(b) ' num2str(fyear) '-' num2str(syear)],'fontsize',12);
t2=m_text(320,-105,['[W m ^{-2}]'],'fontsize',12);

% subplot deletes hadle of the axis
caxis([min_val max_val-del_cont])

jb=axes('pos',[.262 .10+.06 .51 .01]);
colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')
set(jb,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[])
caxis([min_val max_val-del_cont])
xlabel('1-year Heat Content Change [W m ^{-2}]')

% subplot deletes hadle of the axis in
% greg_map_hc_20_year_2016_instu_scatter_plot this next line make sure that
% the axis max and min are correct


mmin_val=min_val;
mmax_val=max_val;
mdel_val=del_val;
mdel_cont=del_cont;

greg_map_hc_20_year_tpx_scatter_plot_oco

min_val=mmin_val;
max_val=mmax_val;
del_val=mdel_val;
del_cont=mdel_cont;

hold off
jb=axes('pos',[.262 .10+.06 .51 .01]);
colormap(cold_to_hot_colormap) 

[cs,h]=contourf([min_val:.01:max_val],[0 1],[1 1]'*[min_val:.01:max_val],[min_val:del_cont:max_val]);
set(h,'edgecolor','none')

tt=cellstr(num2str([min_val:del_val:max_val]'));
%tt{2}=[''];tt{4}=[''];tt{6}=[''];tt{8}=[''];tt{10}=[''];tt{11}=[''];tt{13}=[''];tt{15}=[''];tt{17}=[''];tt{19}=[''];
tt{1}=[''];tt{3}=[''];tt{5}=[''];tt{7}=[''];tt{9}=[''];tt{12}=[''];tt{14}=[''];tt{16}=[''];tt{18}=[''];tt{20}=[''];

set(jb,'tickdir','out','xaxisl','top','xtick',[min_val:del_val:max_val],'ytick',[],'XtickLabel',tt)
caxis([min_val max_val-del_cont])
%xlabel('1-year Heat Content Change [W m ^{-2}]')


%%%%sort the polots

apos=get(a,'pos');
bpos=get(b,'pos');
cpos=get(c,'pos');
japos=get(ja,'pos');
jbpos=get(jb,'pos');
jcpos=get(jc,'pos');


set(a,'pos',apos+[0 .016 0 .03])
set(b,'pos',bpos+[0 0 0 .03])
set(c,'pos',cpos+[0 -.02 0 .03])

set(ja,'XAxisLocation','bottom','pos',japos-[-.075 .155 .15 0])
set(jb,'XAxisLocation','bottom','pos',jbpos-[-.075 -.225 .15 0])
set(jc,'XAxisLocation','bottom','pos',jcpos-[-.075 .805 .15 0])

%%% print plot
wysiwyg;orient tall
eval(['print -dpng -f1 /Users/lyman/Documents/figs/oco/Oceans/oco_heat_',num2str(year_of_oco_pub),'_web_3_pannel_tpx_',num2str(fyear),'_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)])
close(1)
end