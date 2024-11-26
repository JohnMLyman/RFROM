function [cds_atl,pos_good_atl,cds_pac,pos_good_pac,cds_ind,pos_good_ind]=find_basin_allheat(cds)

%           inputs 
%  lat(nlat) -90 to 90
%  lon(nlon) -180 to 180
%  sss(nlon,nlat)

%       Output (points outside the basin are set to NaN)
%
%   sss_ataltic(nlon,nlat) 
%   sss_pacific(nlon,nlat)
%   sss_indian(nlon,nlat)
%
% Note always plot the basins, and the whole globe to make sure it makes
% sense!!
lat2=cds(:,2);
lon2=cds(:,1);


pos=[1:length(lat2)];


% Indian Ocean

% less than lon mask (Indian)

pos_mask=find(lon2 <= 20 & lat2 <= 31) ;
pos_bad=[pos_mask];

pos_mask=find(lat2 >=30.7);
pos_bad=[pos_mask; pos_bad];



% greater than lon mask (Indian)

pos_mask=find(lon2 >146 & lat2 <=-22 & lon2 >=-68) ;
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_gt_lon(130,-22,127,-3,0,200,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_gt_lon(130,-22,127,-3,0,200,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_gt_lon(102.01,-3,102,5.5,0,200,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_gt_lon(102,5.5,98.5,9.6,0,200,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

pos_mask=find(lon2>= 99 & lon2<= 2000 & lat2 >= 9.6);
pos_bad=[pos_mask; pos_bad];

pos_mask=find(lon2 >=113 & lon2 <=180 & lat2>=5 & lat2<=6);
pos_bad=[pos_mask; pos_bad];

pos_mask=find(lon2 >=142 & lon2 <=180 & lat2>=-4 & lat2<=-2);
pos_bad=[pos_mask; pos_bad];
% subsect data


cds_ind=cds;
cds_ind(pos_bad,:)=[];

pos_good_ind=pos;
pos_good_ind(pos_bad)=[];



% Pacific Ocean

%Greater than lon mask

pos_mask=find(lon2 >= -60 & lat2 >= -22 & lon2 <= 98& lat2<=60);
pos_bad=pos_mask;

[pos_mask]=mask_gt_lon(-60,-6,-79,9,-80,0,lon2,lat2);
pos_bad=[pos_mask; pos_bad];
%pos_bad=pos_mask;

pos_mask=find(lon2>=-79 & lon2 <= 0 & lat2 >=9 & lat2 <=60);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_gt_lat(-81,8.5,-79,9,0,60,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_gt_lon(-83,9.5,-92,16.5,-95,0,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_gt_lon(-92,16.5,-104,22,-105,0,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_gt_lat(-104,78,-65.5,81,60,90,lon2,lat2);
%pos_bad=[pos_mask; pos_bad];

pos_mask=find(lon2 >=-104 & lon2<=0 & lat2>=22 & lat2<=60);
pos_bad=[pos_mask; pos_bad];

pos_mask=find(lon2 >=-82 & lon2 <=-80 & lat2>=8.8 & lat2<=60);
pos_bad=[pos_mask; pos_bad];

pos_mask=find(lon2 >=-89.5 & lon2 <=-83 & lat2>=16.45 & lat2<=16.7);
pos_bad=[pos_mask; pos_bad];
% Less than lon mask (Pacafic)

pos_mask=find(lon2 <=146 & lat2 <=-22 & lon2 >=-68) ;
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_lt_lon(130,-22,127,-3,0,140,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_lt_lon(130,-22,127,-3,0,140,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_lt_lon(102.01,-3,102,5.5,0,140,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

[pos_mask]=mask_lt_lon(102,5.5,98.5,9.6,0,140,lon2,lat2);
pos_bad=[pos_mask; pos_bad];

pos_mask=find(lon2<= 99 & lon2>= 0 & lat2 >= 9.6 &lat2 <=60);
pos_bad=[pos_mask; pos_bad];

% extra bit above the north Atlatic
[pos_mask]=mask_lt_lat(-103,78,-65.5,81,60,90,lon2,lat2);
pos_bad=[pos_mask;pos_bad];

pos_mask=find(lon2 >=-65.5 & lon2<= 40 & lat2>=0 & lat2<=80);

pos_bad=[pos_mask; pos_bad];



% subsect data

cds_pac=cds;
cds_pac(pos_bad,:)=[];


pos_good_pac=pos;
pos_good_pac(pos_bad)=[];








% Atlantic mask



cds_atl=cds;

cds_atl([pos_good_pac  pos_good_ind],:)=[];

pos_good_atl=pos;
pos_good_atl([pos_good_pac  pos_good_ind])=[];




% pcolor(lon,lat,sss_indian')
% shading flat
% plot_coasts_black
% figure
% %hold on
% pcolor(lon,lat,sss_atlantic')
% shading flat
% plot_coasts_black
% figure
% %hold on
% pcolor(lon,lat,sss_pacific')
% shading flat
% plot_coasts_black



end
