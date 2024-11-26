% the  new qc file qc3 
     
close all
h=figure;
 fig_a=figure
% fig_b=figure

 d=sdir(['den_den_no*.mat']);
 
 
 
 dd=[ 17 35 41 49 51 56 57 68 70 71 74 75 120 76 85 93 99 101 113 115 116 ...
     120 121 147 148 149 150 157 163 180 182 183 186 187 189 192 196 203 ...
     206 208 209 214 215 217 219 240 243 244 245 264 265 267 274 275 ...
     276 285 290 296 302 313 322 333 335 336 348 349 350 351 352 357 ...
     358 368 369 374 375 376 380 388 390 393]
 
  % dd=[1:length(d)];
 for iplace=1:length(dd)
%for isquare=302:length(d)
isquare=dd(iplace) 

close(figure,h) 
scrsz = get(0,'ScreenSize');
 h=figure('Position',[1 scrsz(4)/1.2 scrsz(3)/1.2 scrsz(4)/1.2]);  
eval(['load ',d(isquare).name])
%eval(['load den_2000_f',num2str(isquare),'.mat'])

display(d(isquare).name) 

% sorting the data
nd=length(depth);
temp2=temp;

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
 
 % this section looks at the number of bad points in the profile
 
 num_samp=size(temp,2);
 num_profiles=size(temp,1);
 num_good=[1:num_profiles]*NaN;
 num_nans=num_good;
 
 for k=1:num_profiles 
        ii=find(~isnan(temp(k,:)+fpress(k,:)+sal(k,:)));
        length_good=length(ii);
        
        num_good(k)=length_good;
        num_nans(k)=ii(end)-length_good;
        fpress(k,:)=[fpress(k,ii),[1:num_samp-length_good]*NaN];
        temp(k,:)=[temp(k,ii),[1:num_samp-length_good]*NaN];
        sal(k,:)=[sal(k,ii),[1:num_samp-length_good]*NaN];
 end
 
 ratio_bad=  num_nans./num_good
 
   too_many_missing=find(ratio_bad >= .0005);
   
% take out all the points that lie 3 std at every depth level
ii=[];
% for ideep=1:nd
%    deep_temp=temp(:,ideep);
%    deep_sal=sal(:,ideep); 
%    
% if depth(ideep) >= 400
%    [ind_temp]=ind_out_std2(deep_temp,4);
%    [ind_sal]=ind_out_std2(deep_sal,4);
%    else
%    [ind_temp]=ind_out_std2(deep_temp,4);
%    [ind_sal]=ind_out_std2(deep_sal,4);
% end
%    
%    ii=[ii,ind_sal,ind_temp];
% end
%jj=unique(ii);
jj=[];

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

press_ref=(fpress(:,1:nd-1)+fpress(:,2:nd))./2;
% 
 pden_top = sw_pden(sal(:,1:nd-1),temp(:,1:nd-1),fpress(:,1:nd-1),press_ref);
 pden_bot = sw_pden(sal(:,2:nd),temp(:,2:nd),fpress(:,2:nd),press_ref);
%
pden_top_surface = sw_pden(sal,temp,fpress,0);
pden_top_surface_del = sw_pden(sal(:,1:nd-1),temp(:,1:nd-1),fpress(:,1:nd-1),0);

del_den_press=(pden_bot-pden_top);
 del_den=(pden_bot-pden_top)./press_ref;

