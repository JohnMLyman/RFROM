% computes the 90% cofedence on the the slope

start_year=1993;


pos_tim=find(tim_time>start_year);

[tim_rate]=compute_warming_no_weight_3(tim_hc(pos_tim)'./10,tim_hc(pos_tim)/1000',tim_time(pos_tim)');

pos_simon=find(simon_time>start_year);

[simon_rate]=compute_warming_no_weight_3(simon_hc(pos_simon)'./10,simon_hc(pos_simon)/1000',simon_time(pos_simon)');

pos_catia=find(catia_time>start_year); 

[catia_rate]=compute_warming_no_weight_3(catia_hc(pos_catia)'./10,catia_hc(pos_catia)/1000',catia_time(pos_catia)');

pos_pmel=find(time>start_year);

[pmel_rate]=compute_warming_no_weight_3(hc_one(pos_pmel)./10,hc_one(pos_pmel)/1000,time(pos_pmel)');

pos_ishii=find(ishii_time>start_year);

[ishii_rate]=compute_warming_no_weight_3(ishii_hc(pos_ishii)'./10,ishii_hc(pos_ishii)/1000',ishii_time(pos_ishii)');



pmel_rate
catia_rate
simon_rate
tim_rate
ishii_rate

