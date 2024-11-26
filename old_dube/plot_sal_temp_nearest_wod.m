
d=sdir(['grad_den_0_grid_aden_den_no_*.mat']);


d=sdir(['wod_den_*.mat']); 


for i=1:length(d)

% for i2=1:length(sub_set_ii)
%     i=sub_set_ii(i2);
    file_name=d(i).name
     wmo_number=str2num(file_name(21:24));
    
    if (exist([d(i).name]) & exist(['ind_grad_den_0_grid_aden_den_no_f',num2str(wmo_number),'.mat']))
        
    eval(['load ',d(i).name]);
    eval(['load ind_grad_den_0_grid_aden_den_no_f',num2str(wmo_number),'.mat'])
   
scrsz = get(0,'ScreenSize');

h=figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5]);  
ratio_bad_total=length(bad_total)/length(mdep);
ratio_bad_wod=length(bad_wod)/length(mdep);

sal_wod=sal_0;
temp_wod=temp_0;
press_wod=press_0;

sal_wod(bad_wod,:)=[];
temp_wod(bad_wod,:)=[];
press_wod(bad_wod,:)=[];

sal_all=sal_0;
temp_all=temp_0;
press_all=press_0;

sal_all(bad_total,:)=[];
temp_all(bad_total,:)=[];
press_all(bad_total,:)=[];





subplot(4,2,1)

hold on
plot(sal_0',temp_0','r.')
plot(sal_all',temp_all','.')
title([num2str(100*ratio_bad_total),' %']);

hold off

subplot(4,2,2)
hold on
plot(sal_0',temp_0','r.')
plot(sal_wod',temp_wod','.')



title([num2str(100*ratio_bad_wod),' %']);

hold off

subplot(4,2,3)

hold on
plot(sal_0',-press_0','r.')
plot(sal_all',-press_all','.')


hold off

subplot(4,2,4)
hold on
plot(sal_0',-press_0','r.')
plot(sal_wod',-press_wod','.')
hold off


subplot(2,4,5)
m_ungrid m_proj;
m_proj('Miller Cylindrical');
 m_coast;
 m_grid;
 hold on
m_plot(coords(:,1),coords(:,2),'.k')

%m_plot(coords(jj,1),coords(jj,2),'.r')
hold off

%blowup
subplot(2,4,6)
m_ungrid m_proj;
m_proj('Miller Cylindrical','longitudes',[min(coords(:,1)) max(coords(:,1))], ...
       'latitudes',[min(coords(:,2)) max(coords(:,2))]);
 m_coast;
 m_grid;
hold on 
m_plot(coords(:,1),coords(:,2),'.k')

m_plot(coords(bad_wod,1),coords(bad_wod,2),'.r')
hold off


subplot(2,4,7)
m_ungrid m_proj;
m_proj('Miller Cylindrical','longitudes',[min(coords(:,1)) max(coords(:,1))], ...
       'latitudes',[min(coords(:,2)) max(coords(:,2))]);
 m_coast;
 m_grid;
hold on 
m_plot(coords(:,1),coords(:,2),'.k')

m_plot(coords(bad_total,1),coords(bad_total,2),'.r')

title([d(i).name])
hold off


clear bad_total  bad_wod  coords   density_surface  dg_hi  ...
    dg_lo  dt  fpress  gam  id  mdep  npts  per_bad_grad  ...
    press_0  press_all  press_bot_0  press_bot_gam  press_gam  press_top_0 ...
    press_top_gam  press_wod  qual  ratio_bad  ratio_bad_total ...
    ratio_bad_wod  sal  sal_0  sal_all  sal_gam  sal_wod  ...
    temp  temp_0  temp_all  temp_gam  temp_wod  time



pause

close all

end
end

