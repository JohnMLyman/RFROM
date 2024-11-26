 function [per_out,alon,alat]=obs_in_winter_map(iyear)
load allheat
 clear per_south per_north len_south len_north
%for iyear=start_year:end_year
    

    
year=dt(:,1);
month=dt(:,2);
lat=cds(:,2);
lon=cds(:,1);

if (iyear==1993)
good_time=find((year <= 2003) & (year >= 1993));
else  good_time=find(year == 2004);
end 
good_month=month(good_time);
good_lat=lat(good_time);
good_w=wnum(good_time);
good_cds=cds(good_time,:);

north=find(good_lat >=0);
south=find(good_lat <=0);


month_north=good_month(north);
w_north=good_w(north);
cds_north=good_cds(north,:);

w_north_u=unique(w_north);

for iw=1:length(w_north_u)

    pos_north=find(w_north == w_north_u(iw));
    
    good_w_month_north=month_north(pos_north);
    
   north_winter=month_north(find(good_w_month_north == 1 | good_w_month_north ==2 | good_w_month_north == 12));

   
   len_north(iw)=length(good_w_month_north);
   per_north(iw)=length(north_winter)./(length(good_w_month_north)./4);

end


month_south=good_month(south);

w_south=good_w(south);
cds_south=good_cds(south,:);

w_south_u=unique(w_south);

for iw=1:length(w_south_u)

    pos_south=find(w_south == w_south_u(iw));
    
    good_w_month_south=month_south(pos_south);
    
   south_winter=month_south(find(good_w_month_south == 6 | good_w_month_south ==7 | good_w_month_south == 8));

   
   
   per_south(iw)=length(south_winter)./(length(good_w_month_south)./4);
   len_south(iw)=length(good_w_month_south);
end


cds_in=[cds_north',cds_south']';
w_in=[w_north',w_south'+10000]';
per_in=[per_north,per_south];
len_in=[len_north,len_south];

[per_out,alat,alon]=j_grid_alpha(per_in,cds_in,w_in,len_in);
load landmask msk2
per_out(isnan(msk2(2:end-1,:)))=NaN;


%end