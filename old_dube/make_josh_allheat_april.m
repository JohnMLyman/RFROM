clear

load allheat_josh_april_2007
load solofsi_floats fnums
% toss SOLO floats with FSI sensors




fsi_bind=ismember(fn,fnums);
ii=find(fsi_bind);
ccds=cds(ii,:);ddt=dt(ii,:);
poo=[dt,round(cds*10)];bah=[ddt,round(ccds*10)];
fsi_bind=ismember(poo,bah,'rows');


ii=find(fsi_bind); 
ii2=find(s(:,1)~='a'); 

ii3=unique([ii' ii2']');

ii=ii3;

clear ii3 ii2

wnum(ii,:)=[];
topex(ii,:)=[];
tm(ii,:)=[];
t(ii,:)=[];
s(ii,:)=[];
poo(ii,:)=[];
np(ii)=[];
mdp(ii)=[];
isu(ii)=[];
htanom(ii)=[];
fsi_bind(ii)=[];
ht(ii)=[];
fn(ii)=[];
dt(ii,:)=[];
dm(ii)=[];
cds(ii,:)=[];
bt(ii)=[];


save allheat_josh_april_argo wnum topex tm t s poo np mdp isu htanom fsi_bind ...
	ht fn dt dm cds bt



