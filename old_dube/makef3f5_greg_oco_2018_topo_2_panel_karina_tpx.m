
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

[~,time,~]=...
         heat_curv_gen_mat_topo_new_layers_karina_tpxest(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],file_name_argo,...
         layer_bounds(1),layer_bounds(2));
      hc_one=zeros(1,length(time));
      hc_one_deep=hc_one;
for ilayer=2:length(layer_bounds)
 
    hc_junk=[];
    area_junk=[];
     [hc_junk,time,area_junk]=...
         heat_curv_gen_mat_topo_new_layers_karina_tpxest(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],file_name_argo,...
         layer_bounds(ilayer-1),layer_bounds(ilayer));
     eval(['hc_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=hc_junk./1e21;'])
     eval(['area_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=area_junk;'])
    
end