% del_del <-0.001 is about the same as N^2 < -5e6 1/sec^2
[ibad,jbad]=find(del_den < (-.001/5.));
 jj=unique([ibad',too_many_missing]');
%find where there are density inversions 
%find mixed layer

% % imixed=1;
% % surface_press=fpress(:,1);      
% % surface_temp=temp(:,1);
% % surface_sal=sal(:,1);
% % surface_ind=ones(length(surface_pressal',theta's),1);
% % 
% % 
% % test_nan=surface_press+surface_temp+surface_sal;
% %     while (length(find(finite(test_nan)==0)) >=1) & (imixed < (nd-1))
% %        imixed=imixed+1;
% %         bad_press=find(finite(test_nan)==0);
% %        surface_press(bad_press)=fpress(bad_press,imixed);
% %        surface_sal(bad_press)=sal(bad_press,imixed);
% %        surface_temp(bad_press)=temp(bad_press,imixed);
% %        surface_ind(bad_press)=imixed;
% %        test_nan=surface_press+surface_temp+surface_sal;
% %     end
% % 
% %     
% %  del_mixed=ones(length(good_times),nd)*NaN;   
% % for idepth=1:nd
% %     
% %     
% %     ref_mixed=(surface_press+fpress(:,idepth))./2;
% %     mixed_top=sw_pden(surface_sal,surface_temp,surface_press,ref_mixed);
% %     mixed_bot=sw_pden(sal(:,idept> temp(k,:)=[temp(k,ii),[1:num_samp-length_good]*NaN];h),temp(:,idepth),fpress(:,idepth),ref_mixed);
% %     del_mixed(:,idepth)=mixed_top-mixed_bot;
%%end



%  
 %jj=[jj;find(temp(:,4)<1)];
% jj=[jj;find(temp(:,2)<100)];
% jj=[jj;find(temp(:,8)<2.5)];
% jj=[jj;find(temp(:,3)<13)];
% jj=[jj;find(tclose(fig_a)emp(:,11)<6)];
%jj=[jj;find(temp(:,2)<8)];
%jj=[jj;find(temp(:,6)<12)];
%jj=[jj;find(temp(:,9)<12)];
%jj=[jj;find(temp(:,1)<.6)];
 %jj=[jj;find(temp(:,3)>28.74)];
% 4
% jj=[jj;find(temp(:,9)>31)];
%jj=[jj;find(temp(:,1)<13 & temp(:,1)>12.2)];
dt2=dt;
dt2(jj,:)=[];
temp(jj,:)=[];
sal(jj,:)=[];
theta2=theta;xlim([0,.01]);
depth2=fpress;
theta(jj,:)=[];
fpress(jj,:)=[];

pos_2002=find(dt2(:,1) == 2002);
pos_2003=find(dt2(:,1) == 2003);
pos_2004=find(dt2(:,1) == 2004);
pos_2005=find(dt2(:,1) == 2005);
depth=fpress;
%surface_press(jj)=[];
% [tu,rp,p_ave] = sw_turn(sal',temp',fpress');
% tu=tu';
% rp=rp';
% p_ave=p_ave';
pden_top_surface(jj,:)=[];
pden_top_surface_del(jj,:)=[];
del_den_press(jj,:)=[];

del_den(jj,:)=[];
ratio_bad2=ratio_bad;
ratio_bad(jj)=[];
% % press_ref(jj,:)=[];
% % del_mixed(jj,:)=[];
% % 
% % del_mixed3=del_mixed;
% % press_mixed=fpress;
% % shallow=find(-1.*del_mixed3 < .02);
% % press_mixed(shallow)=2000;
% % press_mixed(find(finite(presxlim([0,.01]);s_mixed) == 0))=2000;
% % mixed_depth=min(press_mixed,[],2);

% take out mixed layers that are in the thermo or pycnocline

% del_surface_mixed=abs(surface_press-mixed_depth);
% bad_mixed=find(del_surface <= 4);







% % % 
if length(temp) > 0 
%del_den(jj,:)=[];
%plotting the good data

subplot(2,5,1)
plot(sal2',-1.*depth2','.')
title('all ');
xlabel('salinity');
ylabel('depth');

%plotting all the data

subplot(2,5,2)
plot(temp2',-1.*depth2','.')
title(['all ',d(isquare).name]);
xlabel('temp');
ylabel('depth');
%axis([30 40 -200 -100])
%plotting bad data

subplot(2,5,3)
plot(temp',-1.*depth','.');
title('good temp ');


% 
subplot(2,5,4)
plot(sal',-1*depth','.');
title('good sal');

%
% subplot(2,5,5)
% plot(tu,-1.*p_ave,'.');
% title(['turner angle']);
subplot(2,5,5 )
% 
 %plot(sal2',theta2','k')
 hold on
num_nans./num_good
% plot (sal(pos_2002,:)',theta(pos_2002,:)','.r')
% plot (sal(pos_2003,:)',theta(pos_2003,:)','.b')
% plot (sal(pos_2004,:)',theta(pos_2004,:)','.g')
% plot (sal(pos_2005,:)',theta(pos_2005,:)','.k')

plot (sal',theta')
title(['Theta S ',num2str(round(100*length(jj)./length(good_times))),' %. ', num2str(isquare)])
hold on 
hold off

% 
% 
% plot(temp2(jj,:),-1.*depth,'.')xlim([0,.01]);
% title('bad');
% xlabel('temp');
% ylabel('depth');
% 
% 
%plotting the map

% % imixed=1;
% % surface_press=fpress(:,1);      
% % surface_temp=temp(:,1);
% % surface_sal=sal(:,1);r
% % surface_ind=ones(length(surface_pressal',theta's),1);xlim([0,.01]);
% % 
% % 
% % test_nan=surface_press+surface_temp+surface_sal;
% %     while (length(find(finite(test_nan)==0)) >=1) & (imixed < (nd-1))
% %        imixed=imixed+1;
% %         bad_press=find(finite(test_nan)==0);
% %        surface_press(bad_press)=fpress(bad_press,imixed);
% %        surface_sal(bad_press)=sal(bad_press,imixed);
% %        surface_temp(bad_press)=temp(bad_press,imixed);
% %        surface_ind(bad_press)=imixed;
% %        test_nan=surface_press+surface_temp+surface_sal;
% %     end
% % 
% %     r
% %  del_mixed=ones(length(good_times),nd)*NaN;   
% % for idepth=1:nd
% %     
% %     
% %     ref_mixed=(surface_press+fpress(:,idepth))./2;
% %     mixed_top=sw_pden(surface_sal,surface_temp,surface_press,ref_mixed);
% %     mixed_bot=sw_pden(sal(:,idepth),temp(:,idepth),fpress(:,idepth),ref_mixed);
% %     del_mixed(:,idept
subplot(2,5,6)
m_ungrid m_proj;
m_proj('Miller Cylindrical');
 m_coast;
 m_grid;
 hold on
m_plot(coords(:,1),coords(:,2),'.k')

%m_plot(coords(jj,1),coords(jj,2),'.r')
hold off
subplot(2,5,7)
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


subplot(2,5,8)

plot(dt(:,2),'.b')


hold on

plot(dt(jj,2),'.r')
xlabel('index'); 
ylabel('month');
hold off

%plotting year

subplot(2,5,9)

plot(dt(:,1),'.b')

hold on

plot(dt(jj,1),'.r')
xlabel('index');
ylabel('year');
hold off


%plot change in desity
subplot(2,5,10)

deep_pro=find(depth >=700);
year=dt2(:,1);

sal_2002=sal(pos_2002,:);
pden_top_surface_2002=pden_top_surface(pos_2002,:);

sal_2003=sal(pos_2003,:);
pden_top_surface_2003=pden_top_surface(pos_2003,:);

sal_2004=sal(pos_2004,:);
pden_top_surface_2004=pden_top_surface(pos_2004,:);

sal_2005=sal(pos_2005,:);
pden_top_surface_2005=pden_top_surface(pos_2005,:);


deep_2002=find(depth(pos_20qc_std_temp_density_neutral.m02,:) >=700);
deep_2003=find(depth(pos_2003,:) >=700);
deep_2004=find(depth(pos_2004,:) >=700);
deep_2005=find(depth(pos_2005,:) >=700);

%plot(sal2(:,deep_pro)',theta2(:,deep_pro)','k')
hold on 

plot (sal_2002(deep_2002)',pden_top_surface_2002(deep_2002)','.r')
plot (sal_2003(deep_2003)',pden_top_surface_2003(deep_2003)','.b')
plot (sal_2004(deep_2004)',pden_top_surface_2004(deep_2004)','.g')
plot (sal_2005(deep_2005)',pden_top_surface_2005(deep_2005)','.k')

title(['Theta S '])
hold off


subplot(2,5,9)
% sal3=sal2(deep_pro);
% 
% ms=nanmean(sal3);
% sal4=[];
% for i=1:length(ms)
% sal4=[sal4,sal3(:,i)-ms(i)];
% end
%hist(sal4(find(finite(sal4) == 1)),[-.2:.01:.2]);
hold on
plot (sal_2002',pden_top_surface_2002','.r')
plot (sal_2003',pden_top_surface_2003','.b')
plot (sal_2004',pden_top_surface_2004','.g')
plot (sal_2005',pden_top_surface_2005','.k')
hold off
%plot(del_den2,pden_top_surface2,'.')
close(fig_a);
fig_a=figure
subplot(1,3,1)
plot(del_den_press,pden_top_surface_del,'.')   

subplot(1,3,2)
plot(fpress,pden_top_surface,'.')

subplot(1,3,3)

plot(ratio_bad2,'.');
hold on 
plot(ratio_bad,'.r');
hold off
% % %plot(del_den2,pden_top_surface2,'.')
% % 
% % % mixed layer del_den=.02
% % xlim([0,.1]);_ref
% % 
% % 
% % 
% % close(fig_b);
% % fig_b=figure;
% % subplot(2,1,1);
% % plot(dt2(:,2),mixed_depth,'.')     
% % subplot(2,1,2);pden_top_surface(jj,:)=[];

% % plot(surface_press)f=[fpress(ii,:),[1:num_samp-length_good]*NaN];
% % hold on 
% % plot(mixed_depth,'.')
% % hold off
pause
end
end

% % if length (temp) >=1  
% %     fpress(jj,:)=[];id(jj,:)=[];qual(jj)=hold off
[];coords(jj,:)=[];dt(jj,:)=[];
% %     npts(jj)=[];mdep(jj)=[];time(jj,:)=[];
% %     per_bad_grad=100*length(jj)./length(good_times);
% %  eval(['save grad_den_',d(isquare).name,' coords dt time ',...
% %         'temp qual depth mdep npts id sal fpress per_bad_den per_bad_grad'])
% % end
% %  end