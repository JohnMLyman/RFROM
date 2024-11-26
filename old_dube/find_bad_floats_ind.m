

 % 
  file_WOD_suf='_ishii_EN3_2013'
 path_EN3='/Volumes/Data/EN3/ishiiXBTMBT_2013/';
% 

 
file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_jan_2013'
file_name='pfloat_sal_greg_dec_2013_2_1_new'

file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'


'map'
clearvars -except file_WOD_suf file_path file_path_out file_name file_path_hdata max_year min_year path_EN3
 file_WOD_suf='_ishii_EN3_2013'
 path_EN3='/Volumes/Data/EN3/ishiiXBTMBT_2013/';

 f=['hdata_new_',file_WOD_suf,'_',file_name];
 file_new=['hdata_new_no_ind_',file_WOD_suf,'_',file_name];
 cd(file_path_hdata);
 load(f);
yr_in=floor(yr);
pos_2013=find(yr_in==2013);

pos_bad_2013=find(((coords(:,2)>=-24 & coords(:,2)<=-18) &(coords(:,1)>=-70.5 & coords(:,1)<=-66) & yr_in==2013));
coords_old=coords;
yr_old=yr;
ht_1800_old=ht_1800;
coords(pos_bad_2013,:)=[];



ht_100(pos_bad_2013,:)=[];
ht_100_300(pos_bad_2013,:)=[];
ht_1800(pos_bad_2013,:)=[];
ht_300(pos_bad_2013,:)=[];
ht_300_700(pos_bad_2013,:)=[];
ht_700(pos_bad_2013,:)=[];
ht_900(pos_bad_2013,:)=[];
htdiff_100(pos_bad_2013,:)=[];
htdiff_100_300(pos_bad_2013,:)=[];
htdiff_1800(pos_bad_2013,:)=[];
htdiff_300(pos_bad_2013,:)=[];
htdiff_300_700(pos_bad_2013,:)=[];
htdiff_700(pos_bad_2013,:)=[];
htdiff_900(pos_bad_2013,:)=[];
tpx(pos_bad_2013,:)=[];
yr(pos_bad_2013,:)=[];


eval(['save ',file_new,' coords ht_100 ht_100_300 ', ...
    'ht_1800 ht_300 ht_300_700 ht_700 ht_900 htdiff_100 htdiff_100_300 htdiff_1800 htdiff_300 htdiff_300_700 ', ...
    'htdiff_700 htdiff_900 tpx yr']);



map_ht_1800_900_700_300_100_EN3_junk_2014_no_ind