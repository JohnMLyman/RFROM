function pos_bad=find_bad_depths_1000(LON,LAT)




pos_Herd_Island=(LON>35&LON<80&LAT<-44&LAT>-55);
pos_Argitina1=(LON>305&LON<326&LAT<-52&LAT>-65);
pos_Argitina2=LON>316&LON<326&LAT<-52&LAT>-56;

pos_Chile=LON>280&LON<282&LAT<-33&LAT>-34;

pos_Easter=LON>267&LON<272&LAT<1&LAT>-2;

pos_Antiartica=LAT<-60;
pos_New_Zeland1=(LON>174.5&LON<186&LAT<-42.5&LAT>-45);

pos_New_Zeland2=(LON>165&LON<185&LAT<-49.4&LAT>-55);
pos_New_Zeland3=(LON>181&LON<182&LAT<-30&LAT>-32);

pos_SO1=(LON>0&LON<8&LAT<-40.4&LAT>-59);
pos_Madagascar1=(LON>54&LON<65&LAT<-5&LAT>-25);
pos_India1=LON>70.5&LON<74&LAT<10&LAT>-10;
pos_India2=LON>72&LON<73&LAT<14&LAT>10;
pos_India3=LON>92&LON<100&LAT<-8&LAT>-18;

pos_Madagascar2=LON>50&LON<60&LAT<0&LAT>-9;
pos_Madagascar3=LON>40&LON<50&LAT<-30&LAT>-40;
pos_Madagascar4=LON>43&LON<48.5&LAT<-11&LAT>-13;
pos_Madagascar5=LON>50.6&LON<51.8&LAT<-8&LAT>-11.5;



pos_Indonisa1=LON>91.5&LON<94.2&LAT<14.7&LAT>6;
pos_Indonisa2=LON>95.5&LON<99.5&LAT<2&LAT>-4;
pos_Indonisa3=LON>99.5&LON<102&LAT<0&LAT>-6;
pos_Indonisa4=LON>102&LON<104&LAT<-2&LAT>-8;
pos_Indonisa5=LON>104&LON<105.5&LAT<-5&LAT>-8;
pos_Indonisa6=LON>94&LON<98&LAT<4.9&LAT>2;
pos_Indonisa7=LON>94.5&LON<97&LAT<6.2&LAT>5;
pos_Indonisa8=LON>107&LON<124&LAT<-7.5&LAT>-11;
pos_Indonisa9=LON>105&LON<107&LAT<-6&LAT>-7.5;
pos_Indonisa10=LON>118&LON<130&LAT<3&LAT>-4.8;
pos_Indonisa11=LON>123&LON<127.5&LAT<-7&LAT>-9.5;
pos_Indonisa12=LON>124.9&LON<125.5&LAT<-9.3&LAT>-9.65;
pos_Indonisa13=LON>118&LON<125&LAT<-4.5&LAT>-7.5;
pos_Indonisa14=LON>129&LON<132&LAT<-4&LAT>-8.5;
pos_Indonisa15=LON>132&LON<133.5&LAT<-4.6&LAT>-6.2;
pos_Indonisa16=LON>129.5&LON<131.7&LAT<-2.6&LAT>-4.2;
pos_Indonisa17=LON>123&LON<133.5&LAT<-4.6&LAT>-6.2;
pos_Indonisa18=LON>124&LON<127&LAT<8&LAT>3;

pos_Papa1=LON>154&LON<164&LAT<-4.5&LAT>-11;

pos_Hawaii=LON>185&LON<210&LAT<28&LAT>16;

pos_PacificIsland1=LON>155&LON<192&LAT<-8&LAT>-24;
pos_PacificIsland2=LON>148&LON<153&LAT<-15&LAT>-18;
pos_PacificIsland3=LON>156&LON<163&LAT<-20&LAT>-60;
pos_PacificIsland4=LON>165&LON<170.5&LAT<-27.5&LAT>-40;
pos_PacificIsland5=LON>170.3&LON<182&LAT<-47&LAT>-50;
pos_PacificIsland6=LON>140&LON<175&LAT<30&LAT>-1;
pos_PacificIsland7=LON>143&LON<154&LAT<0&LAT>-7;
pos_PacificIsland8=LON>211&LON<218&LAT<-16&LAT>-17;
pos_PacificIsland9=LON>165&LON<180&LAT<40&LAT>28;
pos_PacificIsland10=LON>205&LON<220&LAT<-10&LAT>-22;
pos_PacificIsland11=LON>133&LON<136&LAT<9&LAT>6;


