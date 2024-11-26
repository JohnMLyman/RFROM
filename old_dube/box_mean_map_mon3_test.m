function [data_grid]=box_mean_map_mon3_test(lon_grid,lat_grid,data,cds,time,grid_bin)

%This code make an objective map weighted by topography.

%data(Np,nvar);  where nvar are the varibels that you want to grid
%cds(Np,2);
%time(Np);
%lon_grid(1,Nlon);
%lat_grid(1,Nlat);

%remove missing points
large_scale=9;
small_scale=1;
time_scale=30./365;

sdata=size(data);
bad_total=[];
for idat=1:sdata(2)
    bad=find(isfinite(squeeze(data(:,idat)))==0);
    bad_total=[bad_total;bad];
    
end
bad_total=unique(bad_total);
cds(bad_total,:)=[];
data(bad_total,:)=[];
time(bad_total,:)=[];
% %interpolate depth to grid and data
% load /Volumes/Data/Globalhc/topo/topo.mat
% 
% lon_topo=lon;
% lat_topo=lat;
% slon=length(lon_topo);
% here I assing pontential vorticity normalized Fmax
% lat2_topo=repmat(lat_topo,slon,1);
% vort=topo;%.*cos((pi.*lat2_topo)/180);
% 
% 
% vort=[vort(end-21:end-3,:);vort;vort(4:22,:)];
% 
% lon_topo=[lon_topo(end-21:end-3)-360 lon_topo lon_topo(4:22)+360];
% 
% data_vort=interp2(lon_topo,lat_topo,vort',...
%         cds(:,1),cds(:,2));
% 
% grid_vort=interp2(lon_topo,lat_topo,vort',lon_grid',lat_grid)';
% grid_vort=grid_vort(:);
% difine things in terms of the local grid

ln=lon_grid;
lat=lat_grid;

% make map grid
% 
% [gy,gx]=meshgrid(lat,ln);
% mcds=[gx(:),gy(:)];
% sizemc=size(mcds);
% map=zeros(sizemc(1),sdata(2))*NaN;

%space in degrees and time in days
%small_scale=3;
%large_scale=8;


%signal_to_noise=1.;



