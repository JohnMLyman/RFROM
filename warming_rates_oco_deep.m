% computes the 90% cofedence on the the slope

start_year=1993


pos_tim=find(tim_time>start_year);

[tim_rate]=compute_warming_no_weight_3(tim_hc(pos_tim)'./10,tim_hc(pos_tim)/1000',tim_time(pos_tim)');

pos_simon=find(simon_time>start_year);

[simon_rate]=compute_warming_no_weight_3(simon_hc(pos_simon)'./10,simon_hc(pos_simon)/1000',simon_time(pos_simon)');

pos_catia=find(catia_time>start_year); 

[catia_rate]=compute_warming_no_weight_3(catia_hc(pos_catia)'./10,catia_hc(pos_catia)/1000',catia_time(pos_catia)');

pos_pmel=find(time>start_year);

[pmel_rate]=compute_warming_no_weight_3(hc_one(pos_pmel)./10,hc_one(pos_pmel)/1000,time(pos_pmel));

pos_ishii=find(ishii_time>start_year);

[ishii_rate]=compute_warming_no_weight_3(ishii_hc(pos_ishii)'./10,ishii_hc(pos_ishii)/1000',ishii_time(pos_ishii)');

pos_cheng=find(cheng_time>start_year);

[cheng_rate]=compute_warming_no_weight_3(cheng_hc(pos_cheng)'./10,cheng_hc(pos_cheng)/1000',cheng_time(pos_cheng)');



pmel_rate
catia_rate
simon_rate
tim_rate
ishii_rate
cheng_rate


start_year_deep=1993
pos_tim_deep=find(tim_time_deep>start_year_deep);

[tim_rate_deep]=compute_warming_no_weight_3(tim_hc_deep(pos_tim_deep)'./10,tim_hc_deep(pos_tim_deep)/1000',tim_time_deep(pos_tim_deep)');

% % % pos_simon_deep=find(simon_time_deep>start_year_deep);
% % % 
% % % [simon_rate_deep]=compute_warming_no_weight_3(simon_hc_deep(pos_simon_deep)'./10,simon_hc_deep(pos_simon_deep)/1000',simon_time_deep(pos_simon_deep)');
% % % 
% % % pos_catia_deep=find(catia_time_deep>start_year_deep); 
% % % 
% % % [catia_rate_deep]=compute_warming_no_weight_3(catia_hc_deep(pos_catia_deep)'./10,catia_hc_deep(pos_catia_deep)/1000',catia_time_deep(pos_catia_deep)');

pos_pmel_deep=find(time_deep>start_year_deep);

[pmel_rate_deep]=compute_warming_no_weight_3(hc_one_deep(pos_pmel_deep)./10,hc_one_deep(pos_pmel_deep)/1000,time_deep(pos_pmel_deep));

pos_ishii_deep=find(ishii_time_deep>start_year_deep);

[ishii_rate_deep]=compute_warming_no_weight_3(ishii_hc_deep(pos_ishii_deep)'./10,ishii_hc_deep(pos_ishii_deep)/1000',ishii_time_deep(pos_ishii_deep)');

pos_cheng_deep=find(cheng_time_deep>start_year_deep);

[cheng_rate_deep]=compute_warming_no_weight_3(cheng_hc_deep(pos_cheng_deep)'./10,cheng_hc_deep(pos_cheng_deep)/1000',cheng_time_deep(pos_cheng_deep)');

pos_simon_deep=find(simon_time_deep>start_year_deep);

[simon_rate_deep]=compute_warming_no_weight_3(simon_hc_deep(pos_simon_deep)'./10,simon_hc_deep(pos_simon_deep)/1000',simon_time_deep(pos_simon_deep)');


pmel_rate_deep
% % % catia_rate_deep
% % % simon_rate_deep
tim_rate_deep
ishii_rate_deep
cheng_rate_deep
simon_rate_deep




%%%%
start_year_deep=2005;
start_year=2005;
pos_tim_deep=find(tim_time_deep>start_year_deep);

pos_tim=find(tim_time>start_year);

[tim_rate_total]=compute_warming_no_weight_3((tim_hc(pos_tim)'+tim_hc_deep(pos_tim_deep)')./10,(tim_hc(pos_tim)+tim_hc_deep(pos_tim_deep))/1000',tim_time_deep(pos_tim_deep)');

% % % pos_simon_deep=find(simon_time_deep>start_year_deep);
% % % 
% % % [simon_rate_deep]=compute_warming_no_weight_3(simon_hc_deep(pos_simon_deep)'./10,simon_hc_deep(pos_simon_deep)/1000',simon_time_deep(pos_simon_deep)');
% % % 
% % % pos_catia_deep=find(catia_time_deep>start_year_deep); 
% % % 
% % % [catia_rate_deep]=compute_warming_no_weight_3(catia_hc_deep(pos_catia_deep)'./10,catia_hc_deep(pos_catia_deep)/1000',catia_time_deep(pos_catia_deep)');

pos_pmel_deep=find(time_deep>start_year_deep);
pos_pmel=find(time>start_year);



[pmel_rate_total]=compute_warming_no_weight_3((hc_one(pos_pmel)+hc_one_deep(pos_pmel_deep))./10,(hc_one(pos_pmel)+hc_one_deep(pos_pmel_deep))/1000,time_deep(pos_pmel_deep));



pos_ishii_deep=find(ishii_time_deep>start_year_deep);
pos_ishii=find(ishii_time>start_year);


[ishii_rate_total]=compute_warming_no_weight_3((ishii_hc(pos_ishii)'+ishii_hc_deep(pos_ishii_deep)')./10,(ishii_hc(pos_ishii)+ishii_hc_deep(pos_ishii_deep))/1000',ishii_time_deep(pos_ishii_deep)');
pos_cheng_deep=find(cheng_time_deep>start_year_deep);
pos_cheng=find(cheng_time>start_year);


[cheng_rate_total]=compute_warming_no_weight_3((cheng_hc(pos_cheng)'+cheng_hc_deep(pos_cheng_deep)')./10,(cheng_hc(pos_cheng)+cheng_hc_deep(pos_cheng_deep))/1000',cheng_time_deep(pos_cheng_deep)');

pos_simon_deep=find(simon_time_deep>start_year_deep);
pos_simon=find(simon_time>start_year);


[simon_rate_total]=compute_warming_no_weight_3((simon_hc(pos_simon)'+simon_hc_deep(pos_simon_deep)')./10,(simon_hc(pos_simon)+simon_hc_deep(pos_simon_deep))/1000',simon_time_deep(pos_simon_deep)');


tim_rate_total
ishii_rate_total
cheng_rate_total
simon_rate_total
pmel_rate_total

% % % catia_rate_deep
% % % simon_rate_deep

% 
% [weighted_slope, weight_slope_error]=compute_warming_number_se((hc_one(pos_pmel)+hc_one_deep(pos_pmel_deep))'./10,(hc_se_total(pos_pmel_deep))'/10,time_deep(pos_pmel_deep)');
