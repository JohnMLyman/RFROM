% fit_trend_seasonal_cycle_script3



TreeSetUp=TreeSetUp_2025_orca_temp_press_novert_paige_sulu;
[lon,lat,~,time,~]=load_netcdf_temp_depth(1,TreeSetUp);


dprs=[5,10+0*[1:17],15,20+0*[19:31],25,50+0*[33:50],75,100+0*[52:56],50];
prs=cumsum(dprs)-.5*dprs;
m=length(lon);
n=length(lat);
o=length(dprs);
p=length(time);
surf_area=nan(m,n);     

% for i2=1:n
%      surf_area(:,i2)=dist([lat(i2) lat(i2)],[-0.25 0.25]).*dist([lat(i2)-0.25,lat(i2)+0.25],[0 0]);
% end 

for i2=1:n
     surf_area(:,i2)=dist([lat(i2) lat(i2)],[-0.125 0.125]).*dist([lat(i2)-0.125,lat(i2)+0.125],[0 0]);
end 


mn_ct_res=NaN*ones(o,p);

[x,y]=meshgrid(lon,lat);
x=x';
y=y';

temp_to_W_per_dbar=NaN*ones(m,n,o);
cp0=gsw_cp0;

mn_ct=NaN*ones(n,o);
mn_ct_trnd=mn_ct;
mn_ct_atl=mn_ct;
mn_ct_pac=mn_ct;
mn_ct_ind=mn_ct;
mn_ct_med=mn_ct;
mn_ct_trnd_atl=mn_ct;
mn_ct_trnd_pac=mn_ct;
mn_ct_trnd_ind=mn_ct;
mn_ct_trnd_med=mn_ct;
hc_trnd=mn_ct;
hc_trnd_atl=mn_ct;
hc_trnd_pac=mn_ct;
hc_trnd_ind=mn_ct;
hc_trnd_med=mn_ct;


[LON,LAT]=ndgrid(lon,lat);
[global_basins]=find_basin_greg(LON,LAT);

pac_mask=NaN(m,n);
else_mask=pac_mask;
ind_mask=pac_mask;
atl_mask=pac_mask;

pac_mask(global_basins(2).pos)=1;
else_mask(global_basins(4).pos)=1;
atl_mask(global_basins(3).pos)=1;
ind_mask(global_basins(1).pos)=1;

mn_ct_trend_1d=nan(1,o);
mn_hc_trend_1d=mn_ct_trend_1d;
ct_res_std_total=nan(m,n,o);
ct_mod_coeffs=nan(m,n,o,13);
% % 
tic
for i1=1:o
  
  disp(['working on depth layer ', num2str(i1),' ',num2str(toc./60)])
    [ct_mod_coeffs_small,ct_res_std]=fit_trend_layer(TreeSetUp,i1);
    
    ct_mod_coeffs(:,:,i1,:)=ct_mod_coeffs_small;
    


    ct_res_std_total(:,:,i1)=ct_res_std;


    temp_to_W_per_dbar=1e4/(365.25*24*3600)*cp0*surf_area./(sw_g(-sw_dpth(prs(i1)+0*y,y),y));
    ju2=squeeze(ct_mod_coeffs_small(:,:,2));
    ju1=squeeze(ct_mod_coeffs_small(:,:,1));
    ju3=squeeze(temp_to_W_per_dbar);

    mn_ct(:,i1)=nanmean(ju1,1);
    mn_ct_trnd(:,i1)=nanmean(ju2,1);
    mn_ct_atl(:,i1)=nanmean(ju1.*atl_mask,1);
    mn_ct_trnd_atl(:,i1)=nanmean(ju2.*atl_mask,1);
    mn_ct_pac(:,i1)=nanmean(ju1.*pac_mask,1);
    mn_ct_trnd_pac(:,i1)=nanmean(ju2.*pac_mask,1);
    mn_ct_ind(:,i1)=nanmean(ju1.*ind_mask,1);
    mn_ct_trnd_ind(:,i1)=nanmean(ju2.*ind_mask,1);
    mn_ct_med(:,i1)=nanmean(ju1.*else_mask,1);
    mn_ct_trnd_med(:,i1)=nanmean(ju2.*else_mask,1);
    hc_trnd(:,i1)=nansum(ju2.*temp_to_W_per_dbar,1);
    hc_trnd_atl(:,i1)=nansum(ju2.*atl_mask.*temp_to_W_per_dbar,1);
    hc_trnd_pac(:,i1)=nansum(ju2.*pac_mask.*temp_to_W_per_dbar,1);
    hc_trnd_ind(:,i1)=nansum(ju2.*ind_mask.*temp_to_W_per_dbar,1);
    hc_trnd_med(:,i1)=nansum(ju2.*else_mask.*temp_to_W_per_dbar,1);
    ii=isfinite(ju2);
    mn_ct_trend_1d(i1)=sum(ju2(ii).*surf_area(ii))/sum(surf_area(ii));
    mn_hc_trend_1d(i1)=sum(ju2(ii).*ju3(ii));
