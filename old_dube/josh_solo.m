
load solofsi_floats fnums
% toss SOLO floats with FSI sensors
fsi_bind=ismember(fn,fnums);
ii=find(fsi_bind);
ccds=cds(ii,:);ddt=dt(ii,:);
poo=[dt,round(cds*10)];bah=[ddt,round(ccds*10)];
fsi_bind=ismember(poo,bah,'rows');

clear ii
 ii=find(fsi_bind); %will be the indicies of the bad floats...
