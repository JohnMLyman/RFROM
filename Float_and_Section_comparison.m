clear
close all
load('/Users/gjohnson/a16n/y2013/a16n_13_ctd.mat');
ii=find(lat>7/8);
[jj,kk]=sort(lat(ii));
ii=ii(kk);
lat3=lat(ii);
lon3=lon(ii)+360;
dyr3=dyr(ii);
pr3=pr(1:2000);
te3=te(1:2000,ii);
sp3=sa(1:2000,ii);

load('/Users/gjohnson/a16s/a16s_2014/a16s_14_merged.mat')
sp2=sa2(1:2000,:);
te2=te2(1:2000,:);
pr2=pr2(1:2000);

lat2=[lat2;lat3];
lon2=[lon2+360;lon3];
dyr2=[dyr2;dyr3];
te2=[te2,te3];
sp2=[sp2,sp3];

sa2=gsw_SA_from_SP(sp2,pr2,lon2,lat2);
ct2=gsw_CT_from_t(sa2,te2,pr2);


dd=dir('/Users/gjohnson/RFROM/RFROM_TEMP_STABLE_mask_1x1xmonth.nc');
ee=dir('/Users/gjohnson/RFROM/RFROM_SAL_STABLE_mask_1x1xmonth.nc');
lat=double(ncread(['/Users/gjohnson/RFROM/',dd(1).name],'latitude'));
lon=double(ncread(['/Users/gjohnson/RFROM/',dd(1).name],'longitude'));
prs=double(ncread(['/Users/gjohnson/RFROM/',dd(1).name],'mean_pressure'));
prbdry=double(ncread(['/Users/gjohnson/RFROM/',dd(1).name],'mean_pressure_bnds'));

tim=double(ncread(['/Users/gjohnson/RFROM/',dd(1).name],'time'));
ct=double(ncread(['/Users/gjohnson/RFROM/',dd(1).name],'ocean_temperature'));
sa=double(ncread(['/Users/gjohnson/RFROM/',ee(1).name],'ocean_salinity'));
i1=find(lon>30);
i2=find(lon<30);
lon=[lon(i1);lon(i2)+360];
ct=cat(1,ct(i1,:,:,:),ct(i2,:,:,:));
sa=cat(1,sa(i1,:,:,:),sa(i2,:,:,:));
jul=julian(1950,1,1,0); % julian days at 1 Jan 1950
greg=gregorian(jul+tim); % get gregorian days
dyr=decyear(greg(:,1),greg(:,2),greg(:,3),greg(:,4)); % change to decimal years

ct3=NaN*ones(length(lat2),length(prs));
sa3=ct3;
sa4=ct3;
ct4=ct3;
for i1=1:length(lat2)
for i2=1:58
ct3(i1,i2)=interpn(lon,lat,prs,dyr,ct,lon2(i1),lat2(i1),prs(i2),dyr2(i1));
sa3(i1,i2)=interpn(lon,lat,prs,dyr,sa,lon2(i1),lat2(i1),prs(i2),dyr2(i1));
ii=find(pr2>prbdry(1,i2)&pr2<prbdry(2,i2));
ct4(i1,i2)=nanmean(ct2(ii,i1));
sa4(i1,i2)=nanmean(sa2(ii,i1));
end
end

load /Users/gjohnson/lyman_data/

ii=find(id==3900556);
data=data(ii,:);
date=date(ii,:);
time=time(ii,:);
lon5=coords(ii,1)+360;
lat5=coords(ii,2);

dyr5=decyear(date(:,1),date(:,2),date(:,3),time(:,1),time(:,2)+time(:,3)/60);

for i1=1:length(dyr5)
    jute=double(cell2mat(data(i1,1)));
    jusp=double(cell2mat(data(i1,2)));
    jupr=double(cell2mat(data(i1,3)));
    jusa=gsw_SA_from_SP(jusp,jupr,lon5(i1)-360,lat5(i1));
    juct=gsw_CT_from_t(jusa,jute,jupr);
    ct5(i1,:)=interp1([0,jupr],[juct(1),juct],prs);
    sa5(i1,:)=interp1([0,jupr],[jusa(1),jusa],prs);
    for i2=1:58
        ct6(i1,i2)=interpn(lon,lat,prs,dyr,ct,lon5(i1),lat5(i1),prs(i2),dyr5(i1));
        sa6(i1,i2)=interpn(lon,lat,prs,dyr,sa,lon5(i1),lat5(i1),prs(i2),dyr5(i1));
    end
end