end



% ct_mod_coeffs(ct_mod_coeffs==0)=nan;
figure
orient portrait
wysiwyg
plot(mn_ct_trend_1d*1e3,-prs,'linew',2)
set(gca,'box','on','tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'fontsize',16,'FontName','Arial','xtick',[0:2:20])
xlabel('Global Average C_T trend (m°C yr^{-1})')
ylabel('Pressure (dbar)')
grid on
print -dpng -r300 fig1
print -depsc2 fig1


figure(2)
orient landscape
wysiwyg

bar_junk=[nansum(hc_trnd_pac.*(ones(180*4,1)*dprs),2)/1e12,nansum(hc_trnd_atl.*(ones(180*4,1)*dprs),2)/1e12,nansum(hc_trnd_ind.*(ones(180*4,1)*dprs),2)/1e12,nansum(hc_trnd_med.*(ones(180*4,1)*dprs),2)/1e12];
ii=find(isfinite(bar_junk)==0);
bar_junk(ii)=0;
bar(lat,bar_junk,'stacked')
set(gca,'box','on','tickdir','out','xlim',[-68 72],'fontsize',16,'FontName','Arial')
xlabel('Latitude')
ylabel('Heat Content Trends (TW 0.25°latitude^{-1})')
legend('Pacific','Atlantic','Indian','Seas','Location','north')

print -dpng -r300 fig2
print -depsc2 fig2

figure
orient tall
wysiwyg

subplot(3,1,3)
contourf(lat,-prs,mn_ct_trnd_pac',[-1:.005:1],'w-')
hold on
contour(lat,-prs,mn_ct_trnd_pac',[0 0],'k-')
[cs,h]=contour(lat,-prs,mn_ct_pac',[0:5:30],'k-','linew',2);
clabel(cs,h);
clmap(23)
clim([-.055 .05])
set(gca,'box','on','tickdir','out','xlim',[-68 72],'ylim',[-2000 0],'fontsize',12,'FontName','Arial','ytick',[-2000:200:0],'yticklabels',[2000:-200:0])
title('(c) Pacific')
xlabel('Latitude')
ylabel('Pressure (dbar)')


subplot(3,1,2)
contourf(lat,-prs,mn_ct_trnd_atl',[-1:.005:1],'w-')
hold on
contour(lat,-prs,mn_ct_trnd_atl',[0 0],'k-')
[cs,h]=contour(lat,-prs,mn_ct_atl',[0:5:30],'k-','linew',2);
clabel(cs,h);
clmap(23)
clim([-.055 .05])
set(gca,'box','on','tickdir','out','xlim',[-68 72],'ylim',[-2000 0],'fontsize',12,'FontName','Arial','ytick',[-2000:200:0],'yticklabels',[2000:-200:0])
title('(b) Atlantic')
xlabel('Latitude')
ylabel('Pressure (dbar)')


subplot(3,1,1)
contourf(lat,-prs,mn_ct_trnd_ind',[-1:.005:1],'w-')
hold on
contour(lat,-prs,mn_ct_trnd_ind',[0 0],'k-')
[cs,h]=contour(lat,-prs,mn_ct_ind',[0:5:30],'k-','linew',2);
clabel(cs,h)
clmap(23)
clim([-.055 .05])
set(gca,'box','on','tickdir','out','xlim',[-68 72],'ylim',[-2000 0],'fontsize',12,'FontName','Arial','ytick',[-2000:200:0],'yticklabels',[2000:-200:0],'xtick',[-60:20:20])
title('(a) Indian')
xlabel('Latitude')
ylabel('Pressure (dbar)')

ax=axes('Position',[0.8950 0.7093 0.02 0.2157])
contourf([0 1],[-100:5:100],[[1 1]'*[-100:5:100]]',[-100:5:100],'w-');
hold on
contour([0 1],[-100:5:100],[[1 1]'*[-100:5:100]]',[0 0],'k-');
caxis([-55 50])
axis([0 1 -55 55])
set(gca,'box','on','tickdir','out','ytick',[-50:10:50],'fontsize',12,'FontName','Arial','xtick',[]);
ylabel('C_T trend (m°C yr^{-1})')

print -dpng -r300 fig3
print -depsc2 -vector fig3

figure
orient tall
wysiwyg

c1=subplot(2,1,1);
m_proj('Moll','lon',[30 390],'lat',[-90 90]);
m_contourf(lon,lat,squeeze(ct_mod_coeffs(:,:,20,2))'*1e3,[-200:10:200],'linewidth',0.01);
hold on
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,2))'*1e3,[0 0],'k-');
m_coast('patch',2/3*[1 1 1]);
m_grid('xtick',[0:30:390],'xticklabels',[],'ytick',[-90:30:90],'yticklabels',[]);
clmap(23)
caxis([-110 100])
title('(a) 200 dbar')
set(c1,'pos',[.13 .51 .775 .3412])


c2=subplot(2,1,2);
m_proj('Moll','lon',[30 390],'lat',[-90 90]);
m_contourf(lon,lat,squeeze(ct_mod_coeffs(:,:,34,2))'*1e3,[-200:10:200],'linewidth',0.01);
hold on
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,34,2))'*1e3,[0 0],'k-');
m_coast('patch',2/3*[1 1 1]);
m_grid('xtick',[0:30:390],'xticklabels',[],'ytick',[-90:30:90],'yticklabels',[]);
clmap(23)
clim([-110 100])
title('(b) 500 dbar')
set(c2,'pos',[.13 .49-.3412 .7715 .3412])


ax=axes('Position',[0.13 0.12 0.7715 0.02])
contourf([-200:10:200],[0 1],[[1 1]'*[-200:10:200]],[-200:10:200],'LineWidth',0.01);
hold on
contour([-200:10:200],[0 1],[[1 1]'*[-200:10:200]],[0 0],'k-');
clim([-110 100])
axis([-110 110 0 1])
set(gca,'box','on','tickdir','out','ytick',[-200:20:200],'fontsize',12,'FontName','Arial','ytick',[]);
xlabel('C_T trend (m°C yr^{-1})')

print -depsc2 -vector fig4
print -dpng -r300 fig4

inpac=find(lon>140&lon<155);
inatl=find(lon>285&lon<300);
ispac=find(lon>152.5&lon<167.5);
isatl=find(lon>315&lon<330);
isind=find(lon>30&lon<45);

figure
orient landscape
wysiwyg

cc=lines(7);

m_proj('Moll','lon',[30 390],'lat',[-90 90]);
[cs1,h1]=m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)-16*ct_mod_coeffs(:,:,20,2))',[15 15]);
% j1=clabel(cs1,h1);
hold on
[cs2,h2]=m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)+16*ct_mod_coeffs(:,:,20,2))',[15 15]);
% j2=clabel(cs2,h2);
set(h2,'color',cc(2,:));
set(h1,'color',cc(1,:))
m_coast('patch',2/3*[1 1 1]);
m_grid('xtick',[0:30:390],'xticklabels',[],'ytick',[-90:30:90],'yticklabels',[]);

print -depsc2 -vector fig5
print -dpng -r300 fig5





jf15=squeeze(ct_mod_coeffs(:,:,20,1)+16*ct_mod_coeffs(:,:,20,2))';
jf15=[jf15,jf15];

ji15=squeeze(ct_mod_coeffs(:,:,20,1)-16*ct_mod_coeffs(:,:,20,2))';
ji15=[ji15,ji15];



figure
orient tall
wysiwyg

subplot(5,2,1)
contourf(lat,-prs,squeeze(nanmean(ct_mod_coeffs(inpac,:,:,2),1))'*1e3,[-2000:10:2000],'k-','linew',0.1);
hold on
[cs,h]=contour(lat,-prs,squeeze(nanmean(ct_mod_coeffs(inpac,:,:,1),1))',[-2:2:32],'k-','linew',2);
axis([15 45 -1200 0]);
clabel(cs,h,'labelspacing',216)
clmap(23)
caxis([-110 100])
set(gca,'box','on','tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0])
title('(a) North Pacific')
xlabel('Latitude')
ylabel('Pressure (dbar)')


s2=subplot(5,2,2)
m_proj('mercator','lat',[25 40],'lon',[120 180])
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)+15*ct_mod_coeffs(:,:,20,2))',[15 15],'r-','linew',2)
hold on
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)-15*ct_mod_coeffs(:,:,20,2))',[15 15],'b-','linew',2)
m_plot([140 140],[25 40],'k-','linew',2)
m_plot([155 155],[25 40],'k-','linew',2)
m_coast('patch',2/3*[1 1 1]);
m_grid('tickdir','out','xtick',[30:10:380],'ytick',[-90:5:90])
title('(b) North Pacific')

subplot(5,2,3)
contourf(lat,-prs,squeeze(nanmean(ct_mod_coeffs(inatl,:,:,2),1))'*1e3,[-2000:10:2000],'k-','linew',0.1);
hold on
[cs,h]=contour(lat,-prs,squeeze(nanmean(ct_mod_coeffs(inatl,:,:,1),1))',[-2:2:32],'k-','linew',2);
axis([15 45 -1200 0]);
clabel(cs,h,'labelspacing',216)
clmap(23)
caxis([-110 100])
set(gca,'box','on','tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0])
title('(c) North Atlantic')
xlabel('Latitude')
ylabel('Pressure (dbar)')

subplot(5,2,4)
m_proj('mercator','lat',[30 45],'lon',[280 340])
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)+15*ct_mod_coeffs(:,:,20,2))',[15 15],'r-','linew',2)
hold on
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)-15*ct_mod_coeffs(:,:,20,2))',[15 15],'b-','linew',2)
m_plot([285 285],[30 45],'k-','linew',2)
m_plot([300 300],[30 45],'k-','linew',2)

m_coast('patch',2/3*[1 1 1]);
m_grid('tickdir','out','xtick',[30:10:380],'ytick',[-90:5:90])
title('(d) North Atlantic')

subplot(5,2,5)
contourf(lat,-prs,squeeze(nanmean(ct_mod_coeffs(ispac,:,:,2),1))'*1e3,[-2000:10:2000],'k-','linew',0.1);
hold on
[cs,h]=contour(lat,-prs,squeeze(nanmean(ct_mod_coeffs(ispac,:,:,1),1))',[-2:2:32],'k-','linew',2);
axis([-45 -15 -1200 0]);
clabel(cs,h,'labelspacing',216)
clmap(23)
caxis([-110 100])
set(gca,'box','on','tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0])
title('(e) South Pacific')
xlabel('Latitude')
ylabel('Pressure (dbar)')

subplot(5,2,6)
m_proj('mercator','lat',[-40 -25],'lon',[150 210])
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)+15*ct_mod_coeffs(:,:,20,2))',[15 15],'r-','linew',2)
hold on
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)-15*ct_mod_coeffs(:,:,20,2))',[15 15],'b-','linew',2)
m_plot([152.5 152.5],[-40 -25],'k-','linew',2)
m_plot([167.5 167.5],[-40 -25],'k-','linew',2)
m_coast('patch',2/3*[1 1 1]);
m_grid('tickdir','out','xtick',[30:10:380],'ytick',[-90:5:90])
title('(f) South Pacific')


subplot(5,2,7)
contourf(lat,-prs,squeeze(nanmean(ct_mod_coeffs(isatl,:,:,2),1))'*1e3,[-2000:10:2000],'k-','linew',0.1);
hold on
[cs,h]=contour(lat,-prs,squeeze(nanmean(ct_mod_coeffs(isatl,:,:,1),1))',[-2:2:32],'k-','linew',2);
axis([-45 -15 -1200 0]);
clabel(cs,h,'labelspacing',216)
clmap(23)
caxis([-110 100])
set(gca,'box','on','tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0])
title('(g) South Atlantic')
xlabel('Latitude')
ylabel('Pressure (dbar)')

subplot(5,2,8)
m_proj('mercator','lat',[-40 -25],'lon',[305 365])
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)+15*ct_mod_coeffs(:,:,20,2))',[15 15],'r-','linew',2)
hold on
m_contour(lon,lat,squeeze(ct_mod_coeffs(:,:,20,1)-15*ct_mod_coeffs(:,:,20,2))',[15 15],'b-','linew',2)
m_plot([315 315],[-40 -25],'k-','linew',2)
m_plot([330 330],[-40 -25],'k-','linew',2)
m_coast('patch',2/3*[1 1 1]);
m_grid('tickdir','out','xtick',[-360:10:380],'ytick',[-90:5:90])
title('(h) South Atlantic')


subplot(5,2,9)
contourf(lat,-prs,squeeze(nanmean(ct_mod_coeffs(isind,:,:,2),1))'*1e3,[-2000:10:2000],'k-','linew',0.1);
hold on
[cs,h]=contour(lat,-prs,squeeze(nanmean(ct_mod_coeffs(isind,:,:,1),1))',[-2:2:32],'k-','linew',2);
axis([-45 -15 -1200 0]);
clabel(cs,h,'labelspacing',216)
clmap(23)
caxis([-110 100])
set(gca,'box','on','tickdir','out','ytick',[-2000:200:0],'yticklabels',[2000:-200:0])
title('(i) South Indian')
xlabel('Latitude')
ylabel('Pressure (dbar)')

subplot(5,2,10)
m_proj('mercator','lat',[-42.5 -27.5],'lon',[15 75])
m_contour([lon-360;lon],lat,jf15,[15 15],'r-','linew',2)
hold on
m_contour([lon-360;lon],lat,ji15,[15 15],'b-','linew',2)
m_plot([30 30],[-42.5 -27.5],'k-','linew',2)
m_plot([45 45],[-42.5 -27.5],'k-','linew',2)
m_coast('patch',2/3*[1 1 1]);
m_grid('tickdir','out','xtick',[-360:10:380],'ytick',[-90:5:90])
title('(j) South Indian')

ax=axes('Position',[0.5703    0.09    0.3347    0.02])
contourf([-200:10:200],[0 1],[[1 1]'*[-200:10:200]],[-200:10:200],'LineWidth',0.01);
hold on
contour([-200:10:200],[0 1],[[1 1]'*[-200:10:200]],[0 0],'k-');
clim([-110 100])
axis([-110 110 0 1])
set(gca,'box','on','tickdir','out','ytick',[-200:20:200],'FontName','Arial','ytick',[]);
xlabel('C_T trend (m°C yr^{-1})')

print -depsc2 -vector fig6
print -dpng -r300 fig6

jul=datenum(1950,1,1); % julian days at 1 Jan 1950
greg=datevec(jul+double(time)); % get gregorian days
dyr=decyear(greg(:,1),greg(:,2),greg(:,3)); % change to decimal years

file_name=[TreeSetUp.path_Fig_data,TreeSetUp.tree_model_file_name_combined_withcycle,'_fit_maps.mat'];
save(file_name,'lon','lat','dyr','ct_mod_coeffs','ct_res_std_total','-v7.3')