function [hc_one,one_mask,topo_1800,hc_vol]=heat_curv_gen_nc_input_1800(one,lon_ht,lat_ht,time)


depth_min=1800;
% to get rid of ice
 load  /Users/johnlyman/data/Globalhc/topo/topo


%topo2=median_smooth(topo,lon,lat,lon_ht,lat_ht,1);

% topo2=[topo2([end-floor(s(1)./4):end-1],:);topo2;topo2([1:floor(s(1)./4)],:)];
% lon=lon_ht';
% lon=[lon([end-floor(s(1)./4):end-1])-360,lon,lon([1:floor(s(1)./4)])+360];
% lon_ht=lon';
% save 'topo_gpra' topo2 lon_ht lat_ht
load topo_gpra
clear topo lat lon

arw=areavec(lon_ht,lat_ht);


  

  one=permute(one,[3 2 1]);
hc_one=[];hc_vol=[];

bad=find(topo2 >= -1.*depth_min);
topo_1800=topo2;
topo_1800(bad)=NaN;
under_1800=find(topo2 < -1.*depth_min);
s=size(one);
one_mask=ones(s(1),s(2),s(3)).*NaN;

hc_vol=nansum((-1.*topo_1800(:)-depth_min).*arw(:));

for i=1:length(time)

corrhc_one=squeeze(one(:,:,i));

corrhc_one(bad)=NaN;

one_mask(:,:,i)=corrhc_one;
% corrhc_error=interp2(lat,lon,error(:,:,i),lat_tpx,lon_tpx');
% corrhc_error(isnan(msk2(2:end-1,:)))=NaN;
% corrhc_error(isnan(sshmean))=NaN;

%corrhc_one_total=corrhc_one_total+corrhc_one;






% compute the area average heatcontent across the globe.

hc_one(i)=nansum((-1.*topo_1800(:)-depth_min).*arw(:).*corrhc_one(:))./nansum((-1.*topo_1800(:)-depth_min).*arw(:));


%hc_one(i)=nansum(arw(:).*corrhc_one(:))./nansum(arw(under_1800));

end
%figure(i+1)

topo_1800=-1.*topo_1800;


