
path='/Users/johnlyman/data/';
cd /Users/johnlyman/data/Globalhc
cd /Users/johnlyman/data/Globalhc/HC


current_dir=cd('./All_Data/qc');

e=sdir('./e*.mat');

num_el_e=length(e);
time_total=[];
coords_total=[];
dt_total=[];
mdep_total=[];
for i=1:num_el_e
    e(i).name
   eval(['load ',e(i).name,' coords dt time mdep']) 
    
    time_total=[time_total; time];
    coords_total=[coords_total ; coords];
    dt_total=[dt_total;dt];
    mdep_total=[mdep_total;mdep];
    
    
end


% save position_time_good_qc time_total coords_total dt_total

save position_time_good_qc_shallow time_total coords_total dt_total
cd(current_dir);