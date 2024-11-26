% no longer used.  do all clims. at once in ../Steric/ directory
% using maptclim.m instead!!!
% mapclim.m - matlab script to map a climatology relative
% Also using topex alias fixing trick.
% 3/17/3
%computes alpha!

load allheat_700
load /Users/johnlyman/data/Globalhc/Levitus/hlevhr_700

% interpolate levitus heat content onto data
levheat=[levheat(end-40:end,:);levheat;levheat(1:41,:)];
lon=[-190.125:.25:190.125];
levhclim=interp2(lon,lat,levheat',cds(:,1),cds(:,2));
heatanom=ht-levhclim;

% pick only data from 2004 through 2007
tpx=topex(:,1);
day=datenum(dt);

'cat'
gind=find(day>=datenum(1967,1,1)&day<datenum(1993,1,1)& ...
	~isnan(heatanom));
heatanom=heatanom(gind);cds=cds(gind,:);day=day(gind);
dt=dt(gind,:);tpx=tpx(gind);wnum=wnum(gind);

% need to make regression coeffs. based on tpx/hc regression
% see comprable note in ../Steric/maptclim.m
% do regression by box
% if 0
w=unique(wnum);
for i=1:length(w)
  ii=find(w(i)==wnum);
  len(i)=length(ii);
  alpha(i)=tpx(ii)\heatanom(ii);
  c(i)=correl(tpx(ii),heatanom(ii));
  xvar(i)=sqrt(nanmean(heatanom(ii).^2));
end
ii=find(len<50);
len(ii)=[];w(ii)=[];alpha(ii)=[];c(ii)=[];xvar(ii)=[];
al=wnum*NaN;cd=cds;cc=al;xx=al;
for i=1:length(w)
  ii=find(w(i)==wnum);
  al(ii)=alpha(i);
  cc(ii)=c(i);
  xx(ii)=xvar(i);
end
ii=find(isnan(al));cds(ii,:)=[];al(ii)=[];
cc(ii)=c(i);xx(ii)=xvar(i);
% end

% grid alpha using weighted sum
tlat=[-75:10:89];tlon=[-175:10:175];
[ggy,ggx]=meshgrid(tlat,tlon);
tmpal=NaN*ggy;tmpcc=tmpal;tmpxx=tmpal;
tic,for i=1:length(ggx(:))
  dt=sqrt((ggx(i)-cds(:,1)).^2/6^2+(ggy(i)-cds(:,2)).^2/3^2);
  %ii=find(dt<=3);             
  [poo,ii]=sort(dt);ii=ii(1:350);
  %if length(ii)<50,ii=[];                           
  %elseif length(ii)>350,
  %  [poo,jj]=sort(dt(ii));ll=randperm(length(ii)-300)+300;   
  %  ii=ii([jj([1:300,ll(1:50)])]);
  %end
  %if ~isempty(ii) 
    tmpal(i)=tpx(ii)\heatanom(ii);
    tmpcc(i)=correl(tpx(ii),heatanom(ii));
    tmpxx(i)=sqrt(nanmean(heatanom(ii).^2));
  %else
  %  tmpal(i)=0;
  %  tmpcc(i)=0;
  %  tmpxx(i)=0;
  %end
  if mod(i,100)==0,disp(num2str([i toc])),end
end

tic,for i=1:length(ggx(:))
  dt=sqrt((ggx(i)-cds(:,1)).^2/6^2+(ggy(i)-cds(:,2)).^2/3^2);
  ii=find(dt<3);
  if length(ii)>10
    tmpal(i)=(exp(-dt(ii))'*al(ii))/sum(exp(-dt(ii)));
    tmpcc(i)=(exp(-dt(ii))'*cc(ii))/sum(exp(-dt(ii)));
    tmpxx(i)=(exp(-dt(ii))'*xx(ii))/sum(exp(-dt(ii)));
  end
  if mod(i,100)==0,disp(num2str([i toc])),end
end
tlon=[tlon(end)-360,tlon,tlon(1)+360];
tmpal=[tmpal(end,:);tmpal;tmpal(1,:)];tmpal=[0*tlon',tmpal,0*tlon'];
tmpcc=[tmpcc(end,:);tmpcc;tmpcc(1,:)];tmpcc=[0*tlon',tmpcc,0*tlon'];
tmpxx=[tmpxx(end,:);tmpxx;tmpxx(1,:)];tmpxx=[0*tlon',tmpxx,0*tlon'];
tlat=[-90,tlat,90];
ln=[-179.875:.25:179.875];
alpha=interp2(tlat,tlon,tmpal,lat,ln','cubic');alpha(isnan(alpha))=0;
crl=interp2(tlat,tlon,tmpcc,lat,ln','cubic');crl(isnan(crl))=0;
xvar=interp2(tlat,tlon,tmpxx,lat,ln','cubic');xvar(isnan(xvar))=0;
alat=lat;alon=ln;
save /Users/johnlyman/data/Globalhc/HC/hregress_700 alat alon alpha crl xvar
%return
cds=cd;
clear al ii jj a w wnum cd ggx ggy tlat tlon tmpal ww ll

alon=[alon(end)-360,alon,alon(1)+360];
alpha=[alpha(end,:);alpha;alpha(1,:)];
hctpx=tpx.*interp2(alat,alon,alpha,cds(:,2),cds(:,1));

% map data onto same grid as levitus climatology
% now doing this by looping over grid points and keeping closest
% 300 point in matrix inversion

% clear some things we don't need for the map
clear dt bt gind levhclim ht w alpha bln blt bt d day dd dt mln mlt

% make map grid
map=zeros(length(ln),length(lat));tpxmap=map;
[gy,gx]=meshgrid(lat,ln);
mcds=[gx(:),gy(:)];

% make a course, 5x5 deg. grid to help in picking out indicies
% in main loop
glon=[-177.5:5:177.5];glat=[-87.5:5:87.5];
[gy,gx]=meshgrid(glat,glon);
gcds=[gx(:),gy(:)];
tic,for i=1:length(gcds)
  if gcds(i,1)<=-170,ii=find(cds(:,1)>=170);cds(ii,1)=cds(ii,1)-360;end
  if gcds(i,1)>=170,ii=find(cds(:,1)<=-170);cds(ii,1)=cds(ii,1)+360;end
  idx{i}=find(abs(gcds(i,1)-cds(:,1))<=10 & ...
		abs(gcds(i,2)-cds(:,2))<=10);
  if gcds(i,1)<=-170,cds(ii,1)=cds(ii,1)+360;end
  if gcds(i,1)>=170,cds(ii,1)=cds(ii,1)-360;end
  if mod(i,100)==0,disp(num2str([i toc])),end
end
ind=reshape(1:length(idx),[length(glon),length(glat)]);
mind=interp2(glat,glon,ind,lat',ln,'nearest');
clear gx gy ii i

tic,for i=1:length(mcds(:,1))  % loop through grid

  % pick out points in 10x10 degree square around point
  ll=idx{mind(i)};

  if length(ll)>5  % don't bother to do inversions far from data
   if mcds(i,1)<=-170
	jj=find(cds(ll,1)>=170); cds(ll(jj),1)=cds(ll(jj),1)-360;
   end
   if mcds(i,1)>=170
	jj=find(cds(ll,1)<=-170); cds(ll(jj),1)=cds(ll(jj),1)+360;
   end
   dist=sqrt((mcds(i,1)-cds(ll,1)).^2+(mcds(i,2)-cds(ll,2)).^2);
   [d,ii]=sort(dist);
   if length(dist)>350,ii=[ii(1:300);ii(randperm(50)+300)];end
   ii=ll(ii);
   [a,b]=meshgrid(cds(ii,1),cds(ii,1));a=a-b;clear b
   dd=a.^2;clear a
   [a,b]=meshgrid(cds(ii,2),cds(ii,2));a=a-b;clear b
   dd=dd+a.^2;clear a
   dd=(exp(-sqrt(dd)/8)+3.4*exp(-dd/.9^2))/4.4+8*eye(size(dd));
   poo=[heatanom(ii),hctpx(ii)];
   rdat=dd\poo;

   % make data-grid cov. and maps
   [a,b]=meshgrid(cds(ii,1),mcds(i,1));a=a-b;
   dd=a.^2;
   [a,b]=meshgrid(cds(ii,2),mcds(i,2));a=a-b;
   dd=dd+a.^2;
   dd=(exp(-sqrt(dd)/8)+3.4*exp(-dd/.9^2))/4.4;
   poo=dd*rdat;
   map(i)=poo(1);
   tpxmap(i)=poo(2);
   if mcds(i,1)<=-170,cds(ll(jj),1)=cds(ll(jj),1)+360;end
   if mcds(i,1)>=170,cds(ll(jj),1)=cds(ll(jj),1)-360;end
  else
   map(i)=0;
   tpxmap(i)=0;
  end  % of skip on land

  % keepin' the time
  if(mod(i,10000)==0),disp(num2str([i toc])),end
end

% clean up
clear rdat i poo dd a b 
map=reshape(map,[length(ln),length(lat)]);
tpxmap=reshape(tpxmap,[length(ln),length(lat)]);

% make correction to levitus climatologies
ii=find(lon>=ln(1)&lon<=ln(end));
gheatclim=map+levheat(ii,:);
gheatclim2=map+levheat(ii,:)-tpxmap;

save /Users/johnlyman/data/Globalhc/HC/clim_2_1967_1993_700 gheatclim gheatclim2 ln lon lat map tpxmap levheat 
