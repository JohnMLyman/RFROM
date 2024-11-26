% this code subsamples aviso ssh and makes files to pass to the IDL mapping 


clear
interptpx_twin_correction_all
clear
interptpx_twin_correction_noargo
clear
interptpx_twin_correction_nowhoi
clear
interptpx_twin_correction_argo


mapdiff_gen_twin('correction/allheat_twin_correction_all2_','correction/hdata_twin_correction_all2_',2004,2006)
mapdiff_gen_twin('correction/allheat_twin_correction_noargo2_','correction/hdata_twin_correction_noargo2_',2004,2006)
mapdiff_gen_twin('correction/allheat_twin_correction_nowhoi2_','correction/hdata_twin_correction_nowhoi2_',2004,2006)
mapdiff_gen_twin('correction/allheat_twin_correction_argo2_','correction/hdata_twin_correction_argo2_',2004,2006)




