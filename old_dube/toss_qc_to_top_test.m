% toss.m - matlab script to toss out profiles in all WMO squares
% with obviously spurious data and short profiles

w=sdir('./WOD05/qc/w7406.mat');

%d=[w',g',f'];clear w g f
 
d=[w'];clear w
% load topography data so that we can throw out profiles over land
%load ../topo/topo

tic
for i=1:length(d)
    load  /Users/johnlyman/data/Globalhc/topo/topo
  switch d(i).name(1)
    
    case 'w'
	eval(['load ./WOD05/qc/',d(i).name]);
    end
 if ~isempty(temp)
  ii=find(coords(:,1)<-180 | coords(:,1)>180 | ...
	coords(:,2)<-90 | coords(:,2)>90);

  if length(ii)<size(temp,1)
    iii=find(lon>min(coords(:,1))-.1 & lon<max(coords(:,1))+.1);
    jjj=find(lat>min(coords(:,2))-.1 & lat<max(coords(:,2))+.1);
    bath=interp2(lat(jjj),lon(iii),-topo(iii,jjj),coords(:,2),coords(:,1));
  else
    bath=ones(size(qual));
  end
clear topo
  jj=find(bath<0);

  ll=find(max(temp')'>35|min(temp')'<-3);

nn=find(isnan(nansum(temp')'));

  if size(mdep,1)==1,mdep=mdep';end
  mdp=ones(length(mdep),1)*depth;mdp(isnan(temp))=NaN;
  kk=find(mdep<=0|max(mdp')'<=0|max(mdp')'==NaN);

  nbath=length(jj);nrange=length(ll);nshort=length(kk);
  nnan=length(nn);
  ii=[ii;jj;ll;kk;nn];
  
  ntoss=length(unique(ii));

  coords(ii,:)=[];dt(ii,:)=[];time(ii,:)=[];mdep(ii)=[];
  npts(ii)=[];temp(ii,:)=[];qual(ii)=[];bath(ii)=[];
  typ(ii,:)=[];src(ii,:)=[];
  
  switch d(i).name(1)
    
    case 'w'
	cd './WOD05/qc/toss/test'
        ptype(ii)=[];
       temp_norm=temp;
	save(d(i).name,'coords','dt','depth','mdep','npts', ...
		'qual','temp','temp_norm','time','wodpkeep','nnan','ptype', ...
		'nbath','nrange','nshort','ntoss','bath','src','typ')
    clear('coords','dt','depth','mdep','npts', ...
		'qual','temp','temp_norm','time','wodpkeep','nnan','ptype', ...
		'nbath','nrange','nshort','ntoss','bath','src','typ')
    
  end

 eval(['cd ',path,'Globalhc/HC/'])
 end
 disp([d(i).name,'  ',num2str(toc)])
end

t=toc/3600;
save -ascii toss_time.txt t

