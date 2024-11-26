
cd /Users/johnlyman/data/Globalhc/HC/
load allheat
cds_4deg=round(cds/4);
yr=datenum(dt(:,1),dt(:,2),dt(:,3));
yr_30=round(yr/30);
xbt=find(t(:,1)=='X');
ctd=find(t(:,1)=='C');

cds_ctd=cds_4deg(ctd,:);
cds_xbt=cds_4deg(xbt,:);

time_ctd=yr_30(ctd);
time_xbt=yr_30(xbt);

ht_ctd=ht(ctd);
ht_xbt=ht(xbt);

[v,pos_ctd]=unique(cds_ctd(:,1)+180+(cds_ctd(:,2)+90)*1000+time_ctd*1000000);

n_ctd=length(pos_ctd);

xbt_median=ones(n_ctd,1)*NaN;
nxbt=xbt_median;
ctd_median=xbt_median;
nctd=xbt_median;

time_median=xbt_median;
cds_median=ones(n_ctd,2)*NaN;


for ipos=1:n_ctd

good_ctd=find(cds_ctd(:,1)==cds_ctd(pos_ctd(ipos),1) & ...
              cds_ctd(:,2)==cds_ctd(pos_ctd(ipos),2) & ... 
              time_ctd==time_ctd(pos_ctd(ipos)));
          
good_xbt=find(cds_xbt(:,1)==cds_ctd(pos_ctd(ipos),1) & ...
              cds_xbt(:,2)==cds_ctd(pos_ctd(ipos),2) & ... 
              time_xbt==time_ctd(pos_ctd(ipos)));
          
ctd_median(ipos)=median(ht_ctd(good_ctd));
nctd(ipos)=length(good_ctd);
xbt_median(ipos)=median(ht_xbt(good_xbt));
nxbt(ipos)=length(good_xbt);

time_median(ipos)=time_ctd(pos_ctd(ipos))*30;
cds_median(ipos,1)=cds_ctd(pos_ctd(ipos),1)*4;
cds_median(ipos,2)=cds_ctd(pos_ctd(ipos),2)*4;


end
