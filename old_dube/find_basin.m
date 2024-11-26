function [sss_atlantic,sss_pacific,sss_indian]=find_basin(lat,lon,sss)

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

slon=size(lon);
slat=size(lat);

sss_indian=sss;
sss_pacific=sss;
sss_atlantic=sss;
lat2=repmat(lat',slon,1);
lon2=repmat(lon,1,slat);

% Indian Ocean

% less than lon mask (Indian)

pos_mask=find(lon2 <= 20 & lat2 <= 31) ;
sss_indian(pos_mask)=NaN;

pos_mask=find(lat2 >=30.7);
sss_indian(pos_mask)=NaN;


% greater than lon mask (Indian)

pos_mask=find(lon2 >=146 & lat2 <=-22 & lon2 >=-68) ;
sss_indian(pos_mask)=NaN;

[pos_mask]=mask_gt_lon(130,-22,127,-3,0,200,lon2,lat2);
sss_indian(pos_mask)=NaN;

[pos_mask]=mask_gt_lon(130,-22,127,-3,0,200,lon2,lat2);
sss_indian(pos_mask)=NaN;

[pos_mask]=mask_gt_lon(102.01,-3,102,5.5,0,200,lon2,lat2);
sss_indian(pos_mask)=NaN;

[pos_mask]=mask_gt_lon(102,5.5,98.5,9.6,0,200,lon2,lat2);
sss_indian(pos_mask)=NaN;

pos_mask=find(lon2>= 99 & lon2<= 2000 & lat2 >= 9.6);
sss_indian(pos_mask)=NaN;

% Pacific Ocean

%Greater than lon mask

pos_mask=find(lon2 >= -60 & lat2 >= -22 & lon2 <= 98);
sss_pacific(pos_mask)=NaN;

[pos_mask]=mask_gt_lon(-60,-6,-79,9,-80,0,lon2,lat2);
sss_pacific(pos_mask)=NaN;

pos_mask=find(lon2>=-79 & lon2 <= 0 & lat2 >=9 & lat2 <=90);
sss_pacific(pos_mask)=NaN;
[pos_mask]=mask_gt_lat(-81,8.5,-79,9,0,90,lon2,lat2);
sss_pacific(pos_mask)=NaN;

[pos_mask]=mask_gt_lon(-83,9.5,-92,16.5,-95,0,lon2,lat2);
sss_pacific(pos_mask)=NaN;

[pos_mask]=mask_gt_lon(-92,16.5,-104,22,-105,0,lon2,lat2);
sss_pacific(pos_mask)=NaN;

pos_mask=find(lon2 >=-104 & lon2<=0 & lat2>=22);
sss_pacific(pos_mask)=NaN;

% Less than lon mask (Pacafic)

pos_mask=find(lon2 <=146 & lat2 <=-22 & lon2 >=-68) ;
sss_pacific(pos_mask)=NaN;

[pos_mask]=mask_lt_lon(130,-22,127,-3,0,140,lon2,lat2);
sss_pacific(pos_mask)=NaN;

[pos_mask]=mask_lt_lon(130,-22,127,-3,0,140,lon2,lat2);
sss_pacific(pos_mask)=NaN;

[pos_mask]=mask_lt_lon(102.01,-3,102,5.5,0,140,lon2,lat2);
sss_pacific(pos_mask)=NaN;

[pos_mask]=mask_lt_lon(102,5.5,98.5,9.6,0,140,lon2,lat2);
sss_pacific(pos_mask)=NaN;

pos_mask=find(lon2<= 99 & lon2>= 0 & lat2 >= 9.6);
sss_pacific(pos_mask)=NaN;

% Atlantic mask


%Less than lon mask (Atlatic)
pos_mask=find(lon2 >=-280 & lat2 <=-54.7 & lon2 <=-68) ;
sss_atlantic(pos_mask)=NaN;

pos_mask=find(lon2 >=-280 & lat2 >=-54.7 & lon2 <=-70 & lat2 <= -31.5) ;
sss_atlantic(pos_mask)=NaN;

 pos_mask=find(lon2 >= -280 & lat2 <= -6 & lon2 <= -58 & lat2 >=-31);
 sss_atlantic(pos_mask)=NaN;

 [pos_mask]=mask_lt_lon(-60,-6,-79,9,-180,0,lon2,lat2);
sss_atlantic(pos_mask)=NaN;
 
[pos_mask]=mask_lt_lon(-60,-6,-79,9,-180,0,lon2,lat2);
sss_atlantic(pos_mask)=NaN;

pos_mask=find(lon2<=-79 & lon2 >= 0 & lat2 <=9 & lat2 >=90);
sss_atlantic(pos_mask)=NaN;
[pos_mask]=mask_lt_lat(-81,8.5,-79,9,-90,0,lon2,lat2);
sss_atlantic(pos_mask)=NaN;

[pos_mask]=mask_lt_lon(-83,9.5,-92,16.5,-180,0,lon2,lat2);
sss_atlantic(pos_mask)=NaN;

[pos_mask]=mask_lt_lon(-92,16.5,-104,22,-180,0,lon2,lat2);
sss_atlantic(pos_mask)=NaN;

pos_mask=find(lon2 <=-104 & lon2>=-180 & lat2>=22);
sss_atlantic(pos_mask)=NaN;

%Greater than lon mask (Atlatic)

pos_mask=find(lon2 >=20 & lon2 <= 200 & lat2<= 50);
sss_atlantic(pos_mask)=NaN;

pos_mask=find(lon2>= -6 & lon2<= 200 & lat2>=25 & lat2<= 40);
sss_atlantic(pos_mask)=NaN;

[pos_mask]=mask_gt_lon(-6,40,12,51,0,200,lon2,lat2);
sss_atlantic(pos_mask)=NaN;

pos_mask=find(lon2>= 12 & lon2<= 200 & lat2>=51 & lat2<= 64);
sss_atlantic(pos_mask)=NaN;

[pos_mask]=mask_gt_lon(12,64,24.5,67.5,0,30,lon2,lat2);
sss_atlantic(pos_mask)=NaN;

pos_mask=find(lat2 <= 64 & lon2>=43 & lon2<= 98);
sss_atlantic(pos_mask)=NaN;

pos_mask=find(lat2 >= 64 & lon2>=98);
sss_atlantic(pos_mask)=NaN;


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
