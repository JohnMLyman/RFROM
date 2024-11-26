% compute the alphas and make a file to be read by 

eval(['load ',file_path_out,'allheat_100_300_700_900_1950_argo_WOD_new_',file_name,' ht_100 ht_300 ht_700 ht_900 ht_1950 ht_100_300 ht_300_700 cds dt argo_delayed_mode argo_float_id mdep wod_oclnum topex'])


% comput wnum which are 10x10 degree boxes over which the alphas are
% computed.
 
% calculate appropriate square for given lat and lon
iii=find(cds(:,1)<=0&cds(:,2)>0);
jjj=find(cds(:,1)>0 &cds(:,2)>0);
lll=find(cds(:,1)<=0&cds(:,2)<=0);
nnn=find(cds(:,1)>0 &cds(:,2)<=0);
wnum(iii)=abs(ceil(cds(iii,1)/10))+100*(ceil(cds(iii,2)/10)-1)+7000;
wnum(jjj)=ceil(cds(jjj,1)/10)-1+100*(ceil(cds(jjj,2)/10)-1)+1000;
wnum(lll)=abs(ceil(cds(lll,1)/10))+100*abs(ceil(cds(lll,2)/10))+5000;
wnum(nnn)=ceil(cds(nnn,1)/10)-1+100*abs(ceil(cds(nnn,2)/10))+3000;



% compute the alphas for each month

hctpx_300=ht_300*NaN;

hctpx_100_300=ht_100_300*NaN;
hctpx_300_700=ht_300_700*NaN;

hctpx_700=ht_700*NaN;
hctpx_900=ht_900*NaN;
hctpx_1950=ht_1950*NaN;
hctpx_100=ht_100*NaN;

