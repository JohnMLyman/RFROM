% mapdiff.m - matlab script to map global difference field for HC
% 3/17/3

function mapdiff_gen_allheat(file_name,fname_nc,clim_file)

%file name in the name of the allheat file and fname_nc is the name of the
%   outputted netcdf file
%fname_nc='hdata_1950_2006_new_jan_2007_argo';

%load clim gheatclim2 lon lat ln
eval(['load ' clim_file ' gheatclim lon lat ln'])
eval(['load ' file_name ' dt ht cds tm topex wnum s t'])

% remove climatology
htclim=interp2(lat,ln,gheatclim,cds(:,2),cds(:,1));
clear gheatclim ii

% remove annual cycle
load ../Levitus/levcyc levheatcyc lon lat mo
levheatcyc=levheatcyc-repmat(nanmean(levheatcyc,3),[1 1 length(mo)]);
tm=[tm,0*tm,0*tm];
dmo=datenum([dt,tm])-datenum(1992,1,1);dmo=mod(dmo/365.25*12,12)+1;
day=datenum([dt,tm])-datenum(1950,1,1);
lhc(:,:,1)=levheatcyc(:,:,end);lhc(:,:,2:5)=levheatcyc;
lhc(:,:,6)=levheatcyc(:,:,1);clear levheatcyc
lhc=[lhc(end,:,:);lhc;lhc(1,:,:)];
lon=[lon(end)-360,lon,lon(1)+360];
mo=[mo(end)-12,mo,mo(1)+12];
htcyc=interp3(lat,lon,mo,lhc,cds(:,2),cds(:,1),dmo,'*cubic');
htanom=ht-htclim;

eval(['save -append ' file_name ' htanom'])
clear i dmo lhc lon lat mo s t

% use topex with annual cycle 
tpx=topex(:,1);

% make new regression coeff. and interpolate onto profiles
%load hregress2
if 1
w=unique(wnum);
for i=1:length(w)
  ii=find(w(i)==wnum&~isnan(tpx+htanom));
  len(i)=length(ii);
  alpha(i)=tpx(ii)\htanom(ii);
  c(i)=mycorrel(tpx(ii),htanom(ii));
  xvar(i)=sqrt(nanmean(htanom(ii).^2));
end
ii=find(len<50);alpha(ii)=[];len(ii)=[];w(ii)=[];c(ii)=[];xvar(ii)=[];
al=wnum*NaN;cc=al;xx=al;
for i=1:length(w)
  ii=find(w(i)==wnum);
  al(ii)=repmat(alpha(i),[length(ii) 1]);
  cc(ii)=repmat(c(i),[length(ii) 1]);
  xx(ii)=repmat(xvar(i),[length(ii) 1]);
end

eval(['load ' file_name ' dt ht cds tm topex wnum s t'])


ii=find(isnan(al));cds(ii,:)=[];al(ii)=[];cc(ii)=[];xx(ii)=[];
nn=ii;
clear wnum ii i len alpha bind n w ans tpx stanom
% grid alpha using weighted sum
tlat=[-85:10:85];tlon=[-175:10:175];
[ggy,ggx]=meshgrid(tlat,tlon);
alpha=NaN*ggy;c=alpha;xvar=alpha;
tic,for i=1:length(ggx(:))
  if ggx(i)<-160,ll=find(cds(:,1)>160);cds(ll,1)=cds(ll,1)-360;end
  if ggx(i)>160,ll=find(cds(:,1)<-160);cds(ll,1)=cds(ll,1)+360;end
  dt=sqrt((ggx(i)-cds(:,1)).^2/6^2+(ggy(i)-cds(:,2)).^2/3^2);
  ii=find(dt<3);
  if length(ii)<30,[poo,jj]=sort(dt);ii=jj(1:30);end
  alpha(i)=(exp(-dt(ii))'*al(ii))/sum(exp(-dt(ii)));
  c(i)=(exp(-dt(ii))'*cc(ii))/sum(exp(-dt(ii)));
  xvar(i)=(exp(-dt(ii))'*xx(ii))/sum(exp(-dt(ii)));
  if ggx(i)<-160,cds(ll,1)=cds(ll,1)+360;end
  if ggx(i)>160,cds(ll,1)=cds(ll,1)-360;end
  if mod(i,100)==0,disp(num2str([i toc])),end
end
alpha=reshape(alpha,[length(tlon),length(tlat)]);
c=reshape(c,[length(tlon),length(tlat)]);
xvar=reshape(xvar,[length(tlon),length(tlat)]);
tlon=[tlon(end)-360,tlon,tlon(1)+360];tlat=[-95,tlat,95];
alpha=[alpha(end,:);alpha;alpha(1,:)];
c=[c(end,:);c;c(1,:)];
xvar=[xvar(end,:);xvar;xvar(1,:)];
alpha=[0*tlon',alpha,0*tlon'];
c=[0*tlon',c,0*tlon'];
xvar=[0*tlon',xvar,0*tlon'];
alon=[-181:181];alat=[-91:91];clear poo
alpha=interp2(tlat,tlon,alpha,alat,alon','cubic');
c=interp2(tlat,tlon,c,alat,alon','cubic');
xvar=interp2(tlat,tlon,xvar,alat,alon','cubic');
clear i ii tlon tlat hccc hcxx hcal al dt ggx ggy j jj ll poo
save hregress_delayed alat alon alpha c xvar
end % of skip

eval(['load ' file_name ' htanom cds topex'])




tpx=topex(:,1);
tpx(isnan(tpx))=0;
hctpx=tpx.*interp2(alat,alon,alpha,cds(:,2),cds(:,1));
% note:  now replacing NaN's with zeros in topex

% make difference variable
htdiff=htanom-hctpx;

% keep only good data
ii=find(~isnan(htdiff));
htdiff=htdiff(ii);day=day(ii,:);cds=cds(ii,:);htanom=htanom(ii);tpx=tpx(ii);
clear ii mo dy gmo d ans i j poo

% make grid variables
tgrid=[1992.75:.25:2003.5];
tgrid=[1950.5:.25:2008.0];
load ../topo/topo lat lon topo
xtopo=lon;ytopo=lat;topo(topo>0)=NaN;topo(topo<=0)=1;
load ../Mtpers/ssh16600 lat lon
lon=[lon(542:end)-360;lon(1:541)];
lon=[lon(end)-360;lon;lon(1)+360];
lon2=lon;lat2=lat;
ii=1:3:length(lon);jj=1:3:length(lat);lon=lon(ii);lat=lat(jj);
msk=interp2(ytopo,xtopo,topo,lat,lon','nearest');
msk2=interp2(ytopo,xtopo,topo,lat2,lon2','nearest');
[gy,gx]=meshgrid(lat,lon);
mcds=[gx(:),gy(:)];
gind=find(~isnan(msk));bind=find(isnan(msk));
save landmask msk lon lat msk2 lat2 lon2

% have to spit out data and grid so that we can do inversion
% on supercomputer!

% grid
outcds=mcds;outcds=outcds(gind,:);
save -ascii map_idl.grd outcds

% save grid info to file so we can read output from fortran prog.
save gridinfo_idl mcds gind bind lon lat tgrid

% make list of indicies to be searched for each grid point
yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;



for i=1:1
 idx{i}=find(yr >=1950);
end

% spit out data

  ii=idx{1};
  
  
  htdiff=htdiff(ii);
  htanom=htanom(ii);
  tpx=tpx(ii);
  yr=yr(ii);
  coords=cds(ii,:);
  
eval(['save ',fname_nc,' htdiff tpx yr coords htanom'])
nc_idl_save_hdata_gen(fname_nc);

