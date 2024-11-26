function [data_grid]=objective_map_annual_tuna2(lon_grid,lat_grid,data,cds)

%This code make an objective map weighted by topography.

%data(Np,nvar);  where nvar are the varibels that you want to grid
%cds(Np,2);
%lon_grid(1,Nlon);
%lat_grid(1,Nlat);

%remove missing points


   
    sdata=size(data);
bad_total=[];
for idat=1:sdata(2)
    bad=find(isfinite(squeeze(data(:,idat)))==0);
    bad_total=[bad_total;bad];
    
end
bad_total=unique(bad_total);
cds(bad_total,:)=[];
data(bad_total,:)=[];


ln=lon_grid;
lat=lat_grid;



small_scale=.9;
large_scale=8;

signal_to_noise=2.2;




mcds=ones(1,2);


del_box=15;
del_over_cds=del_box./cosd(cds(:,2));
pos_ge_170=find(cds(:,1)>=180-del_over_cds);
pos_le_170=find(cds(:,1)<=-180+del_over_cds);

toc,'grid data cat and dog and mouse s'
nlon_grid=length(lon_grid);
nlat_grid=length(lat_grid);
[njunk,nvars]=size(data);

map=ones(nlon_grid,nlat_grid,nvars).*NaN;

tic,for ilon=1:nlon_grid
    for ilat=1:nlat_grid

i=1;
mcds(1,1)=lon_grid(ilon);
mcds(1,2)=lat_grid(ilat);

%find the nearest points with in 10 degress
del_over_mcds=del_box./cosd(mcds(i,2));

if mcds(i,1)<=-180+del_over_mcds,cds(pos_ge_170,1)=cds(pos_ge_170,1)-360;end
if mcds(i,1)>=180-del_over_mcds,cds(pos_le_170,1)=cds(pos_le_170,1)+360;end
  ll=find(abs(mcds(i,1)-cds(:,1)).*cosd(cds(:,2))<=del_box & ...
		abs(mcds(i,2)-cds(:,2))<=del_box);

  if length(ll)>5  % don't bother to do inversions far from data

   dist=sqrt(((mcds(i,1)-cds(ll,1)).*cosd(mcds(i,2))).^2+(mcds(i,2)-cds(ll,2)).^2);
   [~,ii]=sort(dist);
  
   if numel(dist)>350,ii=[ii(1:300);ii(randperm(length(ii)-300)+300)];ii=ii(1:350);end
   ii=ll(ii);
   [a,b]=meshgrid(cds(ii,1),cds(ii,1));a=(a-b).*cosd(mcds(i,2));clear b
   dd=a.^2;clear a
   [a,b]=meshgrid(cds(ii,2),cds(ii,2));a=a-b;clear b
   dd=dd+a.^2;clear a

   dd=((exp(-sqrt(dd)/large_scale)+3.4*exp(-dd/small_scale^2))/4.4)+signal_to_noise*eye(size(dd));
   
   poo=data(ii,:);
   rdat=dd\poo;

   % make data-grid cov. and maps
   [a,b]=meshgrid(cds(ii,1),mcds(i,1));a=(a-b).*cosd(mcds(i,2));
   dd=a.^2;
   [a,b]=meshgrid(cds(ii,2),mcds(i,2));a=a-b;
   dd=dd+a.^2;
  
   dd=(exp(-sqrt(dd)/large_scale)+3.4.*exp(-dd/small_scale^2))/4.4;
   
   poo=dd*rdat;
   map(ilon,ilat,:)=poo;
   
   if mcds(i,1)<=-180+del_over_mcds,cds(pos_ge_170,1)=cds(pos_ge_170,1)+360;end
   if mcds(i,1)>=180-del_over_mcds,cds(pos_le_170,1)=cds(pos_le_170,1)-360;end
  else
   
   if mcds(i,1)<=-180+del_over_mcds,cds(pos_ge_170,1)=cds(pos_ge_170,1)+360;end
   if mcds(i,1)>=180-del_over_mcds,cds(pos_le_170,1)=cds(pos_le_170,1)-360;end
 
  end  % of skip on land

  % keepin' the time
  if(mod(((ilon*nlat_grid)+ilat),10000)==0),disp(num2str([(ilon*nlat_grid)+ilat ilon ilat toc])),end
  clear dd poo
  
end
    end
% clean up
clear rdat i  a b 
toc,'reshape in cat'
    
%data_grid=reshape(map,[length(ln),length(lat),sdata(2)]);
data_grid=map;
clear map 
toc,'resape out'
    
    
    
    