figure
orient tall
wysiwyg
subplot(3,1,1)
[cs,h]=contourf(dyr5,-prs,ct5',[-2:32]);
clabel(cs,h)
title('C_T: Observations (CI 1.0)');
ylabel('Pressure (dbar)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[2000:.5:2025])
clmap(23)
clim([2 26]);
axis([min(dyr5) max(dyr5) -800 0])
subplot(3,1,2)
[cs,h]=contourf(dyr5,-prs,ct6',[-2:32]);
clabel(cs,h)
axis([min(dyr5) max(dyr5) -800 0])
title('C_T: Maps (CI 1.0)');
ylabel('Pressure (dbar)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[2000:.5:2025])
clim([2 26]);
subplot(3,1,3)
[cs,h]=contourf(dyr5,-prs,ct5'-ct6',[-5:.2:5]);
clabel(cs,h);
axis([min(dyr5) max(dyr5) -800 0])
set(gca,'tickdir','out')
title('C_T: Observations-Maps (CI 0.2)');
ylabel('Pressure (dbar)')
xlabel('Time (yr)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[2000:.5:2025])
clim(2*[-1.05 1])

print -dpng -r300 float_comparison_CT
print -dpdf -vector float_comparison_CT




figure
orient tall
wysiwyg
subplot(3,1,1)
[cs,h]=contourf(dyr5,-prs,sa5',[30:.2:40]);
clabel(cs,h)
title('S_A: Observations (CI 0.2)');
ylabel('Pressure (dbar)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[2000:.5:2025])
clmap(23)
clim([34.5 36.5]);
axis([min(dyr5) max(dyr5) -800 0])
subplot(3,1,2)
[cs,h]=contourf(dyr5,-prs,sa6',[-30:.2:40]);
clabel(cs,h)
axis([min(dyr5) max(dyr5) -800 0])
title('S_A: Maps (CI 0.2)');
ylabel('Pressure (dbar)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[2000:.5:2025])
clim([34.5 36.5]);
subplot(3,1,3)
[cs,h]=contourf(dyr5,-prs,sa5'-sa6',[-5:.05:5]);
clabel(cs,h);
axis([min(dyr5) max(dyr5) -800 0])
set(gca,'tickdir','out')
title('S_A: Observations-Maps (CI 0.05)');
ylabel('Pressure (dbar)')
xlabel('Time (yr)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[2000:.5:2025])
clim(0.5*[-1.05 1])

print -dpng -r300 float_comparison_SA
print -dpdf -vector float_comparison_SA



figure
orient tall
wysiwyg
subplot(3,1,1)
[cs,h]=contourf(lat2,-prs,ct4',[-2:32]);
clabel(cs,h)
title('C_T: Observations (CI 1.0)');
ylabel('Pressure (dbar)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[-90:10:90])
clmap(23)
clim([-2 28]);
axis([min(lat2) max(lat2) -2000 0])
subplot(3,1,2)
[cs,h]=contourf(lat2,-prs,ct3',[-2:32]);
clabel(cs,h)
axis([min(lat2) max(lat2) -2000 0])
title('C_T: Maps (CI 1.0)');
ylabel('Pressure (dbar)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[-90:10:90])
clim([-2 28]);
subplot(3,1,3)
[cs,h]=contourf(lat2,-prs,ct4'-ct3',[-5:.2:5]);
clabel(cs,h);
axis([min(lat2) max(lat2) -2000 0])
set(gca,'tickdir','out')
title('C_T: Observations-Maps (CI 0.2)');
ylabel('Pressure (dbar)')
xlabel('Latitude (°)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[-90:10:90])
clim(2*[-1.05 1])

print -dpng -r300 A16_comparison_CT
print -dpdf -vector A16_comparison_CT




figure
orient tall
wysiwyg
subplot(3,1,1)
[cs,h]=contourf(lat2,-prs,sa4',[30:.2:40]);
clabel(cs,h)
title('S_A: Observations (CI 0.2)');
ylabel('Pressure (dbar)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[-90:10:90])
clmap(23)
clim([33.5 37.5]);
axis([min(lat2) max(lat2) -2000 0])
subplot(3,1,2)
[cs,h]=contourf(lat2,-prs,sa3',[-30:.2:40]);
clabel(cs,h)
axis([min(lat2) max(lat2) -2000 0])
title('S_A: Maps (CI 0.2)');
ylabel('Pressure (dbar)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[-90:10:90])
clim([33.5 37.5]);
subplot(3,1,3)
[cs,h]=contourf(lat2,-prs,sa4'-sa3',[-5:.05:5]);
clabel(cs,h);
axis([min(lat2) max(lat2) -2000 0])
set(gca,'tickdir','out')
title('S_A: Observations-Maps (CI 0.05)');
ylabel('Pressure (dbar)')
xlabel('Latitude (°)')
set(gca,'tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[-90:10:90])
clim(0.5*[-1.05 1])

print -dpng -r300 A16_comparison_SA
print -dpdf -vector A16_comparison_SA



