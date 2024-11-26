start_year=2010
end_year=2012
start_year_ssh=floor(start_year);
if floor(start_year)==start_year
    start_year_ssh=start_year-1;
end
end_year_ssh=floor(end_year);
time_ssh_load=start_year_ssh:end_year_ssh;

ntotal_time=length(time_ssh_load);



for iyear=1:ntotal_time

    year_load=time_ssh_load(iyear); 

    if year_load == start_year-.5
        start_year_mod = start_year;
    elseif year_load== start_year-1
        start_year_mod=year_load+1;
    else
        start_year_mod=year_load;
    end
    
    if year_load == end_year-.5
        end_year_mod=year_load+.5;
    elseif year_load == end_year
        end_year_mod=year_load;
    else
        end_year_mod=year_load+1;
    end
    
    [year_load,start_year_mod,end_year_mod]

end