tpx=topex(:,1);
tpx(isnan(tpx))=0;
% for imon=1:12
%     
%     good_time=find(dt(:,2)==imon & dt(:,1) >= min_year & dt(:,1)<= max_year);
%     
%     [alat,alon,alpha_100,c_100,xvar_100]=compute_alpha(ht_100(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
%     [alat,alon,alpha_300,c_300,xvar_300]=compute_alpha(ht_300(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
%     [alat,alon,alpha_700,c_700,xvar_700]=compute_alpha(ht_700(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
%     [alat,alon,alpha_900,c_900,xvar_900]=compute_alpha(ht_900(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
%     [alat,alon,alpha_1950,c_1950,xvar_1950]=compute_alpha(ht_1950(good_time),topex(good_time,2),dt(good_time,:),cds(good_time,:),wnum(good_time)');
%      
%     eval(['save ',file_path_out,'hregress_100_',num2str(imon),' alpha_100 c_300 xvar_300 alat alon']); 
%     eval(['save ',file_path_out,'hregress_300_',num2str(imon),' alpha_300 c_300 xvar_300 alat alon']);
%     eval(['save ',file_path_out,'hregress_700_',num2str(imon),' alpha_700 c_700 xvar_700 alat alon']);
%     eval(['save ',file_path_out,'hregress_900_',num2str(imon),' alpha_900 c_900 xvar_900 alat alon']);
%     eval(['save ',file_path_out,'hregress_1950_',num2str(imon),' alpha_1950 c_1950 xvar_1950 alat alon']);
%         
%     
%     
% end

% compute alpha for all times over the time period of the mean

good_time=find(dt(:,1) >=min_year & dt(:,1)<= max_year);


    [alat,alon,alpha_100,c_100,xvar_100]=compute_alpha(ht_100(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_100_300,c_100_300,xvar_100_300]=compute_alpha(ht_100_300(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_300_700,c_300_700,xvar_300_700]=compute_alpha(ht_300_700(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_300,c_300,xvar_300]=compute_alpha(ht_300(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    
    [alat,alon,alpha_700,c_700,xvar_700]=compute_alpha(ht_700(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_900,c_900,xvar_900]=compute_alpha(ht_900(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_1950,c_1950,xvar_1950]=compute_alpha(ht_1950(good_time),topex(good_time,2),dt(good_time,:),cds(good_time,:),wnum(good_time)');
     
    eval(['save ',file_path_out,'hregress_100_2 alpha_100 c_100 xvar_100 alat alon']);
    eval(['save ',file_path_out,'hregress_300_2 alpha_300 c_300 xvar_300 alat alon']);
    
    eval(['save ',file_path_out,'hregress_100_300_2 alpha_100_300 c_100_300 xvar_100_300 alat alon']);
    eval(['save ',file_path_out,'hregress_300_700_2 alpha_300_700 c_300_700 xvar_300_700 alat alon']);
    
    eval(['save ',file_path_out,'hregress_700_2 alpha_700 c_700 xvar_700 alat alon']);
    eval(['save ',file_path_out,'hregress_900_2 alpha_900 c_900 xvar_900 alat alon']);
    eval(['save ',file_path_out,'hregress_1950_2 alpha_1950 c_1950 xvar_1950 alat alon']);
    
    hctpx_100=tpx.*interp2(alat,alon,alpha_100,cds(:,2),cds(:,1));
    hctpx_300_700=tpx.*interp2(alat,alon,alpha_300_700,cds(:,2),cds(:,1));
    hctpx_100_300=tpx.*interp2(alat,alon,alpha_100_300,cds(:,2),cds(:,1));
    hctpx_300=tpx.*interp2(alat,alon,alpha_300,cds(:,2),cds(:,1));
    hctpx_700=tpx.*interp2(alat,alon,alpha_700,cds(:,2),cds(:,1));
    hctpx_900=tpx.*interp2(alat,alon,alpha_900,cds(:,2),cds(:,1));
    hctpx_1950=tpx.*interp2(alat,alon,alpha_1950,cds(:,2),cds(:,1));
    
    
htdiff_100=ht_100-hctpx_100;
htdiff_100_300=ht_100_300-hctpx_100_300;
htdiff_300_700=ht_300_700-hctpx_300_700;
htdiff_300=ht_300-hctpx_300;
htdiff_700=ht_700-hctpx_700;
htdiff_900=ht_900-hctpx_900;
htdiff_1950=ht_1950-hctpx_1950;
% time is not saved so set it to 0
tm=dt(:,1).*0;
day=datenum([dt,tm,tm*0,tm*0])-datenum(1950,1,1);

yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;
% make files for gridding 

fname_nc=[file_path_hdata,'hdata_1950_',file_WOD_suf,'_',file_name];
    
    
coords = cds;

eval(['save ',fname_nc,' htdiff_100 htdiff_300 htdiff_100_300 htdiff_300_700 htdiff_700 htdiff_900 htdiff_1950 tpx yr coords ht_100 ht_300 ht_100_300 ht_300_700 ht_700 ht_900 ht_1950'])



%NOT DONE !! NOT QCD!!!!

% %% ploting of Aphla 
% 
% s=size(alpha_1950);
% alpha_1950_mon=ones(s(1),s(2),12)*NaN;
% 
% alpha_300_mon=ones(s(1),s(2),12)*NaN;
% alpha_900_mon=ones(s(1),s(2),12)*NaN;
% alpha_700_mon=ones(s(1),s(2),12)*NaN;
% 
% 
% for imon=1:12
%     
% 
%   eval(['load ',file_path_out,'hregress_1950_',num2str(imon)]);
% alpha_1950_mon(:,:,imon)=alpha_1950; 
% 
% eval(['load ',file_path_out,'hregress_900_',num2str(imon)]);
% alpha_900_mon(:,:,imon)=alpha_900; 
% 
% eval(['load ',file_path_out,'hregress_700_',num2str(imon)]);
% alpha_700_mon(:,:,imon)=alpha_700; 
% 
% eval(['load ',file_path_out,'hregress_300_',num2str(imon)]);
% alpha_300_mon(:,:,imon)=alpha_300; 
% 
% end
% %%
% figure(1)
% pcolor(alon,alat,mean(alpha_300_mon,3)')
% title('300 mean')
% shading flat
% plot_coasts_black
% colorbar
% caxis([0 15e7])
% 
% figure(3)
% pcolor(alon,alat,alpha_300_year')
% title('300 year')
% shading flat
% plot_coasts_black
% colorbar
% caxis([0 15e7])
% 
% 
% figure(2)
% pcolor(alon,alat,std(alpha_300_mon,1,3)')
% title('300 std')
% shading flat
% plot_coasts_black
% colorbar
% caxis([0 15e7])