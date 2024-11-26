% this code subsamples aviso ssh and makes files to pass to the IDL mapping 


clear
interptpx_twin_correction_2008
clear
cd,'/Users/johnlyman/data/Globalhc/HC'

mapdiff_gen_twin('correction/allheat_twin_correction_2008_','correction/hdata_twin_correction_2008_',1993,2007)




