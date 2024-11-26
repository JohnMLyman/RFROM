function [alpha_out,lat,lon]=j_grid_alpha(alpha,cds,wnum,len)


w=unique(wnum);

ii=find(len<0);alpha(ii)=[];len(ii)=[];w(ii)=[];
al=wnum*NaN;
for i=1:length(w)
  ii=find(w(i)==wnum);
  al(ii)=repmat(alpha(i),[length(ii) 1]);
  
end

ii=find(isnan(al));cds(ii,:)=[];al(ii)=[];
nn=ii;
clear wnum ii i len alpha bind n w ans tpx stanom
% grid alpha using weighted sum
tlat=[-85:10:85];tlon=[-175:10:175];
[ggy,ggx]=meshgrid(tlat,tlon);
alpha=NaN*ggy;
tic,for i=1:length(ggx(:))
  if ggx(i)<-160,ll=find(cds(:,1)>160);cds(ll,1)=cds(ll,1)-360;end
  if ggx(i)>160,ll=find(cds(:,1)<-160);cds(ll,1)=cds(ll,1)+360;end
  dt=sqrt((ggx(i)-cds(:,1)).^2/6^2+(ggy(i)-cds(:,2)).^2/3^2);
  ii=find(dt<3);
  if length(ii)<30,[poo,jj]=sort(dt);ii=jj(1:30);end
  alpha(i)=(exp(-dt(ii))'*al(ii))/sum(exp(-dt(ii)));
  
  if ggx(i)<-160,cds(ll,1)=cds(ll,1)+360;end
  if ggx(i)>160,cds(ll,1)=cds(ll,1)-360;end
  if mod(i,100)==0,disp(num2str([i toc])),end
end
alpha=reshape(alpha,[length(tlon),length(tlat)]);
tlon=[tlon(end)-360,tlon,tlon(1)+360];tlat=[-95,tlat,95];
alpha=[alpha(end,:);alpha;alpha(1,:)];

alpha=[0*tlon',alpha,0*tlon'];

alon=[-181:181];alat=[-91:91];clear poo
alpha_out=interp2(tlat,tlon,alpha,alat,alon','cubic');
load ../Mtpers/meanssh lat lon gmo sshcyc sshmean
lon=[lon(542:end)-360;lon(1:541)];
alpha_out=interp2(alat,alon,alpha_out,lat,lon');
