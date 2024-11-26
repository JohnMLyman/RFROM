function [hc_one,one_mask,topo_top,hc_vol]=heat_curv_gen_nc_input_top(one,lon_ht,lat_ht,time)


depth_min=0;
depth_max=700;
% to get rid of ice
 load  /Users/johnlyman/data/Globalhc/topo/topo


%topo2=median_smooth(topo,lon,lat,lon_ht,lat_ht,1);


load 'topo_gpra' 
clear topo lat lon

arw=areavec(lon_ht,lat_ht);


  

  one=permute(one,[3 2 1]);


bad=find(topo2 >= -1.*depth_min);
topo_1800=topo2;
topo_1800(bad)=NaN;
under_700=find(topo2 < -1.*depth_min);
under_1800=find(topo2 < -1.*depth_max);

s=size(one);

depth_scale=topo2;
depth_scale(bad)=NaN;
depth_scale(under_1800)=-1.*depth_max;

one_mask=ones(s(1),s(2),s(3)).*NaN;

hc_one=[];hc_vol=[];

hc_vol=nansum((-1.*depth_scale(:)-depth_min).*arw(:));
for i=1:length(time)

corrhc_one=squeeze(one(:,:,i));

corrhc_one(bad)=NaN;

one_mask(:,:,i)=corrhc_one;
% corrhc_error=interp2(lat,lon,error(:,:,i),lat_tpx,lon_tpx');
% corrhc_error(isnan(msk2(2:end-1,:)))=NaN;
% corrhc_error(isnan(sshmean))=NaN;

%corrhc_one_total=corrhc_one_total+corrhc_one;




% compute the area average heatcontent across the globe.

hc_one(i)=nansum((-1.*depth_scale(:)-depth_min).*arw(:).*corrhc_one(:))/nansum((-1.*depth_scale(:)-depth_min).*arw(:));
%hc_one(i)=nansum(arw(:).*corrhc_one(:))/nansum(arw(under_700));


end
%figure(i+1)

topo_top=-1.*topo_1800;


