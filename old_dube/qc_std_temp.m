% the new qc file qc3


 

 d=sdir(['grad_den_0_grid_aden_den_no_*.mat']);
 
 
 for isquare=1:length(d)
   close(figure,h) 
scrsz = get(0,'ScreenSize');
 h=figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5]);  
eval(['load ',d(isquare).name])

display(d(isquare).name)

% sorting the data
nd=length(depth);
temp2=temp;2

yd=dt(:,1)+(dt(:,2)-1)/12.+(dt(:,3)-1)/365.;
  
  %find the right dates (ie only preform the qc on the times that
  % I cheacked.
  
  good_times=find(yd >= 2002);
  dt=dt(good_times,:);
  temp=temp(good_times,:);
  sal=sal(good_times,:);
  fpress=fpress(good_times,:);22,5,52,5
  mdep=mdep(good_times);
  temp2=temp;
  sal2=sal;
 theta = sw_ptmp(sal,temp,fpress,0);
% take out all the points that lie 3 std at every depth level
ii=[];-1*depth(1:nd)
for ideep=1:nd
   deep_temp=temp(:,ideep);
   deep_sal=sal(:,ideep); 
   
if depth(ideep) >= 400
   [ind_temp]=ind_out_std2(deep_temp,4);
   [ind_sal]=ind_out_std2(deep_sal,4);
   else
   [ind_temp]=ind_out_std2(deep_temp,4);
   [ind_sal]=ind_out_std2(deep_sal,4);
end
   
   ii=[ii,ind_sal,ind_temp];
end
jj=unique(ii);


% % get rid of temp at depth
% 
% deep=temp(:,nd);
% 
% [ind_deep]=ind_out_std2(deep,2);
% 
% % if there are enough points do it agian
% 
% 
% 
% jj=[ind_deep];
% 
% % do the same thing for salinity
% 
% deep_sal=sal(:,nd);
% good=[1:length(deep_sal)];
%     
% %get rid of bad pofiles
% deep_sal(jj)=[];
% good(jj)=[];
% 
% [ind_deep2]=ind_out_std2(deep_sal,2);
% 
% jj=[jj,good(ind_deep2)];



% del_del <-0.001 is about the same as N^2 < -5e6 1/sec^2
% [ibad,jbad]=find(del_den < -0.001 );
% jj=unique(ibad);
%find where there are density inversions


%  
 %jj=[jj;find(temp(:,4)<1)];
% jj=[jj;find(temp(:,2)<100)];
% jj=[jj;find(temp(:,8)<2.5)];
% jj=[jj;find(temp(:,3)<13)];
% jj=[jj;find(temp(:,11)<6)];
%jj=[jj;find(temp(:,2)<8)];
%jj=[jj;find(temp(:,6)<12)];
%jj=[jj;find(temp(:,9)<12)];
%jj=[jj;find(temp(:,1)<.6)];
 %jj=[jj;find(temp(:,3)>28.74)];
% 
% jj=[jj;find(temp(:,9)>31)];
%jj=[jj;find(temp(:,1)<13 & temp(:,1)>12.2)];

temp(jj,:)=[];
sal(jj,:)=[];
theta2=theta;
theta(jj,:)=[];
fpress(jj,:)=[];
% [tu,rp,p_ave] = sw_turn(sal',temp',fpress');
% tu=tu';
% rp=rp';
% p_ave=p_ave';
%pden_top(jj,:)=[];






% % % 
if length(temp) > 0 
%del_den(jj,:)=[];
%plotting the good data

subplot(2,4,1)
plot(sal2,-1.*depth,'.')
title('all ');
xlabel('salinity');
ylabel('depth');

%plotting all the data

subplot(2,4,2)
plot(temp2,-1.*depth,'.')
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

%
% subplot(2,5,5)
% plot(tu,-1.*p_ave,'.');
% title(['turner angle']);
subplot(2,4,8 )
% 
 plot(sal2',theta2','k')
 title(['Theta S ',num2str(round(100*length(jj)./length(good_times))),' %. ', num2str(isquare)])
hold on 
plot (sal',theta','r')
hold off

% 
% 
% plot(temp2(jj,:),-1.*depth,'.')
% title('bad');
% xlabel('temp');
% ylabel('depth');
% 
% 
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

%plotting month


subplot(2,4,6)

plot(dt(:,2),'.b')

hold on

plot(dt(jj,2),'.r')
xlabel('index');
ylabel('month');
hold off

%plotting year

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