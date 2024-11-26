
% global integrals of heat content and storage
cd /Volumes/ThunderBay/Data/Globalhc/HC
min_year=1993;
min_year_deep=1993;
max_year=2019;
max_year_deep=2019;
%load in error bars
% 
% load '/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve'
% 
% hc_se=[ohca_se ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end)]*10;
% hc_se=[repmat(hc_se(1),[1,26]),hc_se];
% 
% 
% time_se=[1967.5:2015.5];
% % 
% % % load '/Volumes/ThunderBay/Data/OHCA_curves/total_uncertainty_paper_2015_0_700_1800_oco'  time_se total_se_0_700 samp_un_sd_700_1800 total_se_0_1800
% % % del_time=max_year-2010-1;
% % % time_se=[time_se' [2010.5:1:2010.5+del_time]];
% % % hc_se=[total_se_0_700 repmat(total_se_0_700(end),1,del_time+1)];
% % % hc_se_deep=[samp_un_sd_700_1800 repmat(samp_un_sd_700_1800(end),1,del_time+1)];
% % % 
% % % hc_se_total=[total_se_0_1800 repmat(total_se_0_1800(end),1,del_time+1)];
% % % 
% % % 
% % % good_se=find(time_se>min_year);
% % % hc_se=hc_se(good_se);
% good_se_deep=find(time_se>1992);
% hc_se_deep=hc_se_deep(good_se_deep);
%hc_se_deep=hc_se_deep(good_se);
%area of the earth used to compute w/m^2
% area_of_earth=5.1e14;



cd ../HC/

 layer_bounds=[0,300,700,2000];
file_name_argo='argo_2019_4_16_QC';
min_year_mapped='1960'; % the minimum year that was used to produce the OHCA fields.
max_year_mapped='2018';% the maximumyear that was used to produece the OHCA fields.

layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
file_name_argo='argo_2018_12_6_QC';
min_year_mapped='1950'; % the minimum year that was used to produce the OHCA fields.
max_year_mapped='2019';% the maximumyear that was used to produece the OHCA fields.

file_name_argo='argo_2019_1_06_QC';
min_year_mapped='1990'; % the minimum year that was used to produce the OHCA fields.
max_year_mapped='2019';% the maximumyear that was used to produece the OHCA fields.


[~,time,~,~,~]=...
         heat_curv_gen_mat_topo_new_layers_karina_lat(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(1),layer_bounds(2),-60,60);
      hc_one_0_290=zeros(1,length(time));
      hc_one_0_700=hc_one_0_290;
      hc_one_0_2000=hc_one_0_290;
      hc_one_700_2000=hc_one_0_290;
      vol_0_290=hc_one_0_290;
      vol_0_700=hc_one_0_290;
      vol_0_2000=hc_one_0_290;
      vol_700_2000=hc_one_0_290;

      pos_1960_2018=find(time >1960 & time<2019); %note that time is on the half year so this only goes 2018 not 2019 for the mean
      pos_1993_2018=find(time >1993 & time<2019);
      pos_2005_2018=find(time >2005 & time<2019);
for ilayer=2:length(layer_bounds)
 
    hc_one_junk=[];
    area_junk=[];
     [hc,time,hc_one_junk,~,area_junk]=...
         heat_curv_gen_mat_topo_new_layers_karina_lat(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(ilayer-1),layer_bounds(ilayer),-60,60);
     hc_one_junk=hc_one_junk./1e21;
     
    
     
     
%       eval(['hc_one_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),'_1960_2019_60_60=hc_one_junk-nanmean(hc_one_junk(pos_1960_2017));'])
%       eval(['hc_one_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),'_1993_2019_60_60=hc_one_junk-nanmean(hc_one_junk(pos_1993_2017));'])
%       eval(['hc_one_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),'_2005_2019_60_60=hc_one_junk-nanmean(hc_one_junk(pos_2005_2017));'])
     
      layer_bounds(ilayer)
     if layer_bounds(ilayer)<= 290
         hc_one_0_290=hc_one_junk+hc_one_0_290;
         vol_0_290=vol_0_290+area_junk*(layer_bounds(ilayer)-layer_bounds(ilayer-1));
         ['0-290 :',num2str(layer_bounds(ilayer-1)),'-',num2str(layer_bounds(ilayer))]
         
     end
     if layer_bounds(ilayer)<= 700
         hc_one_0_700=hc_one_junk+hc_one_0_700;
         vol_0_700=vol_0_700+area_junk*(layer_bounds(ilayer)-layer_bounds(ilayer-1));

         ['0-700 :',num2str(layer_bounds(ilayer-1)),'-',num2str(layer_bounds(ilayer))]
     end
     if layer_bounds(ilayer)<= 2000
         hc_one_0_2000=hc_one_junk+hc_one_0_2000;
         vol_0_2000=vol_0_2000+area_junk*(layer_bounds(ilayer)-layer_bounds(ilayer-1));

         ['0-2000 :',num2str(layer_bounds(ilayer-1)),'-',num2str(layer_bounds(ilayer))]
     end
     if layer_bounds(ilayer-1)>= 700
         hc_one_700_2000=hc_one_junk+hc_one_700_2000;
         vol_700_2000=vol_700_2000+area_junk*(layer_bounds(ilayer)-layer_bounds(ilayer-1));

         ['700-2000 :',num2str(layer_bounds(ilayer-1)),'-',num2str(layer_bounds(ilayer))]
     end
    
end


% hc_one_0_700_1960_2018_60_60=hc_one_0_300_1960_2018_60_60+hc_one_300_700_1960_2018_60_60;
% hc_one_0_700_1993_2018_60_60=hc_one_0_300_1993_2018_60_60+hc_one_300_700_1993_2018_60_60;
% hc_one_0_700_2005_2018_60_60=hc_one_0_300_2005_2018_60_60+hc_one_300_700_2005_2018_60_60;
% hc_one_0_2000_2005_2018_60_60=hc_one_0_300_2005_2018_60_60+hc_one_300_700_2005_2018_60_60+hc_one_700_2000_2005_2018_60_60;


pos_1960_2019=find(time >1960 & time<2020); %now time will go to 2019
pos_1993_2019=find(time >1993 & time<2020);
pos_2005_2019=find(time >2005 & time<2020);


time_1960_2019=time(pos_1960_2019);
time_1993_2019=time(pos_1993_2019);
time_2005_2019=time(pos_2005_2019);

area_0_290=vol_0_290(pos_1960_2019)./290;
area_0_700=vol_0_700(pos_1960_2019)./700;
area_0_2000=vol_0_2000(pos_1960_2019)./2000;
area_700_2000=vol_700_2000(pos_1960_2019)./(2000-700);

hc_one_0_290_1960_2019_60_60=hc_one_0_290(pos_1960_2019)-nanmean(hc_one_0_290(pos_1960_2018));
hc_one_0_700_1960_2019_60_60=hc_one_0_700(pos_1960_2019)-nanmean(hc_one_0_700(pos_1960_2018));

hc_one_0_290_1993_2019_60_60=hc_one_0_290(pos_1993_2019)-nanmean(hc_one_0_290(pos_1993_2018));
hc_one_0_700_1993_2019_60_60=hc_one_0_700(pos_1993_2019)-nanmean(hc_one_0_700(pos_1993_2018));

hc_one_0_290_2005_2019_60_60=hc_one_0_290(pos_2005_2019)-nanmean(hc_one_0_290(pos_2005_2018));
hc_one_0_700_2005_2019_60_60=hc_one_0_700(pos_2005_2019)-nanmean(hc_one_0_700(pos_2005_2018));
hc_one_0_2000_2005_2019_60_60=hc_one_0_2000(pos_2005_2019)-nanmean(hc_one_0_2000(pos_2005_2018));
hc_one_700_2000_2005_2019_60_60=hc_one_700_2000(pos_2005_2019)-nanmean(hc_one_700_2000(pos_2005_2018));

save karina_ohca_60n_60S_new_2019.mat hc_one_0_290_1960_2019_60_60 hc_one_0_700_1960_2019_60_60 ...
    hc_one_0_290_1993_2019_60_60 hc_one_0_700_1993_2019_60_60 ...
    hc_one_0_290_2005_2019_60_60 hc_one_0_700_2005_2019_60_60 ...
    hc_one_700_2000_2005_2019_60_60 hc_one_0_2000_2005_2019_60_60...
    time_1960_2019 time_1993_2019 time_2005_2019...
    area_0_290 area_0_700 area_0_2000 area_700_2000







