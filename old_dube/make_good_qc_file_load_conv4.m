
path='/Users/johnlyman/data/';
cd /Users/johnlyman/data/Globalhc
cd /Users/johnlyman/data/Globalhc/WOD05/


e=sdir('./*1993*conv4.mat');
dn=strvcat(e(:).name);
ii=find(dn(:,1)=='X');e(ii)=[];
num_el_e=length(e);
time_total=[];
coords_total=[];
dt_total=[];
mdep_total=[];

for i=1:num_el_e
    e(i).name
   eval(['load ',e(i).name,' coords dt time']) 
    
    time_total=[time_total; time];
    coords_total=[coords_total ; coords];
    dt_total=[dt_total;dt];
   
    
    
end


% save position_time_good_qc time_total coords_total dt_total

% save position_time_good_qc_shallow_d_test2 time_total coords_total dt_total
% cd(current_dir);