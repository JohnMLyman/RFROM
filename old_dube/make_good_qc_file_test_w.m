
path='/Users/johnlyman/data/';
cd /Users/johnlyman/data/Globalhc
cd /Users/johnlyman/data/Globalhc/HC



cd /Users/johnlyman/data/Globalhc/HC/WOD05/junk2
e=sdir('jw*.mat');
nprofile=6685658*1.5;
num_el_e=length(e);
time_total=nans(nprofile,1);
coords_total=nans(nprofile,2);
dt_total=nans(nprofile,3);
mdep_total=nans(nprofile,1);

iend=0;
total_np=[];
for ifi=1:num_el_e
    e(ifi).name
   eval(['load ',e(ifi).name,' coords dt time mdep temp']) 
    
   njunk=length(time);
   istart=iend+1;
   iend=istart+njunk-1;
   total_np
   tempj=nansum(temp,2);
   missing=find(isfinite(tempj)==0);
   coords(missing,:)=NaN;
    time_total(istart:iend)=time;
    coords_total(istart:iend,:)=coords;
    dt_total(istart:iend,:)=dt;
    mdep_total(istart:iend)=mdep;
    
    
end
good=find(isfinite(mdep_total));
mdep_total=mdep_total(good);
coords_total=coords_total(good,:);
dt_total=dt_total(good,:);
time_total=time_total(good);


% save position_time_good_qc time_total coords_total dt_total
cd /Users/johnlyman/data/Globalhc/HC


current_dir=cd('./All_Data/qc/test');
%save position_time_good_qc_shallow_w_test time_total coords_total dt_total mdep_total
cd(current_dir);