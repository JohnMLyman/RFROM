
function subsect_allheat_josn(file_in,pos_good,file_out)

% subsect_allheat.m
% this code takes an allheat file and only keeps the casts in pos_good


eval(['load ' file_in]);

dt=dt(pos_good,:);
cds=cds(pos_good,:);
ht=ht(pos_good);
%htanom=htanom(pos_good);

tm=tm(pos_good);
wnum=wnum(pos_good);
t=t(pos_good,:);
s=s(pos_good,:);
%topex=topex(pos_good,:);
bt=bt(pos_good);
mdp=mdp(pos_good);
fn=fn(pos_good);
isu=isu(pos_good);
%dm=dm(pos_good);

eval(['save ' file_out ' ht s t cds dt tm wnum bt  mdp fn isu ']);

