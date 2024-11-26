function [pres,lat,lon_in,sal,Asal]=make_read_lev_absal
%load /Volumes/Data/WOA09/salinity_monthly_1deg.mat lon lat depth sal time
load /Volumes/Data/Globalhc/Levitus/slevhr lon lat dep levsal

lon_in=lon;
lon(lon>180)=lon(lon>180)-360;
sal=levsal;
s=size(sal);
salo=sal(:);

pres=dep;
preso=reshape(pres,1,1,s(3));
preso=repmat(preso,s(1),s(2));
%preso=preso(:);

lato=reshape(lat,1,1,s(2));
lato=repmat(lato,s(1),s(3));
lato=permute(lato,[1 3 2]);
%lato=lato(:);
%preso=sw_pres(preso,lato);

lono=reshape(lon,1,1,s(1));
lono=repmat(lono,s(2),s(3));
lono=permute(lono,[3 1 2]);
%lono=lono(:);


%Asal  = gsw_deltaSA_from_SP(salo,preso,lono,lato);
  Asal  = gsw_SA_from_SP(salo,preso,lono,lato);
     
Asal=reshape(Asal,s(1),s(2),s(3));

lon=lon_in;

save /Volumes/Data/Globalhc/Levitus/slevhr_abs.mat Asal sal dep lon lat
