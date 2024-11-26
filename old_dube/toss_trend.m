% toss.m - matlab script to toss out profiles in all WMO squares
% with obviously spurious data and short profiles

w=sdir('./WOD05/trend/w*.mat');g=sdir('./GTSPP/netcdf/g*.mat');f=sdir('./Floats/f*.mat');


d=[w',g',f'];clear w g f
 
%d=[f;g];clear f g
% load topography data so that we can throw out profiles over land
%load ../topo/topo

tic
for i=1:length(d)
    load ../topo/topo
  switch d(i).name(1)
    case 'f'
	eval(['load ./Floats/',d(i).name]);
    case 'g'
	eval(['load ./GTSPP/netcdf/',d(i).name]);
    case 'w'
	eval(['load ./WOD05/trend/',d(i).name]);
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
  jj=find(bath<350);

  ll=find(max(temp')'>35|min(temp')'<-3);

nn=find(isnan(nansum(temp')'));

  if size(mdep,1)==1,mdep=mdep';end
  mdp=ones(length(mdep),1)*depth;mdp(isnan(temp))=NaN;
  kk=find(mdep<=350|max(mdp')'<=350|max(mdp')'==NaN);

  nbath=length(jj);nrange=length(ll);nshort=length(kk);
  nnan=length(nn);
  ii=[ii;jj;ll;kk;nn];ntoss=length(unique(ii));

  coords(ii,:)=[];dt(ii,:)=[];time(ii,:)=[];mdep(ii)=[];
  npts(ii)=[];temp(ii,:)=[];qual(ii)=[];bath(ii)=[];
  typ(ii,:)=[];src(ii,:)=[];
  
  switch d(i).name(1)
    case 'f'
	cd './Floats'
%	save(d(i).name,'coords','dt','depth','mdep','npts', ...
%		'qual','temp','time','bath','src','typ', ...
%		'nbath','nrange','nshort','ntoss','nnan','wmo_inst','id')
    clear('coords','dt','depth','mdep','npts', ...
		'qual','temp','time','bath','src','typ', ...
		'nbath','nrange','nshort','ntoss','nnan')
    case 'g'
	cd './GTSPP/netcdf'
        dpc(ii)=[];
       temp_norm(ii)=[];
%	save(d(i).name,'coords','dt','depth','mdep','npts', ...
%		'qual','temp','temp_norm','time','gpkeep','bath','src','typ', ...
%		'nbath','nrange','nshort','ntoss','nnan','dpc')
    clear('coords','dt','depth','mdep','npts', ...
		'qual','temp','temp_norm','time','gpkeep','bath','src','typ', ...
		'nbath','nrange','nshort','ntoss','nnan','dpc')
    case 'w'
	cd './WOD05/trend'
        ptype(ii)=[];
       temp_norm(ii)=[];
	save(d(i).name,'coords','dt','depth','mdep','npts', ...
		'qual','temp','temp_norm','time','wodpkeep','nnan','ptype', ...
		'nbath','nrange','nshort','ntoss','bath','src','typ')
    clear('coords','dt','depth','mdep','npts', ...
		'qual','temp','temp_norm','time','wodpkeep','nnan','ptype', ...
		'nbath','nrange','nshort','ntoss','bath','src','typ')
    
  end

	cd '/home/shoko2/wills/globalhc_dirs/Globalhc/HC'
 end
 disp([d(i).name,'  ',num2str(toc)])
end

t=toc/3600;
save -ascii toss_time.txt t

