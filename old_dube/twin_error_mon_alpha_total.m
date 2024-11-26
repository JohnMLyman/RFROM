function [std_error,time,tsub_total,tpave_total]=twin_error_mon_one_total(file_name,depth_name)

% this code compute an error which is one standard error on the mean.

% depth_name= '750','975' or '1800'
% file_name='hdata_twin_correction_nofsi';
% this code computes and plots the ten year trend in heat content.

% tsub in the maped topex var
% tpave is the unmaped variabilty 


%alpha is in J/m^2 /(cm)

time=[2002:1/12:2008-1/12];

alpha=(.6e7)/(.04);

% loaad in the real Alpha



min_year=1993;
max_year=2007;

tgrid=[min_year:max_year]+.5;
'compute the real heat curve'
%[tpave_mon]=heat_curv_gen_twin_real_mon(tgrid);
%save '/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/junk_tpave_mon' tpave_mon
load '/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/junk_tpave_mon' tpave_mon
%load junk_tpaver

tsub_total=ones(length(time),length(tgrid))*NaN;
eval(['load per_cover_',depth_name]);

for i=1:length(time)
   
    iyear=floor(time(i))
    imon=(time(i)-iyear)*12+1
    tpave=tpave_mon(:,floor(imon));
    name_junk=[file_name,'_',num2str(iyear),'_',depth_name,'_',num2str(min_year),'_',num2str(max_year),'_',num2str(imon),'.nc'];
   [tsub,hc2,time_twin]=heat_curv_gen_twin(name_junk);
    Nl=length(tsub);
   
   
   
    tsub=tsub-mean(tsub);
    
    good=find(time_cover == time(i));
    tsub_total(i,:)=tsub;
    tsub=tsub*per_cover(good);
    tpave=tpave-mean(tpave);
   std_map=sqrt(sum(alpha.*alpha.*(tsub-tpave').^2)./Nl);
   f1=std_map;
% f2 is the standard error due to topex
   f2=(.6e7)*3.4e14;
    std_error(i)=sqrt(f2.^2+f1.^2);
    
end
tpave_total=tpave;