function [pres,lat,lon_in,sal,Asal]=make_read_lev_absal_season
load /Volumes/Data/WOA09/salinity_monthly_1deg.mat lon lat depth sal time
%load /Volumes/Data/Globalhc/Levitus/slevhr lon lat dep levsal
%sal=levsal;
lon_in=lon;
lon(lon>180)=lon(lon>180)-360;

s=size(sal);
salo=sal(:);

pres=depth;

preso=reshape(pres,1,1,1,s(3));
preso=repmat(preso,[s(1) s(2) s(4)]);
preso=permute(preso,[1 2 4 3]);
preso=preso(:);

lato=reshape(lat,1,1,1,s(2));
lato=repmat(lato,[s(1) s(3) s(4)]);
lato=permute(lato,[1 4 2 3]);
lato=lato(:);
preso=sw_pres(preso,lato);


lono=reshape(lon,1,1,1,s(1));
lono=repmat(lono,[s(2) s(3) s(4)]);
lono=permute(lono,[4 1 2 3]);
lono=lono(:);


%Asal  = gsw_deltaSA_from_SP(salo,preso,lono,lato);
  Asal  = gsw_SA_from_SP(salo,preso,lono,lato);
     
Asal=reshape(Asal,s(1),s(2),s(3),s(4));

lon=lon_in;
save /Volumes/Data/Globalhc/Levitus/salinity_monthly_1deg_abs.mat Asal sal depth lon lat time
