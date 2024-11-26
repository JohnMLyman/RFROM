% compute the alphas and make a file to be read by 

eval(['load ',file_path_out,'allheat_750_975_1800 ht_750 ht_975 ht_1800 topex cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%


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

hctpx_750=ht_750*NaN;
hctpx_975=ht_975*NaN;
hctpx_1800=ht_1800*NaN;


tpx=topex(:,1);
tpx(isnan(tpx))=0;
for imon=1:12
    
    good_time=find(dt(:,2)==imon & dt(:,1) >= min_year & dt(:,1)<= max_year);
    
    [alat,alon,alpha_750,c_750,xvar_750]=compute_alpha(ht_750(good_time)',topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_975,c_975,xvar_975]=compute_alpha(ht_975(good_time)',topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_1800,c_1800,xvar_1800]=compute_alpha(ht_1800(good_time)',topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    
    eval(['save ',file_path_out,'hregress_750_',num2str(imon),' alpha_750 c_750 xvar_750 alat alon']);
    eval(['save ',file_path_out,'hregress_975_',num2str(imon),' alpha_975 c_975 xvar_975 alat alon']);
    eval(['save ',file_path_out,'hregress_1800_',num2str(imon),' alpha_1800 c_1800 xvar_1800 alat alon']);
    
    hctpx_750(good_time)=tpx(good_time).*interp2(alat,alon,alpha_750,cds(good_time,2),cds(good_time,1));
    hctpx_975(good_time)=tpx(good_time).*interp2(alat,alon,alpha_975,cds(good_time,2),cds(good_time,1));
    hctpx_1800(good_time)=tpx(good_time).*interp2(alat,alon,alpha_1800,cds(good_time,2),cds(good_time,1));
    
    
end

htdiff_750=ht_750-hctpx_750;
htdiff_975=ht_975-hctpx_975;
htdiff_1800=ht_1800-hctpx_1800;
day=datenum([dt,tm,tm*0,tm*0])-datenum(1950,1,1);

yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;
% make files for gridding 

fname_nc=[file_path_hdata,'hdata_',file_name];
    
    
coords = cds;

eval(['save ',fname_nc,' htdiff_750 htdiff_975 htdiff_1800 tpx yr coords ht_750 ht_975 ht_1800'])



%NOT DONE !! NOT QCD!!!!