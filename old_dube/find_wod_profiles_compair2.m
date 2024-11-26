path='/Users/johnlyman/data/';
cd /Users/johnlyman/data/Globalhc
cd /Users/johnlyman/data/Globalhc/HC


current_dir=cd('./All_Data/qc');

load position_time_good_qc


cd /Users/johnlyman/data/Globalhc/wod05
load '/Users/johnlyman/data/Globalhc/HC/All_Data/allheat_700_junk4'

 good=find(dt(:,1) ==1998);
 dt_total=dt(good,:);
 coords_total=cds(good,:);
 ht_total=ht(good);
 time_total=tm(good);
 wnum_total=wnum(good);

load 'allheat_wod_100_300_700_900_1800_march_23_2011_all2'

n_total=length(time_total);
good_pos=nans(1,n_total);


tt_wod=[dt_wod(:,1),dt_wod(:,2),dt_wod(:,3),coords_wod(:,1),coords_wod(:,2),time_wod];
tt_total=[dt_total(:,1),dt_total(:,2),dt_total(:,3),coords_total(:,1),coords_total(:,2),time_total];


[J,good_pos_total,good_pos_wod]=intersect(tt_total,tt_wod,'rows');



