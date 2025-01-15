

d=[simon_time';simon_hc';simon_se']';
fid = fopen([path_curves,'OHCA_0_700_Hadley_2023_new.txt'], 'w');
fprintf(fid, 'Time(Years) OHCA(Joules  1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);


d=[tim_time';tim_hc';tim_se']';
fid = fopen([path_curves,'OHCA_0_700_NCEI_2023_new.txt'], 'w');
fprintf(fid, 'Time(Years) OHCA(Joules 1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);


d=[time;hc_one;hc_se]';
fid = fopen([path_curves,'OHCA_0_700_PMEL_2023_new.txt'], 'w');
fprintf(fid, 'Time(Years) OHCA(Joules 1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);


d=[catia_time';catia_hc';catia_se']';
fid = fopen([path_curves,'OHCA_0_700_CSIRO_2023_new.txt'], 'w');
fprintf(fid, 'Time(Years) OHCA(Joules 1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);

d=[ishii_time';ishii_hc';ishii_se']';
fid = fopen([path_curves,'OHCA_0_700_MRI_2023_new.txt'], 'w');
fprintf(fid, 'Time(Years) OHCA(Joules 1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);

d=[cheng_time';cheng_hc';cheng_se']';
fid = fopen([path_curves,'OHCA_0_700_IAP_2023_new.txt'], 'w');
fprintf(fid, 'Time(Years) OHCA(Joules 1e21) SE(Joules 1e21)\n\n');
fprintf(fid, '%10.1f  %15.3f %8.3f \n', d');
fclose(fid);
