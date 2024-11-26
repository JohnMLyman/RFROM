 
 

year=dt(:,1);
month=dt(:,2);


good_time=find(year == iyear);

good_month=month(good_time);
good_lat=lat(good_time);

north=find(good_lat >=0);
south=find(good_lat <=0);

subplot(2,1,1)


hist(good_month(north),24)

title([num2str(iyear),' north'])

subplot(2,1,2)

hist(good_month(south),24)

title([num2str(iyear),' south'])