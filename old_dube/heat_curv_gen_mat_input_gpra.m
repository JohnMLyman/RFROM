function [hc_one,hc_whole,hc_vol,vol_ocean,time]=heat_curv_gen_mat_input_gpra(file_name, depth_top, depth_bottom)

% set to_bot = 1, if there is no bottom depth
% to get rid of ice
 %load  /Users/johnlyman/data/Globalhc/topo/topo


%topo2=median_smooth(topo,lon,lat,lon_ht,lat_ht,1);

% topo2=[topo2([end-floor(s(1)./4):end-1],:);topo2;topo2([1:floor(s(1)./4)],:)];
% lon=lon_ht';
% lon=[lon([end-floor(s(1)./4):end-1])-360,lon,lon([1:floor(s(1)./4)])+360];
% lon_ht=lon';
% save 'topo_gpra' topo2 lon_ht lat_ht
load /Volumes/Data/Globalhc/SAL/Floats/topo_gpra
%clear topo lat lon
% change to match ones map in hdata

lat_ht=lat_ht(end:-1:1);
topo2=-1.*topo2(:,end:-1:1);
topo2(topo2<0)=NaN;
arw=areavec(lon_ht,lat_ht);

%file_name='hdata_new__ishii_EN3_pfloat_sal_greg_jan_20121950_2011_300_700_real';
eval(['load /Volumes/Data/Globalhc/HC/' file_name]);  
hc_one=[];hc_vol=[];hc_whole=[];

bad=find(topo2 < depth_top );

topo_range=topo2;
topo_range(topo2> depth_bottom)=depth_bottom;
topo_range(bad)=NaN;

topo_range=topo_range-depth_top;

s=size(one);
%one_mask=ones(s(1),s(2),s(3)).*NaN;

hc_vol=nansum((topo_range(:)).*arw(:));
vol_ocean=nansum((topo2(:)).*arw(:));
for i=1:length(time)

corrhc_one=squeeze(one(:,:,i));

corrhc_one(bad)=NaN;

%one_mask(:,:,i)=corrhc_one;
% corrhc_error=interp2(lat,lon,error(:,:,i),lat_tpx,lon_tpx');
% corrhc_error(isnan(msk2(2:end-1,:)))=NaN;
% corrhc_error(isnan(sshmean))=NaN;

%corrhc_one_total=corrhc_one_total+corrhc_one;





%corrhc_one=interp2(lat,lon,one(:,:,i),lat_ht,lon_ht');
%corrhc_one=one(:,:,i);
% compute the area average heatcontent across the globe.

hc_one(i)=nansum(topo_range(:).*arw(:).*corrhc_one(:))./nansum(topo_range(:).*arw(:));

hc_whole(i)=nansum(topo_range(:).*arw(:).*corrhc_one(:))./nansum(topo2(:).*arw(:));
%hc_one(i)=nansum(arw(:).*corrhc_one(:))./nansum(arw(under_1800));

end
%figure(i+1)

topo=topo_range;


