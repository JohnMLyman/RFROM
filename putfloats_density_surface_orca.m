% putfloats.m - matlab script to breakup the float data into
% files corresponding to the WMO squares and save it to the
% directory with the WOD and GTSPP data.
% 1/3/3




load 'D:\CORIOLIS\pfloat_sal_density_density_surface.mat'
cds=coords;dt=date;tm=time;tmp=temp;np=npts;mdp=mdep;sl=sal;idd=id;qul=qual;
press=fpress;

clear coords date time temp npts mdep id sal id qual fpress

% remove floats with bad coords
ii=find(cds(:,1)==99999|cds(:,2)==99999|cds(:,2)>90|cds(:,1)<-180);
cds(ii,:)=[];dt(ii,:)=[];tm(ii,:)=[];
np(ii)=[];mdp(ii)=[];tmp(ii,:)=[];idd(ii,:)=[];press(ii,:)=[];sl(ii,:)=[];
qul(ii)=[];ddt=dt;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% loop to extract and save data into WOD squares (w????.mat files)

% calculate appropriate square for given lat and lon
iii=find(cds(:,1)<=0&cds(:,2)>0);
jjj=find(cds(:,1)>0 &cds(:,2)>0);
lll=find(cds(:,1)<=0&cds(:,2)<=0);
nnn=find(cds(:,1)>0 &cds(:,2)<=0);
wnum(iii)=abs(ceil(cds(iii,1)/10))+100*(ceil(cds(iii,2)/10)-1)+7000;
wnum(jjj)=ceil(cds(jjj,1)/10)-1+100*(ceil(cds(jjj,2)/10)-1)+1000;
wnum(lll)=abs(ceil(cds(lll,1)/10))+100*abs(ceil(cds(lll,2)/10))+5000;
wnum(nnn)=ceil(cds(nnn,1)/10)-1+100*abs(ceil(cds(nnn,2)/10))+3000;

w=unique(wnum);

tm=tm(:,1)+tm(:,2)/60+tm(:,3)/3600;
for i=1:length(w)
  ii=find(wnum==w(i));
  cnt(i)=length(ii);

  % create ?? variables and save them to ??.mat
  nm=num2str(w(i));
  temp=tmp(ii,:);
  coords=cds(ii,:);
  dt=ddt(ii,:);
  time=tm(ii,:);
  qual=qul(ii);
  mdep=mdp(ii);
  npts=np(ii);
  id=idd(ii,:);
  
  sal=sl(ii,:);
  fpress=press(ii,:);
  display(['f',nm])
  eval(['save ',path_sal,'den_den_no_f',nm,'.mat coords dt time ',...
        'temp qual depth mdep npts id sal fpress'])
end


