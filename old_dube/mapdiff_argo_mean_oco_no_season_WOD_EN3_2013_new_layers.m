% compute the alphas and make a file to be read by 

%eval(['load ',file_path_out,'allheat_100_300_700_900_1800_argo_WOD_new_',file_name,' ht_100 ht_300 ht_700 ht_900 ht_1800 ht_100_300 ht_300_700 cds dt argo_delayed_mode argo_float_id mdep wod_oclnum topex'])
eval(['load ',file_path_out,'allheat_new_layers_argo_WOD_new_',file_name,...
    ' ht_0_40 ht_40_90 ht_90_190 ht_190_290 '...
    'ht_290_450 ht_450_700 ht_700_950 ',...
    'ht_950_1450 ht_1450_1950 ht_1950_2000 ',...
    'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum topex'])%

   



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

layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];

for ilayer=2:length(layer_bounds)

     eval(['hctpx_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=',...
         'ht_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'*NaN;'])
end
 


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

% compute alpha for all times over the time period of the mean

good_time=find(dt(:,1) >=min_year & dt(:,1)<= max_year);


    [alat,alon,alpha_0_40,c_0_40,xvar_0_40]=compute_alpha(ht_0_40(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_40_90,c_40_90,xvar_40_90]=compute_alpha(ht_40_90(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_90_190,c_90_190,xvar_90_190]=compute_alpha(ht_90_190(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_190_290,c_190_290,xvar_190_290]=compute_alpha(ht_190_290(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_290_450,c_290_450,xvar_290_450]=compute_alpha(ht_290_450(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_450_700,c_450_700,xvar_450_700]=compute_alpha(ht_450_700(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_700_950,c_700_950,xvar_700_950]=compute_alpha(ht_700_950(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_950_1450,c_950_1450,xvar_950_1450]=compute_alpha(ht_950_1450(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_1450_1950,c_1450_1950,xvar_1450_1950]=compute_alpha(ht_1450_1950(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_1950_2000,c_1950_2000,xvar_1950_2000]=compute_alpha(ht_1950_2000(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    
    
    
    
    eval(['save ',file_path_out,'hregress_0_40_2 alpha_0_40 c_0_40 xvar_0_40 alat alon']);
    eval(['save ',file_path_out,'hregress_40_90_2 alpha_40_90 c_40_90 xvar_40_90 alat alon']);
    eval(['save ',file_path_out,'hregress_90_190_2 alpha_90_190 c_90_190 xvar_90_190 alat alon']);
    eval(['save ',file_path_out,'hregress_190_290_2 alpha_190_290 c_190_290 xvar_190_290 alat alon']);
    eval(['save ',file_path_out,'hregress_290_450_2 alpha_290_450 c_290_450 xvar_290_450 alat alon']);
    eval(['save ',file_path_out,'hregress_450_700_2 alpha_450_700 c_450_700 xvar_450_700 alat alon']);
    eval(['save ',file_path_out,'hregress_700_950_2 alpha_700_950 c_700_950 xvar_700_950 alat alon']);
    eval(['save ',file_path_out,'hregress_950_1450_2 alpha_950_1450 c_950_1450 xvar_950_1450 alat alon']);
    eval(['save ',file_path_out,'hregress_1450_1950_2 alpha_1450_1950 c_1450_1950 xvar_1450_1950 alat alon']);
    eval(['save ',file_path_out,'hregress_1950_2000_2 alpha_1950_2000 c_1950_2000 xvar_1950_2000 alat alon']);
    
    for ilayer=2:length(layer_bounds)

     eval(['hctpx_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=',...
         'tpx.*interp2(alat,alon,alpha_',...
         num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),...
         ',cds(:,2),cds(:,1));'])
     end
 

    for ilayer=2:length(layer_bounds)

     eval(['htdiff_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=',...
         'ht_',...
         num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),...
         '-hctpx_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
     end
 

    
    

% time is not saved so set it to 0
tm=dt(:,1).*0;
day=datenum([dt,tm,tm*0,tm*0])-datenum(1950,1,1);

yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;
% make files for gridding 

fname_nc=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name];
    
    
coords = cds;


eval(['save ',fname_nc,' tpx yr coords htdiff_0_40 htdiff_40_90 htdiff_90_190 htdiff_190_290 '...
    'htdiff_290_450 htdiff_450_700 htdiff_700_950 ',...
    'htdiff_950_1450 htdiff_1450_1950 htdiff_1950_2000 ',...
    'ht_0_40 ht_40_90 ht_90_190 ht_190_290 '...
    'ht_290_450 ht_450_700 ht_700_950 ',...
    'ht_950_1450 ht_1450_1950 ht_1950_2000 '])

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