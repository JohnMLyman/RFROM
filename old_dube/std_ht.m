clear
load allheat
start_year=1955
end_year=2005
for iyear =start_year:end_year
    
    good_points=find(dt(:,1)== iyear);
    ht_iyear=htanom(good_points);
    real_ht=find(finite(ht_iyear)== 1);
    good_pos=good_points(real_ht);
    ht_iyear=ht_iyear(real_ht);
    std_iyear=std(ht_iyear);
    
    std_plot(iyear-start_year+1)=3.4e14*std_iyear;
    time(iyear-start_year+1)=iyear;
end

plot(time,student(3e3)*std_plot/sqrt(3e3))