
file='D:/WOA2013v2/woa13_decav_s01_01v2.nc';
        
        depth=(ncread(file,'depth'));
        lon=(ncread(file,'lon'));
        lat=(ncread(file,'lat'));
        lon=double(lon);
        lat=double(lat);

        
        sal=nans(length(lon),length(lat),length(depth),12);

 time_woa=[15
    46
    75
   106
   136
   167
   197
   228
   259
   289
   320
   350
];


for i=1:12
    
    if i<10
        name_month=['0',num2str(i)];
    else
        name_month=num2str(i);
    end
    
        file=['D:/WOA2013v2/woa13_decav_s',name_month,'_01v2.nc'];
        
        
        sal(:,:,:,i)=ncread(file,'s_an');

end

