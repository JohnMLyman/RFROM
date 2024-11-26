% makef3f5.m - matlab script to make figures 3 and 5 for the globahc paper
mycor = [

         0.88          0.31             0
         0.60             0             0
         0.30          0.31          0.99
            0          0.60          0.20
         0.28          0.77          0.96
         0.99          0.81             0
         1.00          0.20          0.80
         0.49          0.10          0.34
         0.60          0.60          0.60
         .7             .9             .2
         0             0             0];
     
     mycor=[27,158,119
217,95,2
117,112,179
231,41,138
124.9500,25.5000,86.7000]./255;

mycor=[228,26,28 
    55,126,184
    77,175,74
    152,78,163
    255,127,0
    55,78,0]./255;

% global integrals of heat content and storage
cd /Volumes/ThunderBay/Data/Globalhc/HC
min_year=2005;

max_year=2018;
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
load '/Volumes/ThunderBay/Data/OHCA_curves/total_uncertainty_paper_2015_0_700_1800_oco'  time_se total_se_0_700 samp_un_sd_700_1800 total_se_0_1800
del_time=max_year-2010-1;
time_se=[time_se' [2010.5:1:2010.5+del_time]];
hc_se=[total_se_0_700 repmat(total_se_0_700(end),1,del_time+1)];
hc_se_deep=[samp_un_sd_700_1800 repmat(samp_un_sd_700_1800(end),1,del_time+1)];

hc_se_total=[total_se_0_1800 repmat(total_se_0_1800(end),1,del_time+1)];


good_se=find(time_se>min_year);
hc_se=hc_se(good_se);
% good_se_deep=find(time_se>1992);
% hc_se_deep=hc_se_deep(good_se_deep);
%hc_se_deep=hc_se_deep(good_se);
%area of the earth used to compute w/m^2
area_of_earth=5.1e14;



cd ../HC/

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
file_name_argo='argo_2018_1_5_QC';
min_year_mapped='1990'; % the minimum year that was used to produce the OHCA fields.
max_year_mapped='2017';% the maximumyear that was used to produece the OHCA fields.

[~,time,~]=...
         heat_curv_gen_mat_2012_new_un_topo_new_layers(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(1),layer_bounds(2));
      hc_one=zeros(1,length(time));
    
      
      
      [~,time_SH,~]=...
         heat_curv_gen_mat_2012_new_un_topo_new_layers_SH(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(1),layer_bounds(2));
      hc_one_SH=zeros(1,length(time));
      
       
      [~,time_NH,~]=...
         heat_curv_gen_mat_2012_new_un_topo_new_layers_NH(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(1),layer_bounds(2));
      hc_one_NH=zeros(1,length(time));
      
for ilayer=2:length(layer_bounds)-1
 
    hc_one_junk=[];
     hc_one_junk_SH=[];
      hc_one_junk_NH=[];
     [hc,time,hc_one_junk]=...
         heat_curv_gen_mat_2012_new_un_topo_new_layers(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(ilayer-1),layer_bounds(ilayer));
     eval(['hc_one_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=hc_one_junk;'])
     
     [hc_SH,time_SH,hc_one_junk_SH]=...
      heat_curv_gen_mat_2012_new_un_topo_new_layers_SH(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(ilayer-1),layer_bounds(ilayer));
     eval(['hc_one_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'_SH=hc_one_junk_SH;'])
     
     
        [hc_NH,time_NH,hc_one_junk_NH]=...
     heat_curv_gen_mat_2012_new_un_topo_new_layers_NH(['hdata_new_layers__ishii_EN3_2014_',file_name_argo,...
         min_year_mapped,'_',max_year_mapped,'_'],...
         layer_bounds(ilayer-1),layer_bounds(ilayer));
     eval(['hc_one_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'_NH=hc_one_junk_NH;'])
     
      hc_one_SH=hc_one_junk_SH+hc_one_SH;
       hc_one_NH=hc_one_junk_NH+hc_one_NH;
     
         hc_one=hc_one_junk+hc_one;
     
end

% % %  [hc,time,hc_one_100]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_100_real',0,100);
% % % [hc,time,hc_one_100_300]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_100_300_real',100,300);
% % %  [hc,time,hc_one_300_700]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_300_700_real',300,700);
% % %  [hc,time,hc_one_700_900]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_900_real',700,900);
% % %  [hc,time,hc_one_900_1800]=heat_curv_gen_mat_2012_new_un_topo('hdata_new__ishii_EN3_2014_pfloat_sal_greg_jan_2016_QC1992_2015_1800_real',900,1800);
% % % 
% % %  save '/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ohca_1992_2015_curve_100_300_700_900_1800_jan_2016' time hc_one_100 hc_one_100_300 hc_one_300_700 hc_one_700_900 hc_one_900_1800
%%%%load '/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ohca_1992_2015_curve_100_300_700_900_1800_jan_2016' time hc_one_100 hc_one_100_300 hc_one_300_700 hc_one_700_900 hc_one_900_1800

% % % load '/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/ohca_1950_2015_curve_100_300_700_900_1800_jan_2016' time hc_one_100 hc_one_100_300 hc_one_300_700 hc_one_700_900 hc_one_900_1800


% 
% hc_one=hc_one_100+hc_one_100_300+hc_one_300_700;
%  
% 
%  hc_one_deep=(hc_one_700_900+hc_one_900_1800)./1e21;
 time_deep=time;
good_se_deep=find(time_se>= min(time_deep));
hc_se_deep=hc_se_deep(good_se_deep);
 % this is just a place holder
% % %  ntime_deep=length(time_deep);
% % %  nhc_se=length(hc_se);
% % %  hc_se_deep=[repmat(hc_se(1),[1,ntime_deep-nhc_se]),hc_se]./2;

%subsect all and put into Zeta joules
cd ../SAL/Floats

good_pos=find(time >= min_year & time <=max_year);

% hc_one=hc_one2';


time=time(good_pos);
hc_one=hc_one(good_pos)/1e21;
hc_one_SH=hc_one_SH(good_pos)/1e21;
hc_one_NH=hc_one_NH(good_pos)/1e21;


hc_pmel=hc_one;
hc_pmel_NH=hc_one_NH;
hc_pmel_SH=hc_one_SH;
