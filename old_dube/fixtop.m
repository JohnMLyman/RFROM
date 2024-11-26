% fixtop.m - matlab script to put in surface values for profiles
% that missed the top few depth bins.  The profiles are assumed
% to have a mixed layer with the same temperature as the topmost
% point for all temps. above the end of the data.  This is done
% down to 50 m.  To see how many profiles were corrected this
% way see nantoss.mat
cd './All_Data'

d=sdir('d*.mat');


tic,for i=1:length(d)
  load(d(i).name)
  
  for j=13:-1:1
    ii=find(isnan(temp(:,j)));temp(ii,j)=temp(ii,j+1);
    nlen(j)=length(ii);
  end

  ii=find(isnan(sum(temp(:,1:176)')'));

  oldlen(i)=size(temp,1);

  coords(ii,:)=[];dt(ii,:)=[];mdep(ii)=[];qual(ii)=[];
  temp(ii,:)=[];time(ii,:)=[];npts(ii)=[];bath(ii)=[];
  src(ii,:)=[];typ(ii,:)=[];isunk(ii)=[];

  newlen(i)=size(temp,1);
  nantoss(i)=length(ii);
    
  
  save(d(i).name,'coords','dt','depth','mdep','ndups','nkept', ...
        'npts','ntot','qual','temp','time','bath','src','typ','isunk')
  
  disp([num2str([i toc],5),'  ',d(i).name(1:5)]);
end
cd '..'

save nantoss newlen nantoss oldlen

