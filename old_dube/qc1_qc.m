% qc1.m - matlab file to do initial QC pass on d????.mat files
% after they have been consolidated by remdups.m and toss.m has been run
% 2/25/3

% initial qc done by throwing out all profiles with points > 6 stds
% away from the mean at any depth below 120m.  In a few boxes, this
% will not do, so they need to be handled seperately

cd './All_Data/qc'
d=dir('d*.mat');[dd,ii]=sortrows(strvcat(d(:).name));
d=d(ii);clear dd ii

% loop through files and perform qc
tic,for i=1:length(d)
  load(d(i).name);
  tm=nanmean(temp);td=nanstd(temp);
  tanom=temp-repmat(tm,[size(temp,1),1]);
  ind=abs(tanom)>repmat(6*td,[size(temp,1),1]);
  ii=find(sum(ind(:,61:end)')');

  % take care of special cases
  switch str2num(d(i).name(2:5))
    case 1113   %  d1113 - throw out profiles with T==0
	jj=find(min(temp')'<=0);
	ii=[ii;jj]; clear jj
    case 1214   %  d1214 - std too narrow at thermocline
	ii=find(max(temp(:,381:end)')'>=8.5 | temp(:,51) < 11 | ...
		max(temp(:,151:end)')'>=19.5);
    case 1414   %  d1414 - of tossed, KEEP t>10.5 and <12 at z=350
	jj=find(temp(ii,176)<12&temp(ii,176)>10.5);
        ii(jj)=[]; clear jj
    case 3116
	jj=find(max(temp(:,341:end)')'>10);
	ii=[ii;jj]; clear jj
    case num2cell([3010,3011,3200:3217,3300:3317,5000,5204:5207,5300:5317])
	jj=find(min(temp')'<=2);
	ii=[ii;jj]; clear jj
    case 3101   %   get rid of a few by hand
	ii=find(temp(:,46)>18);
    case {3106,3107}   %   get rid of a few by hand
	ii=find(temp(:,281)>14);
    case {3403,5400,5407,5408}
	jj=find(min(temp')'<=.1);
	ii=[ii;jj]; clear jj
    case num2cell([3412:3417,3512:3517])
	jj=find(temp(:,201)<.5);
	ii=[ii;jj]; clear jj
    case num2cell([7009,7011:7017,7109,7312,7313])
        ii=find(sum(ind(:,139:end)')');
    case 7207  %  d7207 - throw out T<5.5 & T>21 for z>400
	ii=find(min(temp(:,201:end)')'<5.5 | max(temp(:,201:end)')'>21);
    case num2cell([7304:7307])  %  d7304-7307 - throw out T<4 & T>21 for z>400 
	jj=find(min(temp(:,201:end)')'<4 | max(temp(:,201:end)')'>21);
	ii=[ii;jj]; clear jj
    case num2cell([7400:7403,7501:7503]) % d7400-7403,7501-7503 - throw out T<2
	jj=find(min(temp')'<=2);
	ii=[ii;jj]; clear jj
    case 7404  %  d7404 - throw out T<2 at z>500
	jj=find(min(temp(:,251:end)')'<=2);
	ii=[ii;jj]; clear jj
    case num2cell([7501:7503]) % d7501-7503 - throw out T<2 
	jj=find(min(temp')'<=2);
	ii=[ii;jj]; clear jj
    case {7504,7604}  %  d7504 - throw out T<2 at z>300
	jj=find(min(temp(:,151:end)')'<=2);
	ii=[ii;jj]; clear jj
    case num2cell([7514:7517]) % d7514-7517 - throw out T<=0
	jj=find(min(temp')'<=0);
	ii=[ii;jj]; clear jj
    case 7600  %  d7600 - kill T>11 at z>100 ONLY
	ii=find(max(temp(:,51:end)')'>=11);
    case 7603  %  d7603 - std>6.5
	ind=abs(tanom)>repmat(6.5*td,[size(temp,1),1]);
	ii=find(sum(ind(:,61:end)')');
  end

  oldlen(i)=size(temp,1);
  qc1toss(i)=length(ii);

  coords(ii,:)=[];dt(ii,:)=[];mdep(ii)=[];qual(ii)=[];
  temp(ii,:)=[];time(ii,:)=[];npts(ii)=[];
  typ(ii,:)=[];src(ii,:)=[];bath(ii)=[];isunk(ii)=[];

  save(d(i).name,'coords','dt','depth','mdep','ndups','nkept', ...
	'npts','ntot','qual','temp','time','typ','src','bath','isunk')

  disp([num2str([i toc],5),'  ',d(i).name(1:5)]);

end

cd '../../'

save qc1num oldlen qc1toss




