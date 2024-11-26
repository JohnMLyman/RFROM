% compute the alphas and make a file to be read by 

eval(['load ',file_path_out,'allheat_300_700_900_1800 ht_300 ht_700 ht_900 ht_1800 topex cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%
%% get rid of AMOL dac center

pos_us_2010=find(dac_centre(:,1)=='A'& dt(:,1)==2010 & dt(:,2) == 7);


% find id of us floats
id_us_2010=unique(id(pos_us_2010));

% Randomly select of 30% of us floats
b=randperm(length(id_us_2010));
id_gone=id_us_2010(b(1:floor(length(b)*.3)));

%find the position of all the casts 
pos_gone=ismember(id,id_gone);


cds(pos_gone,:)=[];
cycle(pos_gone)=[];
dac_centre(pos_gone)=[];
topex(pos_gone,:)=[];
ht_700(pos_gone)=[];
ht_300(pos_gone)=[];
ht_900(pos_gone)=[];
ht_1800(pos_gone)=[];
dt(pos_gone,:)=[];
fpkeep=fpkeep-length(pos_gone);
fptot 
id(pos_gone)=[];
mdep(pos_gone)=[];
npts(pos_gone)=[];
press_mis_flag(pos_gone)=[];
qual(pos_gone)=[];
tm(pos_gone,:)=[];
wmo_inst(pos_gone)=[];


%% comput wnum which are 10x10 degree boxes over which the alphas are
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


tpx=topex(:,1);
tpx(isnan(tpx))=0;
for imon=1:12
    
    good_time=find(dt(:,2)==imon & dt(:,1) >= min_year & dt(:,1)<= max_year);
    
    
    [alat,alon,alpha_300,c_300,xvar_300]=compute_alpha(ht_300(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_700,c_700,xvar_700]=compute_alpha(ht_700(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_900,c_900,xvar_900]=compute_alpha(ht_900(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
    [alat,alon,alpha_1800,c_1800,xvar_1800]=compute_alpha(ht_1800(good_time),topex(good_time,1),dt(good_time,:),cds(good_time,:),wnum(good_time)');
     
    eval(['save ',file_path_out,'hregress_300_',num2str(imon),' alpha_300 c_300 xvar_300 alat alon']);
    eval(['save ',file_path_out,'hregress_700_',num2str(imon),' alpha_700 c_700 xvar_700 alat alon']);
    eval(['save ',file_path_out,'hregress_900_',num2str(imon),' alpha_900 c_900 xvar_900 alat alon']);
    eval(['save ',file_path_out,'hregress_1800_',num2str(imon),' alpha_1800 c_1800 xvar_1800 alat alon']);
        
    hctpx_300(good_time)=tpx(good_time).*interp2(alat,alon,alpha_300,cds(good_time,2),cds(good_time,1));
    hctpx_700(good_time)=tpx(good_time).*interp2(alat,alon,alpha_700,cds(good_time,2),cds(good_time,1));
    hctpx_900(good_time)=tpx(good_time).*interp2(alat,alon,alpha_900,cds(good_time,2),cds(good_time,1));
    hctpx_1800(good_time)=tpx(good_time).*interp2(alat,alon,alpha_1800,cds(good_time,2),cds(good_time,1));
    
    
end

htdiff_300=ht_300-hctpx_300;
htdiff_700=ht_700-hctpx_700;
htdiff_900=ht_900-hctpx_900;
htdiff_1800=ht_1800-hctpx_1800;
day=datenum([dt,tm,tm*0,tm*0])-datenum(1950,1,1);

yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;
% make files for gridding 

fname_nc=[file_path_hdata,'hdata_',file_name];
    
    
coords = cds;

eval(['save ',fname_nc,'_30_per_less_us_3.mat htdiff_300 htdiff_700 htdiff_900 htdiff_1800 tpx yr coords ht_300 ht_700 ht_900 ht_1800'])



%NOT DONE !! NOT QCD!!!!