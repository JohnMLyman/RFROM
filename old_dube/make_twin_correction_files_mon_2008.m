% this code subsamples aviso ssh and makes files to pass to the IDL mapping 


clear
interptpx_twin_correction_mon_2008
clear
cd,'/Users/johnlyman/data/Globalhc/HC'

mapdiff_gen_twin_mon('correction/allheat_twin_correction_mon_2008_','correction/hdata_twin_correction_mon_2008_',2002,2007)




