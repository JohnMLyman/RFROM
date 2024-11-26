function [std_error]=twin_error(file_name,time)

% this code compute an error which is one standard error on the mean.


%file_name='hdata_twin_correction_nofsi';
% this code computes and plots the ten year trend in heat content.

% tsub in the maped topex var
% tpave is the unmaped variabilty 


%alpha is in J/m^2 /(cm)
alpha=(.6e7)/(.04);


min_year=1993;
max_year=2006;

tgrid=[min_year:max_year]+.5;
'compute the real heat curve'
[hctpx,tpave]=heat_curv_gen_twin_real(tgrid);
save 'junk_tpave2' hctpx tpave
%load junk_tpave
for i=1:length(time)
   
    iyear=time(i);    
    [file_name,'_',num2str(iyear),'_',num2str(min_year),'_',num2str(max_year),'.nc']
   [tsub,hc2,time_twin]=heat_curv_gen_twin([file_name,'_',num2str(iyear),'_',num2str(min_year),'_',...
	num2str(max_year),'.nc']);
    Nl=length(tsub);
   
   
   
    tsub=tsub-mean(tsub);
    tpave=tpave-mean(tpave);
   std_map=sqrt(sum(alpha.*alpha.*(tsub-tpave).^2)./Nl);
   f1=std_map;
% f2 is the standard error due to topex
   f2=(.6e7)*3.4e14;
    std_error(i)=sqrt(f2.^2+f1.^2);
end    

