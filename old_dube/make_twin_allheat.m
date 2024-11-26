% this code subsamples aviso ssh and makes files to pass to the IDL mapping 



%interptpx_twin_correction_all
clear
%interptpx_twin_allheat
%clear
%interptpx_twin_allheat_no_te
clear

mapdiff_gen_twin('trend/allheat_twin_allheat_no_te_','trend/hdata_twin_allheat_no_te_',1995,2006)
clear
mapdiff_gen_twin('trend/allheat_twin_allheat_','trend/hdata_twin_allheat_',1955,2006)
clear


