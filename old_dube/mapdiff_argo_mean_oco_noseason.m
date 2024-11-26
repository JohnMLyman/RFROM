% compute the alphas and make a file to be read by 

eval(['load ',file_path_out,'allheat_100_300_700_900_1800 ht_100 ht_300 ht_700 ht_900 ht_1800 topex cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%
eval(

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
hctpx_700=ht_700*NaN;
hctpx_900=ht_900*NaN;
hctpx_1800=ht_1800*NaN;
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
%     [alat,alon,alpha_1800,c_1800,xvar_1800]=compute_alpha(ht_1800(good_time),topex(good_time,2),dt(good_time,:),cds(good_time,:),wnum(good_time)');
%      
%     eval(['save ',file_path_out,'hregress_100_',num2str(imon),' alpha_100 c_300 xvar_300 alat alon']); 
%     eval(['save ',file_path_out,'hregress_300_',num2str(imon),' alpha_300 c_300 xvar_300 alat alon']);
%     eval(['save ',file_path_out,'hregress_700_',num2str(imon),' alpha_700 c_700 xvar_700 alat alon']);
%     eval(['save ',file_path_out,'hregress_900_',num2str(imon),' alpha_900 c_900 xvar_900 alat alon']);
%     eval(['save ',file_path_out,'hregress_1800_',num2str(imon),' alpha_1800 c_1800 xvar_1800 alat alon']);
%         
%     
%     
% end

% compute alpha for whole data set



    [alat,alon,alpha_100,c_100,xvar_100]=compute_alpha(ht_100,tpx,dt,cds,wnum');
    [alat,alon,alpha_300,c_300,xvar_300]=compute_alpha(ht_300,tpx(:,1),dt,cds,wnum');
    [alat,alon,alpha_700,c_700,xvar_700]=compute_alpha(ht_700,tpx(:,1),dt,cds,wnum');
    [alat,alon,alpha_900,c_900,xvar_900]=compute_alpha(ht_900,tpx(:,1),dt,cds,wnum');
    [alat,alon,alpha_1800,c_1800,xvar_1800]=compute_alpha(ht_1800,tpx(:,1),dt,cds,wnum');
     
    eval(['save ',file_path_out,'hregress_100 alpha_100 c_100 xvar_100 alat alon']);
    eval(['save ',file_path_out,'hregress_300 alpha_300 c_300 xvar_300 alat alon']);
    eval(['save ',file_path_out,'hregress_700 alpha_700 c_700 xvar_700 alat alon']);
    eval(['save ',file_path_out,'hregress_900 alpha_900 c_900 xvar_900 alat alon']);
    eval(['save ',file_path_out,'hregress_1800 alpha_1800 c_1800 xvar_1800 alat alon']);
    
    hctpx_100=tpx.*interp2(alat,alon,alpha_100,cds(:,2),cds(:,1));
    hctpx_300=tpx.*interp2(alat,alon,alpha_300,cds(:,2),cds(:,1));
    hctpx_700=tpx.*interp2(alat,alon,alpha_700,cds(:,2),cds(:,1));
    hctpx_900=tpx.*interp2(alat,alon,alpha_900,cds(:,2),cds(:,1));
    hctpx_1800=tpx.*interp2(alat,alon,alpha_1800,cds(:,2),cds(:,1));
    
    
htdiff_100=ht_100-hctpx_100;
htdiff_300=ht_300-hctpx_300;
htdiff_700=ht_700-hctpx_700;
htdiff_900=ht_900-hctpx_900;
htdiff_1800=ht_1800-hctpx_1800;
day=datenum([dt,tm,tm*0,tm*0])-datenum(1950,1,1);

yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;
% make files for gridding 

fname_nc=[file_path_hdata,'hdata_100_',file_name];
    
    
coords = cds;

eval(['save ',fname_nc,' htdiff_100 htdiff_300 htdiff_700 htdiff_900 htdiff_1800 tpx yr coords ht_100 ht_300 ht_700 ht_900 ht_1800'])



%NOT DONE !! NOT QCD!!!!

% %% ploting of Aphla 
% 
% s=size(alpha_1800);
% alpha_1800_mon=ones(s(1),s(2),12)*NaN;
% 
% alpha_300_mon=ones(s(1),s(2),12)*NaN;
% alpha_900_mon=ones(s(1),s(2),12)*NaN;
% alpha_700_mon=ones(s(1),s(2),12)*NaN;
% 
% 
% for imon=1:12
%     
% 
%   eval(['load ',file_path_out,'hregress_1800_',num2str(imon)]);
% alpha_1800_mon(:,:,imon)=alpha_1800; 
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