pos_China1=LON>111&LON<116&LAT<17.5&LAT>15;
pos_China2=LON>115.5&LON<117.5&LAT<12.5&LAT>10;
pos_China3=LON>109.5&LON<115&LAT<8.6&LAT>7.2;
pos_China4=LON>121.6&LON<122.6&LAT<21&LAT>20;

pos_Japan1=LON>134&LON<135.5&LAT<40&LAT>36.8;
pos_Japan2=LON>138.8&LON<140.5&LAT<34.8&LAT>32;

pos_Gulfstream=LON>313.5&LON<317&LAT<50&LAT>46;

pos_NorthAtlantic1=LON>342&LON<349&LAT<61&LAT>55;
pos_NorthAtlantic2=LON>349&LON<356&LAT<63.5&LAT>61;
pos_NorthAtlantic3=LON>349&LON<355&LAT<61.2&LAT>60.3;
pos_NorthAtlantic4=LON>346&LON<354&LAT<72&LAT>69;
pos_NorthAtlantic5=LON>355.4&LON<356.8&LAT<62.8&LAT>62;

pos_Atlantic1=LON>328&LON<338&LAT<40&LAT>36;
pos_Atlantic2=LON>332&LON<339&LAT<19&LAT>13;
pos_Atlantic3=LON>330&LON<346&LAT<34&LAT>28.5;
pos_Atlantic4=LON>294.5&LON<296.5&LAT<33.5&LAT>31;
pos_Atlantic5=LON>345&LON<347&LAT<30&LAT>28.8;
pos_Atlantic6=LON>341.5&LON<346.5&LAT<28.7&LAT>27.8;

pos_Med1=LON>1.5&LON<5&LAT<40.5&LAT>38.5;
pos_Med2=LON>1&LON<1.7&LAT<39.5&LAT>38.4;
pos_Med3=LON>22&LON<29&LAT<36.2&LAT>34.6;
pos_Med4=LON>32&LON<35.5&LAT<36.2&LAT>34.6;

pos_Red=LON>52&LON<55&LAT<13.5&LAT>11;

pos_Japan3=LON>122.5&LON<127&LAT<25.6&LAT>24;
pos_Japan4=LON>128.5&LON<130.2&LAT<31.5&LAT>27.5;
pos_Japan5=LON>127&LON<129&LAT<28.5&LAT>26;
pos_Japan6=LON>125.5&LON<127&LAT<26&LAT>25.6;


remove_area=zeros(size(LON));
% pos_Madagascar3=remove_area;
% pos_Madagascar1=remove_area;
% pos_Madagascar2=remove_area;

% Antiartica
pos_Antiartica_1000=LON>60&LON<85&LAT>-60&LAT<-30;
pos_Indonisa_1000_1=LON>112.5&LON<113.7&LAT>-20.8&LAT<-19;
pos_Indonisa_1000_2=LON>122&LON<130&LAT>-8.55&LAT<-5.5;
pos_Indonisa_1000_3=LON>123&LON<125.2&LAT>-10.4&LAT<-9;
pos_Indonisa_1000_4=LON>122.2&LON<123.3&LAT>-11.2&LAT<-10.8;
pos_Indonisa_1000_5=LON>94&LON<95.5&LAT>13.4&LAT<11.4;
pos_Indonisa_1000_6=LON>92&LON<95.2&LAT>4&LAT<7;
pos_Indonisa_1000_7=LON>110&LON<114&LAT>6.5&LAT<10;
pos_Indonisa_1000_8=LON>113.5&LON<115.5&LAT>9.5&LAT<12;
pos_Indonisa_1000_9=LON>117.4&LON<118&LAT>10.8&LAT<11.7;
pos_Indonisa_1000_10=LON>121&LON<121.7&LAT>9.4&LAT<10.3;
pos_Indonisa_1000_11=LON>121.5&LON<122&LAT>21.2&LAT<22.2;
pos_Indonisa_1000_12=LON>126.6&LON<127.8&LAT>25.4&LAT<27;
pos_Indonisa_1000_13=LON>128.2&LON<129.6&LAT>27.1&LAT<29.2;

