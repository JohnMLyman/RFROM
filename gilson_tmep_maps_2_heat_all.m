
make_new_roemmich_gilson_clim

file_matlab='RG_ArgoClim.mat';

path_file= 'C:\Users\jlyma\OneDrive - University of Hawaii\data\Roemmich_Gilson_Clim\';

load([path_file,file_matlab])


s=size(temp);
lons=lon;
lons(lons>360)=lons(lons>360)-360;

lon_big=repmat(lons,1,s(2),s(3),s(4));
lat_big(1,:)=lat;
lat_big=repmat(lat_big,s(1),1,s(3),s(4));
pres_big(1,1,:)=pres;
pres_big=repmat(pres_big,s(1),s(2),1,s(4));



mean_temp=repmat(mean_temp,1,1,1,s(4));
mean_sal=repmat(mean_sal,1,1,1,s(4));

temp=temp+mean_temp;
sal=sal+mean_sal;

[SA, ~] = gsw_SA_from_SP(sal,pres_big,lon_big,lat_big);
CT = gsw_CT_from_pt(SA,temp);

save([path_file,'RG_ArgoClim_CT_SA_all.mat'],'CT','SA','lon','lat','pres','time','-v7.3')



bmask(~isfinite(bmask))=0;
bmask=logical(bmask);
bmask=repmat(bmask,1,1,1,s(4));

time=2004+time./12;



arw=areavec(lon,lat);
arw_total=repmat(arw,1,1,s(3),s(4));
[~,delta_p]=gilson_compute_depth_layers(pres);
% delta_p=[pres(1);diff(pres)];
delta_p_total(1,1,:)=delta_p;
delta_p_total=repmat(delta_p_total,s(1),s(2),1,s(4));

heat=gsw_rho(SA,CT,pres_big).*gsw_cp0.*CT.*delta_p_total;
heat(~bmask)=nan;
save([path_file,'RG_ArgoClim_heat_all2.mat'],'heat','lon','lat','pres','time','-v7.3')


  


