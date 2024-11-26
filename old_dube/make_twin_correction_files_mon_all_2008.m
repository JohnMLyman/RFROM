% this code subsamples aviso ssh and makes files to pass to the IDL mapping 

%make_aviso_file
clear
interptpx_twin_correction_mon_all_2008
clear
cd,'/Users/johnlyman/data/Globalhc/HC'

mapdiff_gen_twin_mon_all('correction/allheat_twin_correction_mon_all_2008_','correction/hdata_twin_correction_mon_all_2008_',1993,2007)