pos_Pacific_1000_1=LON>139.2&LON<140.8&LAT>30.5&LAT<33;
pos_Pacific_1000_2=LON>133.5&LON<136&LAT>37.8&LAT<41;
pos_Pacific_1000_3=LON>190&LON<250&LAT>-24&LAT<10;
pos_Pacific_1000_4=LON>258&LON<262&LAT>-28&LAT<-24.5;
pos_Pacific_1000_5=LON>178&LON<185&LAT>-34&LAT<-23;
pos_Pacific_1000_6=LON>158&LON<170&LAT>-38&LAT<-22;
pos_Pacific_1000_7=LON>144&LON<153&LAT>-49&LAT<-46;
pos_Pacific_1000_8=LON>153.1&LON<180&LAT>-4.4&LAT<0;
pos_Pacific_1000_9=LON>125&LON<131&LAT>3.2&LAT<4.8;
pos_Pacific_1000_10=LON>132&LON<146&LAT>7&LAT<11;
pos_Pacific_1000_11=LON>268&LON<280&LAT>3.8&LAT<6;
pos_Pacific_1000_12=LON>277.2&LON<278.6&LAT>-.4&LAT<0;
pos_Pacific_1000_13=LON>268&LON<270.5&LAT>-69.2&LAT<-68.2;
pos_Pacific_1000_14=LON>240&LON<246&LAT>-70.6&LAT<-69.6;
pos_Pacific_1000_15=LON>160&LON<176&LAT>-68.2&LAT<-65.5;
pos_Pacific_1000_16=LON>145.5&LON<146&LAT>-10.6&LAT<-9.8;
pos_Pacific_1000_17=LON>146.4&LON<147&LAT>-14&LAT<-13;
pos_Pacific_1000_18=LON>147.4&LON<148.2&LAT>-17&LAT<-15.6;
pos_Pacific_1000_19=LON>149&LON<150.7&LAT>-18.3&LAT<-17.7;
pos_Pacific_1000_20=LON>154.3&LON<154.65&LAT>-21.5&LAT<-20.5;
pos_Pacific_1000_21=LON>163.5&LON<165&LAT>-50&LAT<-47;
pos_Pacific_1000_22=LON>172.7&LON<173.3&LAT>-32&LAT<-29;
pos_Pacific_1000_23=LON>214&LON<214.5&LAT>-25&LAT<-24;
pos_Pacific_1000_24=LON>191.8&LON<193&LAT>-39&LAT<-37.5;
pos_Pacific_1000_25=LON>184&LON<184.5&LAT>27.7&LAT<28.3;




pos_Indian_1000_1=LON>45&LON<48&LAT>-27.5&LAT<-27;
pos_Indian_1000_2=LON>37.5&LON<41.5&LAT>-22.6&LAT<-21;
pos_Indian_1000_3=LON>44&LON<49&LAT>-10&LAT<-7.5;
pos_Indian_1000_4=LON>41&LON<42.5&LAT>-12.8&LAT<-11.8;
pos_Indian_1000_5=LON>61&LON<63&LAT>21&LAT<23;
pos_Indian_1000_6=LON>71&LON<73&LAT>12&LAT<14;
pos_Indian_1000_7=LON>73&LON<74&LAT>10&LAT<11.5;
pos_Indian_1000_8=LON>61&LON<63&LAT>21&LAT<23;
pos_Indian_1000_9=LON>93.5&LON<95.5&LAT>11&LAT<13.5;

