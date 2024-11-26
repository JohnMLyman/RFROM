% remdups.m - matlab script to remove duplicates between
% the WOD01, GTSPP, and float data
% 1/7/3

w=sdir('./WOD05/toss/w*.mat');

ww=strvcat(w(:).name);ww=str2num(ww(:,2:5));

d=ww;clear w  ww 

tic
for i=1:length(d)
 
  
 
 
    load(['./WOD05/toss/w',num2str(d(i)),'.mat']);
   
    isunk=zeros(size(mdep));isunk(((ptype==2|ptype==0)&mdep<840))=1;
    
    %remove argo floats
%     
%     argo=find(strcmp(cellstr(typ),'PF') ==1);
%      
%      cds(argo,:)=[];ddt(argo,:)=[];mdp(argo)=[];np(argo)=[];tm(argo)=[];ql(argo)=[];
%      s(argo)=[];,t(argo,:)=[];bt(argo)=[];tmp(argo,:)=[];
%      isu(argo)=[];
    
       

  ntot=length(mdep);
% %  %%%%%%%%%Remove the duplicates once
% %     [ind_dup,s,t]=remove_duplicates(cds,ddt,tm,s,t,np);
% %  
% %     tmp(ind_dup,:)=[];cds(ind_dup,:)=[];ddt(ind_dup,:)=[];
% %     tm(ind_dup,:)=[];mdp(ind_dup)=[];np(ind_dup)=[];
% %     ql(ind_dup)=[];bt(ind_dup)=[];isu(ind_dup)=[];
% %     nkept=length(mdp);
% %     ndups=length(ind_dup);
% %  %%%%%%%%Remove the duplicates a second time to make sure that a float was
% %  %%%%%%%%not in all three data bases.
% %     
% %     [ind_dup,s,t]=remove_duplicates(cds,ddt,tm,s,t,np);
% %  
% %     tmp(ind_dup,:)=[];cds(ind_dup,:)=[];ddt(ind_dup,:)=[];
% %     tm(ind_dup,:)=[];mdp(ind_dup)=[];np(ind_dup)=[];
% %     ql(ind_dup)=[];bt(ind_dup)=[];isu(ind_dup)=[];
% %     nkept2=length(mdp);
% %  
% %     ndups2=length(ind_dup);
 ndups=0;nkept=length(time);ndups2=0;
  % save to new file
  save(['./All_Data/d',num2str(d(i)),'.mat'],'temp','coords','dt','npts','time', ...
	'depth','mdep','qual','ntot','ndups','nkept','src','typ','bath', ...
	'isunk','ndups2','nkept','oclnum')
  
  disp(['d',num2str(d(i)),'  ',num2str(toc)])

end

t=toc/3600;

 save -ascii dup_time.txt t

