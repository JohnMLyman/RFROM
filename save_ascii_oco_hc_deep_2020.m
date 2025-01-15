d=[tim_time_deep';tim_hc_deep';tim_se_deep']';
fid = fopen('OHCA_700_2000_NCEI_2020_new.txt', 'w');
fprintf(fid, 'Time(Years) OHCA(Joules 1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);


d=[time_deep';hc_one_deep';hc_se_deep']';
fid = fopen('OHCA_700_2000_PMEL_2020_new.txt', 'w');
fprintf(fid, 'Time(Years) OHCA(Joules 1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);

d=[ishii_time_deep';ishii_hc_deep';ishii_se_deep']';
fid = fopen('OHCA_700_2000_MRI_2020_new.txt', 'w');
fprintf(fid, 'Time(Years) OHCA(Joules 1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);

d=[cheng_time_deep';cheng_hc_deep';cheng_se_deep']';
fid = fopen('OHCA_700_2000_IAP_2020_new.txt', 'w');
fprintf(fid, 'Time(Years) OHCA(Joules 1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);
