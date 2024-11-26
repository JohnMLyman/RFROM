% the new qc file qc3




 
%load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/total_den_grid_april_28.mat

%load bad_ind_3degree
load bad_ind
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% loop to extract and save data into WOD squares (w????.mat files)

% calculate appropriate square for given lat and lon

iii=find(coords_tot(:,1)<=0&coords_tot(:,2)>0);
jjj=find(coords_tot(:,1)>0 &coords_tot(:,2)>0);
lll=find(coords_tot(:,1)<=0&coords_tot(:,2)<=0);
nnn=find(coords_tot(:,1)>0 &coords_tot(:,2)<=0);
wnum(iii)=abs(ceil(coords_tot(iii,1)/10))+100*(ceil(coords_tot(iii,2)/10)-1)+7000;
wnum(jjj)=ceil(coords_tot(jjj,1)/10)-1+100*(ceil(coords_tot(jjj,2)/10)-1)+1000;
wnum(lll)=abs(ceil(coords_tot(lll,1)/10))+100*abs(ceil(coords_tot(lll,2)/10))+5000;
wnum(nnn)=ceil(coords_tot(nnn,1)/10)-1+100*abs(ceil(coords_tot(nnn,2)/10))+3000;

w=unique(wnum);


 s=size(press_0_tot);
 nd=s(2);
 

 bad_coords=coords_tot(:,1);
 bad_coords(bad)=NaN;
 
sub_set_ii=[4 18 34 36 54 55 56 67 92 120 130 164 165]


for i=346:length(w)

% for i2=1:length(sub_set_ii)
%     i=sub_set_ii(i2);
    
    
    
    good_place=find(wnum==w(i));


 if length(good_place) >=2 
     
     
    jj=find( finite(bad_coords(good_place)) == 0); 
 
 
scrsz = get(0,'ScreenSize');

h=figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5]);  


% subsect data

     temp=temp_tot(good_place,:);
     sal=sal_tot(good_place,:);
     fpress=fpress_tot(good_place,:);
    coords=coords_tot(good_place,:);
    dt=dt_tot(good_place,:);
    ratio_bad=ratio_bad_tot(good_place);
    
    
    press_0=press_0_tot(good_place,:);
    sal_0=sal_0_tot(good_place,:);
    temp_0=temp_0_tot(good_place,:);
    
    press_gam=press_gam_tot(good_place,:);
    sal_gam=sal_gam_tot(good_place,:);
    temp_gam=temp_gam_tot(good_place,:);

  theta = sw_ptmp(sal,temp,fpress,0);
  %find the right dates (ie only preform the qc on the times that
  % I cheacked.


sal_all=sal;
temp_all=temp;
fpress_all=fpress;
depth_all=fpress;
theta_all=theta;

temp(jj,:)=[];
sal(jj,:)=[];
theta(jj,:)=[];
fpress(jj,:)=[];
depth=fpress;







s_temp=size(temp)
if s_temp(1) > 1 & s_temp(2) >1

subplot(2,4,1)
plot(sal_all,-1.*depth_all,'.')
hold on
plot(sal_all(jj,:),-1.*depth_all(jj,:),'r.')
hold off
title('all ');
xlabel('salinity');
ylabel('depth');

%plotting all the data
      
subplot(2,4,2)
plot(temp_all,-1.*depth_all,'.')
hold on
plot(temp_all(jj,:),-1.*depth_all(jj,:),'r.')
hold off

title(['all ',w(i)]);
xlabel('temp');
ylabel('depth');
%axis([30 40 -200 -100])
%plotting bad data

subplot(2,4,3)
plot(temp,-1.*depth,'.');
title('good temp ');


% 
subplot(2,4,4)
 d=sdir(['grad_den_0_grid_aden_den_no_*.mat']);
plot(sal,-1*depth,'.');
title('good sal');

subplot(2,4,8 )
% 
 plot(sal_all',theta_all','.r')
 title(['Theta S ',num2str(round(100*length(jj)./length(good_place))),' %. ', num2str(i)])
hold on 
plot (sal',theta','.k')
hold off

%plotting the map

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

m_plot(coords(jj,1),coords(jj,2),'.r')
hold off

%plotting month


% subplot(2,4,6)
% 
% plot(dt(:,2),'.b')
% 
% hold on
% 
% plot(dt(jj,2),'.r')
% xlabel('index');
% ylabel('month');
% hold off
% 
% %plotting year
% 
subplot(2,4,7)

plot(dt(:,1),'.b')
 

hold on

plot(dt(jj,1),'.r')
xlabel('index');
ylabel('year');
hold off


pause

close all

end
end
end
