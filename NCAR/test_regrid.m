% var=ptemp;
%  V=lon*i+lat;
% [~,b]=unique(V);
var=ssh;
% var=var(b);
% lon_old=lon;
% lat_old=lat;
% lon=lon(b);
% lat=lat(b);
close all
good=isfinite(lon)&isfinite(lat)&isfinite(var)&lat<60;
good=isfinite(lon)&isfinite(lat)&lat<60&lat>35&lon>175 &lon<185;
% good2=isfinite(lon2)&isfinite(lat2);
svar=size(var);

lon_new=.125:.25:360-.125;
lat_new=-90+.125:.25:90-.125;
[LAT_new,LON_new]=meshgrid(lat_new,lon_new);
% var_out=nan(length(lon_new),length(lat_new),svar(3));

lat2=lat(good);
lon2=lon(good);
var2=var(good);

cor=lon2 +lat2.*i;
[a,b]=unique(cor);
lat2=lat2(b);
lon2=lon2(b);
var2=var2(b);

  var_junk=var;
%   var3=griddata(lat(good),lon(good),var_junk(good),lat_new',lon_new,'linear');
  var4=griddata(lat2,lon2,var2,lat_new',lon_new,'linear');

%   pcolor(lon_new,lat_new,var3')
% 
%   shading flat
  figure
  pcolor(lon_new,lat_new,var4')
  shading flat
%    var4=griddata(lat(good),lon(good),var_junk(good),lat_new',lon_new,'natural');
%     var5=griddata(lat(good),lon(good),var_junk(good),lat_new',lon_new,'nearest');
% 
% lat=lat_old;
% lon=lon_old;

       
        var_out(:,:,ilevel)=griddata(lat(good),lon(good),var_junk(good),lat_new',lon_new,'linear');

tic
parfor ilevel=1:svar(3)
        var_junk=squeeze(var(:,:,ilevel));
       
        var_out(:,:,ilevel)=griddata(lat(good),lon(good),var_junk(good),lat_new',lon_new,'linear');
      

end
toc./60
% F=scatteredInterpolant(lon(good),lat(good),var_junk(good),'linear');
% var2=F(LON_new,LAT_new);
% toc./60
% 
% %         
%     end