function plot_var_mean_diff(slope_ave_t,slope_rep_t,slope_map_t,time,min_time,max_time)


good_pos=find(time >= min_time & time <= max_time);

slope_ave_t=slope_ave_t(:,good_pos);
slope_map_t=slope_map_t(:,good_pos);
slope_rep_t=slope_rep_t(:,good_pos);


slope_ave_t1=slope_ave_t(1,:);
slope_ave_t2=slope_ave_t(2,:);
slope_ave_t3=slope_ave_t(3,:);
slope_ave_t4=slope_ave_t(4,:);
slope_ave_t5=slope_ave_t(5,:);

slope_map_t1=slope_map_t(1,:);
slope_map_t2=slope_map_t(2,:);
slope_map_t3=slope_map_t(3,:);
slope_map_t4=slope_map_t(4,:);
slope_map_t5=slope_map_t(5,:);

slope_rep_t1=slope_rep_t(1,:);
slope_rep_t2=slope_rep_t(2,:);
slope_rep_t3=slope_rep_t(3,:);
slope_rep_t4=slope_rep_t(4,:);
slope_rep_t5=slope_rep_t(5,:);


rep_diff1=slope_rep_t1-slope_ave_t1;
map_diff1=slope_map_t1-slope_ave_t1;


