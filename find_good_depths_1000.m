function pos_good=find_good_depths_1000(LON,LAT)

pos_Med_1000_1=LON>12&LON<14&LAT>35&LAT<37;
pos_Med_1000_2=LON>16.5&LON<19&LAT>41&LAT<43;
pos_Med_1000_3=LON>23&LON<25&LAT>39&LAT<40;


pos_Ind_1000_1=LON>123.5&LON<126&LAT>8.5&LAT<10.5;
pos_Ind_1000_2=LON>122&LON<123&LAT>11.5&LAT<13.5;


pos_good=pos_Med_1000_1|pos_Med_1000_2|pos_Med_1000_3|...
    pos_Ind_1000_1|pos_Ind_1000_2;



% |pos_Antiartica;


