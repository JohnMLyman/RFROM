function [alat,alon,alpha,c,xvar]=compute_aplha(htanom,tpx,dt,cds,wnum)


% ripped out of Josh's code
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