pos_Atlantic_1000_1=LON>2&LON<8&LAT>-34&LAT<-20;
pos_Atlantic_1000_2=LON>6&LON<8&LAT>-.5&LAT<-2.5;
pos_Atlantic_1000_3=LON>329&LON<337&LAT>59.5&LAT<63;
pos_Atlantic_1000_4=LON>338&LON<344&LAT>54&LAT<60;
pos_Atlantic_1000_5=LON>348.8&LON<349.6&LAT>57&LAT<58;
pos_Atlantic_1000_6=LON>356&LON<357.625&LAT>61.8&LAT<64;
pos_Atlantic_1000_7=LON>355&LON<355.5&LAT>60.8&LAT<61.3;
pos_Atlantic_1000_8=LON>350.5&LON<352.5&LAT>68&LAT<70;
pos_Atlantic_1000_9=LON>342&LON<343&LAT>69&LAT<69.6;
pos_Atlantic_1000_10=LON>340.8&LON<341.4&LAT>68.4&LAT<69;
pos_Atlantic_1000_11=LON>324&LON<332&LAT>37&LAT<39;
pos_Atlantic_1000_12=LON>347&LON<350&LAT>42.5&LAT<43.5;
pos_Atlantic_1000_13=LON>345&LON<347&LAT>36.7&LAT<37.4;
pos_Atlantic_1000_14=LON>348&LON<345&LAT>29.5&LAT<32;
pos_Atlantic_1000_15=LON>343&LON<346.5&LAT>68.5&LAT<72.5;
pos_Atlantic_1000_16=LON>340.7&LON<341.2&LAT>68.35&LAT<68.7;
pos_Atlantic_1000_17=LON>349&LON<351&LAT>59&LAT<59.8;
pos_Atlantic_1000_18=LON>340.7&LON<341.2&LAT>68.35&LAT<68.7;
pos_Atlantic_1000_19=LON>348&LON<350&LAT>61&LAT<61.8;
pos_Atlantic_1000_20=LON>345&LON<348&LAT>29.5&LAT<32;
pos_Atlantic_1000_21=LON>344&LON<344.8&LAT>27.2&LAT<28.2;
pos_Atlantic_1000_22=LON>344.5&LON<346.5&LAT>-9&LAT<-7;
pos_Atlantic_1000_23=LON>320&LON<355&LAT>-65&LAT<-25;
pos_Atlantic_1000_24=LON>330&LON<331.5&LAT>-21&LAT<-20;
pos_Atlantic_1000_25=LON>322.2&LON<323.8&LAT>-17.2&LAT<-16.6;
pos_Atlantic_1000_26=LON>321.8&LON<323.2&LAT>-20.8&LAT<-20.3;
pos_Atlantic_1000_27=LON>344.5&LON<347&LAT>-8.4&LAT<-7.2;
pos_Atlantic_1000_28=LON>323.5&LON<325.5&LAT>-4.1&LAT<-3.4;
pos_Atlantic_1000_29=LON>6&LON<8&LAT>-.5&LAT<3;





pos_GOA_1=LON>275.8&LON<276.6&LAT>17&LAT<20;
pos_GOA_2=LON>278&LON<280.5&LAT>18&LAT<20.5;
pos_GOA_3=LON>294.375&LON<302&LAT>12&LAT<19;
pos_GOA_4=LON>285.5&LON<287.5&LAT>22&LAT<23;
pos_GOA_5=LON>285.5&LON<287.5&LAT>22&LAT<23;
pos_GOA_6=LON>286&LON<291&LAT>20.4&LAT<23.5;
pos_GOA_7=LON>291.5&LON<294&LAT>11.9&LAT<12.6;
pos_GOA_8=LON>292.4&LON<293.8&LAT>11.6&LAT<12.4;
pos_GOA_9=LON>290&LON<291.5&LAT>20&LAT<21;
pos_GOA_10=LON>286&LON<286.5&LAT>19.2&LAT<19.8;
pos_GOA_11=LON>283.5&LON<285&LAT>16.5&LAT<19;
pos_GOA_12=LON>279.5&LON<280.5&LAT>13&LAT<15;
pos_GOA_13=LON>278.4&LON<279.3&LAT>11&LAT<13;
pos_GOA_14=LON>281.3&LON<281.7&LAT>15.8&LAT<16.3;
pos_GOA_15=LON>273.9&LON<274.4&LAT>22.4&LAT<23.4;


pos_GOAL_1=LON>165&LON<185&LAT>50&LAT<56;
pos_GOAL_2=LON>182&LON<194&LAT>50&LAT<54;

























pos_Med_1000_1=LON>32&LON<34&LAT>33.4&LAT<34.4;
pos_Med_1000_2=LON>10.6&LON<11.3&LAT>41.05&LAT<41.45;
















