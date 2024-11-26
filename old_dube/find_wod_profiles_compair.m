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

% for i=1:n_total
% i,n_total
% good2=ismember(dt_wod(:,1),dt_total(i,1)) & ismember(dt_wod(:,2),dt_total(i,2))& ismember(dt_wod(:,3),dt_total(i,3))...
%     &ismember(coords_wod(:,1),coords_total(i,1))&ismember(coords_wod(:,2),coords_total(i,2))...
%     &ismember(time_wod,time_total(i));

tt_wod=dt_wod(:,1)+dt_wod(:,2)*(1e3)+dt_wod(:,3)*(1e3+1e3)+coords_wod(:,1)*(1e3+1e3+1e3)+coords_wod(:,2)*(1e3+1e3+1e3+1e3)+time_wod*(1e12+1e3);
tt_total=dt_total(:,1)+dt_total(:,2)*(1e3)+dt_total(:,3)*(1e3+1e3)+coords_total(:,1)*(1e3+1e3+1e3)+coords_total(:,2)*(1e3+1e3+1e3+1e3)+time_total*(1e12+1e3);


good_pos_wod=ismember(dt_wod(:,1),dt_total(:,1)) & ismember(dt_wod(:,2),dt_total(:,2))& ismember(dt_wod(:,3),dt_total(:,3))...
    &ismember(coords_wod(:,1),coords_total(:,1))&ismember(coords_wod(:,2),coords_total(:,2))...
    &ismember(time_wod,time_total)&ismember(tt_wod,tt_total);

good_pos_total=ismember(dt_total(:,1),dt_wod(:,1)) & ismember(dt_total(:,2),dt_wod(:,2))& ismember(dt_total(:,3),dt_wod(:,3))...
    &ismember(coords_total(:,1),coords_wod(:,1))&ismember(coords_total(:,2),coords_wod(:,2))...
    &ismember(time_total,time_wod)&ismember(tt_total,tt_wod);

% a=find(good2 ==1);
% 
% if ~isempty(a)
% good_pos(i)=find(good2 == 1);
% end
% 
% end
