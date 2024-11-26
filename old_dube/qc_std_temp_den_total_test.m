% the new qc file qc3


 h=figure(1)

 d=sdir(['grad_den_0_grid_aden_den_no_*.mat']);
 
 load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/total_den_grid_april_19.mat
 yd_tot=dt_tot(:,1)+(dt_tot(:,2)-1)/12.+(dt_tot(:,3)-1)/365.;
  
 s=size(press_0_tot);
 nd=s(2);
 
 bad=[];
 
 for isquare=1:s(1)
     
 lon_square=coords_tot(isquare,1);
 lat_square=coodrs_tot(isquare,2);
 
 distance=sqrt((coords-lon_square).^2+(coords-lat_square).^2);
 
 good_place=find(distance <= 1.);
 

scrsz = get(0,'ScreenSize');

h=figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5]);  


% subsect data

    temp=temp_tot(good_place,:);
    sal=sal_tot(good_place,:);
    fpress=fpress_tot(good_place,:);
    coords=coords_tot(good_place,:);
    dt=dt_tot(good_place,:);
    ratio_bad=ratio_bad_tot(good_place,:);
    
    
    press_0=press_0_tot(good_place,:);
    sal_0=sal_0_tot(good_place,:);
    temp_0=temp_0_tot(good_place,:);
    
    press_gam=press_gam_tot(good_place,:);
    sal_gam=sal_gam_tot(good_place,:);
    temp_gam=temp_gam_tot(good_place,:);

  
  %find the right dates (ie only preform the qc on the times that
  % I cheacked.
  
%   good_times=find(yd >= 2002);
%   dt=dt(good_times,:);
%   temp=temp(good_times,:);
%   sal=sal(good_times,:);
%   fpress=fpress(good_times,:);2
%   mdep=mdep(good_times);
  temp_all=temp;
  sal_all=sal;
  depth_all=fpress;
 theta = sw_ptmp(sal,temp,fpress,0);
% take out all the points that lie 3 std at every depth level
ii=[];




for iden=1:nd
        % use nuetral density when it is aviable.
   
    if length(find(finite(temp_gam(:,iden))==1)) >= 2
        den_temp=temp_gam(:,iden);
        den_sal=sal_gam(:,iden);
        den_press=press_gam(:,iden);
        else
        den_temp=temp_0(:,iden);
        den_sal=sal_0(:,iden); 
        den_press=press_0(:,iden);
    end
%only look at profiles where the mean pressure is less then 1000 dbar
    if (length(find(finite(den_temp) ==1 )) >=2 & nanmean(den_press) > 500)
         [ind_temp]=ind_out_qua(den_temp,5);
        [ind_sal]=ind_out_qua(den_sal,5);
        [ind_press]=ind_out_qua(den_press,5);
        ii=[ii,ind_sal',ind_temp',ind_press'];
        
    end 
end

% get rid of profiles with more than 5% missing


ibad=find(ratio_bad >= .05);

ii=[ii,ibad];


%get rid of profiles with desities that lie way outside the norm

den_0= sw_pden(sal,temp,fpress,0);
den_junk=den_0(:);

if  length(find(finite(den_junk) ==1 )) >=2
     [den_range]=out_qua(den_junk,5);
 end
% 
 %s=size(den_0);
% bad_den=[]; 
% 
% 
% for ipos=1:s(1)
%       
%             junk_den0=den_0(ipos,:);
%             bad_junk=find(junk_den0 <= den_range(1) | junk_den0 >= den_range(2));
%             if length(bad_junk) > 0 
%                 bad_den=[bad_den,ipos] ;
%             end
%              
%       
% end
% 




% ii=[ii, bad_den];

% this section removes profiles that are too short

s=size(sal);
short=[]; 
% 
% 
 for ipos=1:s(1)
%       
             junk=sal(ipos,:)+temp(ipos,:)+fpress(ipos,:);

             if length(find(finite(junk) == 1)) < 10 
                 short=[short,ipos] ;
             end
%              
%       
 end
ii=[ii, short];
jj=unique(ii);




temp(jj,:)=[];
sal(jj,:)=[];
theta2=theta;
theta(jj,:)=[];
fpress(jj,:)=[];
depth=fpress;







s_temp=size(temp)
if s_temp(1) > 1 & s_temp(2) >1

subplot(2,4,1)
plot(sal_all,-1.*depth_all,'.')
hold on
plot(sal_all(jj,:),-1.*depth_all(jj,:),'k.')
hold off
title('all ');
xlabel('salinity');
ylabel('depth');

%plotting all the data
      
subplot(2,4,2)
plot(temp_all,-1.*depth_all,'.')
hold on
plot(temp_all(jj,:),-1.*depth_all(jj,:),'k.')
hold off

title(['all ',d(isquare).name]);
xlabel('temp');
ylabel('depth');
%axis([30 40 -200 -100])
%plotting bad data

subplot(2,4,3)
plot(temp,-1.*depth,'.');
title('good temp ');


% 
subplot(2,4,4)
plot(sal,-1*depth,'.');
title('good sal');

subplot(2,4,8 )
% 
 plot(sal_all',theta_all','k')
 title(['Theta S ',num2str(round(100*length(jj)./length(yd))),' %. ', num2str(isquare)])
hold on 
plot (sal',theta','r')
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
end
end

% % if length (temp) >=1 
% %     fpress(jj,:)=[];id(jj,:)=[];qual(jj)=[];coords(jj,:)=[];dt(jj,:)=[];
% %     npts(jj)=[];mdep(jj)=[];time(jj,:)=[];
% %     per_bad_grad=100*length(jj)./length(good_times);
% %  eval(['save grad_den_',d(isquare).name,' coords dt time ',...
% %         'temp qual depth mdep npts id sal fpress per_bad_den per_bad_grad'])
% % end
% %  end