% % make a course, 5x5 deg. grid to help in picking out indicies
% % in main loop
% glon=[-180:5:180];glat=[-90:5:90];
% glon=lon_grid;
% glat=lat_grid;
% [gy,gx]=meshgrid(glat,glon);
% gcds=[gx(:),gy(:)];
% tic,for i=1:length(gcds)
%   if gcds(i,1)<=-170,ii=find(cds(:,1)>=170);cds(ii,1)=cds(ii,1)-360;end
%   if gcds(i,1)>=170,ii=find(cds(:,1)<=-170);cds(ii,1)=cds(ii,1)+360;end
%   idx{i}=find(abs(gcds(i,1)-cds(:,1))<=10 & ...
% 		abs(gcds(i,2)-cds(:,2))<=10);
%   if gcds(i,1)<=-170,cds(ii,1)=cds(ii,1)+360;end
%   if gcds(i,1)>=170,cds(ii,1)=cds(ii,1)-360;end
%   if mod(i,100)==0,disp(num2str([i toc])),end
% end
% ind=reshape(1:length(idx),[length(glon),length(glat)]);
% mind=interp2(glat,glon,ind,lat',ln,'nearest');
% 
% clear gx gy ii i
mcds=ones(1,2);
pos_ge_170=find(cds(:,1)>=180-grid_bin);
pos_le_170=find(cds(:,1)<=-180+grid_bin);


nlon_grid=length(lon_grid);
nlat_grid=length(lat_grid);
[~,nvars]=size(data);

map=ones(nlon_grid,nlat_grid,5).*NaN;
%map=ones(nlon_grid,nlat_grid).*NaN;

tic,for ilon=1:nlon_grid
    for ilat=1:nlat_grid
%tic,for i=1:length(mcds(:,1))  % loop through grid
i=1;
mcds(1,1)=lon_grid(ilon);
mcds(1,2)=lat_grid(ilat);

%find the nearest points with in 10 degress
if mcds(i,1)<=(-180+grid_bin),cds(pos_ge_170,1)=cds(pos_ge_170,1)-360;end
if mcds(i,1)>=(180-grid_bin),cds(pos_le_170,1)=cds(pos_le_170,1)+360;end

  ll=find((mcds(i,1)-cds(:,1))<=grid_bin & (cds(:,1)-mcds(i,1))<grid_bin &...
		(mcds(i,2)-cds(:,2))<=grid_bin& (cds(:,2)-mcds(i,2))<grid_bin);

%   if gcds(i,1)<=-170,cds(ii,1)=cds(ii,1)+360;end
%   if gcds(i,1)>=170,cds(ii,1)=cds(ii,1)-360;end
  
  
  % pick out points in 10x10 degree square around point
  np_close=length(ll);
  %ll=idx{mind(i)};
  if np_close>0  % don't bother to do inversions far from data
% %    if mcds(i,1)<=-170
% % 	jj=find(cds(ll,1)>=170); cds(ll(jj),1)=cds(ll(jj),1)-360;
% %    end
% %    if mcds(i,1)>=170
% % 	jj=find(cds(ll,1)<=-170); cds(ll(jj),1)=cds(ll(jj),1)+360;
% %    end
%    
%    
%       dist=sqrt((((mcds(i,1)-cds(ll,1))./small_scale)).^2+(((mcds(i,2)-cds(ll,2))./small_scale)).^2+(time(ll)./time_scale).^2);
%       [d,ii]=sort(dist);
%    
%   iic=ii;
%   n_near=300;
%   n_far=50;
%        if numel(dist)>(n_near+n_far)
%            if d(n_near)<1.5
%                junk_n=numel(find(d<1.5));
%                iic=ii(randperm(junk_n));
%                iic=[iic(1:n_near);ii(randperm(length(ii)-junk_n)+junk_n)];
%                iic=iic(1:(n_near+n_far));
%            else
%            iic=[ii(1:n_near);ii(randperm(length(ii)-n_near)+n_near)];
%            iic=iic(1:(n_near+n_far));
%            end
%        end
% 
%    
%   
%    ii_big=ll(iic);
%    
%    time_dd=time(ii_big);
%    dd=sqrt((mcds(i,1)-cds(ii_big,1)).^2+(mcds(i,2)-cds(ii_big,2)).^2);
%    
%    w=(exp(-(time_dd./time_scale).^2)).*(exp(-sqrt(dd)/large_scale)+3.4*exp(-dd/small_scale^2))/4.4;
%    
%    map(ilon,ilat,:)=nansum(data(ii_big,:).*repmat(w,1,nvars))./nansum(w);

   %ii=ll(ii);
   ii=ll;
   [a,b]=meshgrid(cds(ii,1),cds(ii,1));a=(a-b).*cosd(mcds(i,2));clear b
   dd=a.^2;clear a
   [a,b]=meshgrid(cds(ii,2),cds(ii,2));a=a-b;clear b
   dd=dd+a.^2;clear a
   [a,b]=meshgrid(time(ii),time(ii));a=a-b;clear b
   time_dd=a;clear a
%    % add in the depth 
   % [va,vb]=meshgrid(data_vort(ii),data_vort(ii));va=(small_scale./vort_scale).*((va-vb)./(va+vb));clear vb;
  %  dd=dd+va.^2;clear va
  signal_to_noise=1;
  
   covmat=(exp(-(time_dd./time_scale).^2)).*(exp(-sqrt(dd)/large_scale)+3.4*exp(-dd/small_scale^2))/4.4+signal_to_noise*eye(size(dd));
   
   data_junk=data(ii,:);
   
   ident=eye(length(ii));
   cov_inv=covmat\ident;
   rdat=cov_inv*data_junk;

   dof=squeeze(nansum(nansum(cov_inv)));
   poo=nansum(rdat./dof,1);
   
   
   
   map(ilon,ilat,1:4)=poo;
  map(ilon,ilat,5)=dof;
   if mcds(i,1)<=(-180+grid_bin),cds(pos_ge_170,1)=cds(pos_ge_170,1)+360;end
   if mcds(i,1)>=(180-grid_bin),cds(pos_le_170,1)=cds(pos_le_170,1)-360;end
  else
   
   if mcds(i,1)<=(-180+grid_bin),cds(pos_ge_170,1)=cds(pos_ge_170,1)+360;end
   if mcds(i,1)>=(180-grid_bin),cds(pos_le_170,1)=cds(pos_le_170,1)-360;end
 
  end  % of skip on land

  % keepin' the time
  if(mod(((ilon*nlat_grid)+ilat),10000)==0),disp(num2str([(ilon*nlat_grid)+ilat ilon ilat toc])),end
  %clear dd poo
  
end
end
% clean up
%clear rdat i  a b 
toc,'reshape in'
    
%data_grid=reshape(map,[length(ln),length(lat),sdata(2)]);
data_grid=map;
clear map 
toc,'resape out'
    
    