pos_bad1=pos_New_Zeland2|pos_New_Zeland1|pos_Argitina1|pos_Argitina2|pos_Herd_Island|...
    pos_SO1|pos_Madagascar1|pos_Madagascar2|pos_India1|pos_India2|pos_Indonisa1|...
    pos_Indonisa2|pos_Indonisa3|pos_Indonisa4|pos_Indonisa5|pos_Indonisa6|pos_Indonisa7|...
    pos_Indonisa8|pos_Indonisa9|pos_Indonisa10|pos_Indonisa11|pos_Indonisa12|...
    pos_Indonisa13|pos_Indonisa14|pos_Indonisa15|pos_Indonisa16|pos_Indonisa17|...
    pos_Papa1|pos_PacificIsland1|pos_PacificIsland2|pos_PacificIsland3|pos_PacificIsland4|...
    pos_PacificIsland5|pos_PacificIsland6|pos_Hawaii|pos_PacificIsland7|pos_PacificIsland8|...
    pos_China1|pos_China2|pos_China3|pos_China4|pos_Indonisa18|pos_Japan1|pos_Japan2|...
    pos_Chile|pos_Easter|pos_Gulfstream|pos_NorthAtlantic1|pos_NorthAtlantic2|...
    pos_NorthAtlantic3|pos_NorthAtlantic4|pos_NorthAtlantic5|pos_Atlantic1|...
    pos_Atlantic2|pos_Atlantic3|pos_Atlantic4|pos_Atlantic5|pos_Atlantic6|...
    pos_PacificIsland9|pos_PacificIsland10|pos_India3|pos_Madagascar3|pos_Med1|...
    pos_Med2|pos_Med3|pos_Med4|pos_Red|pos_Madagascar4|pos_Madagascar5|pos_Japan3|...
    pos_Japan4|pos_Japan5|pos_Japan6|pos_PacificIsland11|pos_New_Zeland3|...
    pos_Antiartica_1000|pos_Indonisa_1000_1|pos_Indonisa_1000_2|pos_Indonisa_1000_3|pos_Indonisa_1000_4|...
    pos_Indonisa_1000_5|pos_Indonisa_1000_6|pos_Indonisa_1000_7|pos_Indonisa_1000_8|pos_Indonisa_1000_9|...
    pos_Indonisa_1000_10|pos_Indonisa_1000_11|pos_Indonisa_1000_12|pos_Indonisa_1000_13|...
    pos_Pacific_1000_1|pos_Pacific_1000_2|pos_Pacific_1000_3|pos_Pacific_1000_4|...
    pos_Pacific_1000_5|pos_Pacific_1000_6|pos_Pacific_1000_7|...
    pos_Pacific_1000_8 |pos_Pacific_1000_9 |pos_Pacific_1000_10|pos_Pacific_1000_11|...
    pos_Pacific_1000_12|pos_Pacific_1000_13|pos_Pacific_1000_14|pos_Pacific_1000_15|...
    pos_Indian_1000_1|pos_Indian_1000_2|pos_Indian_1000_3| pos_Indian_1000_4|...
    pos_Indian_1000_5|pos_Indian_1000_6|pos_Indian_1000_6|pos_Indian_1000_7|...
    pos_Indian_1000_8|pos_Indian_1000_9|pos_Atlantic_1000_1|pos_Atlantic_1000_2|...
    pos_Atlantic_1000_3|pos_Atlantic_1000_4|pos_Atlantic_1000_5|pos_Atlantic_1000_6|...
    pos_Atlantic_1000_7|pos_Atlantic_1000_8|pos_Atlantic_1000_9|pos_Atlantic_1000_10|...
    pos_Atlantic_1000_11|pos_Atlantic_1000_12|pos_Atlantic_1000_13|pos_Atlantic_1000_14|...
    pos_Med_1000_1|pos_Med_1000_2;

pos_bad2=pos_Atlantic_1000_15|pos_Atlantic_1000_16|pos_Atlantic_1000_17|...
    pos_Atlantic_1000_18|pos_Atlantic_1000_19|pos_Atlantic_1000_20|...
    pos_Atlantic_1000_21|pos_Atlantic_1000_22|pos_Atlantic_1000_23|...
    pos_Atlantic_1000_24|pos_Atlantic_1000_25|pos_Atlantic_1000_26|...
    pos_Atlantic_1000_27|pos_Atlantic_1000_28|pos_GOA_1|pos_GOA_2|pos_GOA_3|...
    pos_GOA_4|pos_GOA_5|pos_GOA_6|pos_GOA_7|pos_GOA_8|pos_GOA_9|...
    pos_GOA_10|pos_GOA_11|pos_GOA_12|pos_GOA_13|pos_Pacific_1000_16|...
    pos_Pacific_1000_17|pos_Pacific_1000_18|pos_Pacific_1000_19|...
    pos_Pacific_1000_20|pos_Pacific_1000_21|pos_Pacific_1000_22|...
    pos_Pacific_1000_23|pos_Pacific_1000_24|pos_Pacific_1000_25|...
    pos_GOAL_1|pos_GOAL_2|pos_GOA_14|pos_GOA_15|pos_Atlantic_1000_29;


pos_bad=pos_bad1|pos_bad2;
% |pos_Antiartica;


