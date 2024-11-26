%d=sdir(['den_den_no_f*.mat']);
d=sdir(['grad_den_0_grid_aden_den_no_*.mat']);
d=sdir(['wod_den_*.mat']);
mdep_total=[];dt_total=[]; coords_total=[];
for i=1:length(d)
    
    
    


if (exist([d(i).name]) & exist(['ind_',d(i).name]))
        
            eval(['load ',d(i).name,' coords mdep dt']);
            eval(['load ind_',d(i).name,' bad_total']);

            % subsect the good files.
            coords(bad_total,:)=[];
            mdep(bad_total)=[];
            
            dt(bad_total,:)=[];
            
else eval(['load ',d(i).name,' mdep coords dt'])

end % if           

d(i).name
mdep_total=[mdep_total',mdep']';    
coords_total=[coords_total',coords']';  
dt_total=[dt_total',dt']';

end
