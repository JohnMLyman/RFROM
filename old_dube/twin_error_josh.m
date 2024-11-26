%this code will compute the error for all three cases





time=[2004:2006];

[error_all]=twin_error('hdata_twin_correction_all2',time);
[error_argo]=twin_error('hdata_twin_correction_argo2',time);
[error_noargo]=twin_error('hdata_twin_correction_noargo2',time);
[error_nowhoi]=twin_error('hdata_twin_correction_nowhoi2',time);

save ../error/josh_error3.mat time error_all error_argo error_noargo error_nowhoi
