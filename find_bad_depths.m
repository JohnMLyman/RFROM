function pos_bad=find_bad_depths(LON,LAT)




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

pos_bad=pos_New_Zeland2|pos_New_Zeland1|pos_Argitina1|pos_Argitina2|pos_Herd_Island|...
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
    pos_Japan4|pos_Japan5|pos_Japan6|pos_PacificIsland11|pos_New_Zeland3;
% |pos_Antiartica;

