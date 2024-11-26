function [ind_dup,s,t]=remove_duplicates(cds,ddt,tm,s,t,np)

% this code finds duplicates in the GTSPP WOD05 and Argo float program.  If
% a duplicate is find it will first though out GTSPP than WOD05 

%           Inputs 
% s and array of type of Data base
% t type of profile 
% np number of points in a profile
% cds the cordintes of the profile
% ddt the date of the profile
% tm the time of the profile


%           Returns
% s with duplicates removed
% t with duplicates removed
% ind_dup the indcies of the duplicate profiles

if ~isempty(cds)
  % sort profiles by date and location
  day=datenum([ddt,tm,zeros(length(tm),2)]);
  [poo,ii]=sortrows(round([cds*1000,day*100]));
  [poo2,ii2]=sortrows(round([cds*1000,day*100]));

  % throw out profiles that are too close or if in the same data set have
  % the same location
  
  bah=sqrt(diff(poo(:,1)).^2+diff(poo(:,2)).^2+diff(poo(:,3)).^2);
  bah3=sqrt(diff(poo2(:,1)).^2+diff(poo2(:,2)).^2+diff(poo2(:,3)).^2);
  poop=s;poop(poop=='a')='f';poop(poop=='A')='f';
  bah2=poop(ii(1:end-1),1)==poop(ii(2:end),1);  % test for same dataset
  jj1=[];jj2=[];
  
 if ~isempty(bah)&~isempty(bah2)
   jj1=find(bah==0&~bah2);
 end
 
 if ~isempty(bah3)
     jj2=find(bah3==0);
 end
 
 

ind=[[ii(jj1)' ii2(jj2)']' [ii(jj1+1)' ii2(jj2+1)']'];  % indicies of redundant profiles
   
  % remove dups.
  ndups=size(ind,1);
  % going to trick this now so that we always throw out GTSPP if
  % given the choice, than the world ocean data base
  
 np(s(:,1)=='G')=1;
  np(s(:,1)=='W')=2;np(s(:,1)=='A')=3;np(s(:,1)=='a')=3;
  
  if ndups>0
    % check which version had more original data points
    swtch=np(ind(:,1))>np(ind(:,2));
    nn=find(swtch);
    ind(nn,:)=ind(nn,[2 1]);

    ind_dup=ind(:,1);
   
    
    poo=strcat(s(ind(:,2),:),s(ind(:,1),:));
    s(ind(:,2),1:size(poo,2))=poo;s(ind(:,1),:)=[];clear poo
    poo=strcat(t(ind(:,2),:),t(ind(:,1),:));
    t(ind(:,2),1:size(poo,2))=poo;t(ind(:,1),:)=[];clear poo
  else
    ind_dup=[];
  end
 else
  nkept=0;ndups=0;ntot=0; ind_dup=[];
 end
