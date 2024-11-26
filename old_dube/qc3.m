% the new qc file qc3
% 7/19/05 JML

% round 3 
cd './All_Data'
e=dir('e*.mat');[dd,ii]=sortrows(strvcat(e(:).name));
e=e(ii);clear dd ii

% loop through files and perform qc
tic,for i=1:length(e)
  load(e(i).name);
  len(i)=size(temp,1);
  yd=dt(:,1)+(dt(:,2)-1)/12.+(dt(:,3)-1)/365.;
  
  %find the right dates (ie only preform the qc on the times that
  % I cheacked.
  
  good_times=find(yd < 2006);
  temp2=temp;
  temp=temp(good_times,:);
   jj=[];
 % take care of special cases
  switch str2num(e(i).name(2:5))

%e1000.mat
case 1000
    jj=[jj;find(temp(:,5)<12.5)];
    jj=[jj;find(temp(:,6)<12.5)];
    
   
case 1005
    jj=[jj;find(temp(:,1)<12)];
    jj=[jj;find(temp(:,4)<11)];
    
case 1007
    jj=[jj;find(temp(:,1)<10)];
    
case 1008
    jj=[jj;find(temp(:,1)<10)];    

case 1009
    jj=[jj;find(temp(:,1)<10)];    
    
case 1013
    jj=[jj;find(temp(:,1)<10)];
    jj=[jj;find(temp(:,3)<11)]; 
    
case 1014
    jj=[jj;find(temp(:,1)<11)];

case 1015
     jj=[jj;find(temp(:,19)<8)];
    
case 1016
    jj=[jj;find(temp(:,1)<20)];

case 1017
    jj=[jj;find(temp(:,1)<20)];
        
    
case 1108
    jj=[jj;find(temp(:,5)<17.5)];
    jj=[jj;find(temp(:,12)<6)];

case 1112
     jj=[jj;find(temp(:,1)<15)];

    
case 1113
    jj=[jj;find(temp(:,11)<5)];
    
case 1300
    jj=[jj;find(temp(:,1)<8)];
    jj=[jj;find(temp(:,5)<3)];
    jj=[jj;find(temp(:,6)<5)];
    jj=[jj;find(temp(:,7)<8)];
     jj=[jj;find(temp(:,8)<1)];
    jj=[jj;find(temp(:,4)<5)];
 
    
case 1301
    jj=[jj;find(temp(:,1)<11.5)];
    jj=[jj;find(temp(:,2)<10)];
    jj=[jj;find(temp(:,10)<11)];
    jj=[jj;find(temp(:,7)<11)];
    jj=[jj;find(temp(:,8)<9)];
    jj=[jj;find(temp(:,6)<9)];
    jj=[jj;find(temp(:,4)<1)];
    jj=[jj;find(temp(:,5)<3)];
    jj=[jj;find(temp(:,8)<1)];
    
case 1302
    jj=[jj;find(temp(:,7)<7)];
    jj=[jj;find(temp(:,8)<7)];
    jj=[jj;find(temp(:,9)<7)];
    
case 1303
    jj=[jj;find(temp(:,1)<14)];
    
case 1416
    jj=[jj;find(temp(:,2)>32)];
    
case 1517
    jj=[jj;find(temp(:,11)>18)];
    jj=[jj;find(temp(:,1)>30)];
    
case 1600
      jj=[jj;find(temp(:,11)>25)];
       jj=[jj;find(temp(:,5)<2)];
      
case 3003
    jj=[jj;find(temp(:,1)<15)];

case 3006
    jj=[jj;find(temp(:,1)<15)];
    jj=[jj;find(temp(:,3)<2)];
    
case 3007
    jj=[jj;find(temp(:,1)<15)];
    jj=[jj;find(temp(:,3)<2)];    
          
case 3008
    jj=[jj;find(temp(:,1)<15)];
    jj=[jj;find(temp(:,10)<8)];
 
case 3010    
    jj=[jj;find(temp(:,2)<13)];
    
case 3011
     jj=[jj;find(temp(:,1)<15)];

case 3016
    jj=[jj;find(temp(:,1)<14)];     
     
case 3101
     jj=[jj;find(temp(:,11)<5)];

case 3107
    jj=[jj;find(temp(:,1)<15)];
    jj=[jj;find(temp(:,10)<11)];
    
case 3114
    jj=[jj;find(temp(:,1)<10)];


    
case 3115
    jj=[jj;find(temp(:,1)<20)];
    jj=[jj;find(temp(:,2)<21)];
 
    
case 3117
    jj=[jj;find(temp(:,1)<15)];
  
case 3211
    jj=[jj;find(temp(:,1)<15)];

case 3216
    jj=[jj;find(temp(:,1)<7)];
    jj=[jj;find(temp(:,6)<12)];
    jj=[jj;find(temp(:,9)<12)];
    
case 3217
    jj=[jj;find(temp(:,5)>31)];
   
case 3300
    jj=[jj;find(temp(:,1)<5)];
  
case 3303
    jj=[jj;find(temp(:,1)<8)]; 

case 3305
    jj=[jj;find(temp(:,1)<12)];

case 3308
     jj=[jj;find(temp(:,2)<11)];
     jj=[jj;find(temp(:,3)<10)];
  
case 3309     
   jj=[jj;find(temp(:,1)<9)]; 
    
case 3315
   jj=[jj;find(temp(:,2)<7)];
   jj=[jj;find(temp(:,4)<6)];
   
case 3316
    jj=[jj;find(temp(:,1)>25)];
    jj=[jj;find(temp(:,3)<6)];
    
case 3310
     jj=[jj;find(temp(:,1)<9)];
     jj=[jj;find(temp(:,2)>30)]; 

case 3311
    jj=[jj;find(temp(:,3)<5)];

case 3414    
    jj=[jj;find(temp(:,3)<4)];
    
case 3417
    jj=[jj;find(temp(:,4)>24)];
    jj=[jj;find(temp(:,1)<3)];

case 3500
    jj=[jj;find(temp(:,11)>25)];
    jj=[jj;find(temp(:,8)>12)];
    
case 3700
     jj=[jj;find(temp(:,1)>15)];
     
case 5001
     jj=[jj;find(temp(:,7)<1)];
     jj=[jj;find(temp(:,1)<16)];
     
case 5002
    jj=[jj;find(temp(:,4)<5)];
    jj=[jj;find(temp(:,9)<7)];
    jj=[jj;find(temp(:,13)<5)];
    jj=[jj;find(temp(:,1)<22)];
    jj=[jj;find(temp(:,3)<12)];
    
case 5003
    jj=[jj;find(temp(:,2)<1)];
    jj=[jj;find(temp(:,6)<2.5)];
    jj=[jj;find(temp(:,14)<4)];
    jj=[jj;find(temp(:,15)<3)];
    jj=[jj;find(temp(:,4)<9)];
    jj=[jj;find(temp(:,3)<6)];
  
case 5014
    jj=[jj;find(temp(:,4)<5)];

      
case 5015
    jj=[jj;find(temp(:,6)<-.5)];
    

case 5504
    jj=[jj;find(temp(:,1)>15)];
    jj=[jj;find(temp(:,2)<1)];
    
case 5008
    jj=[jj;find(temp(:,5)<4.5)];
    jj=[jj;find(temp(:,1)<14)];
    jj=[jj;find(temp(:,3)<12)];
    jj=[jj;find(temp(:,4)<9)];
    
case 5010
    jj=[jj;find(temp(:,1)<15)];

case 5014
    jj=[jj;find(temp(:,7)<9)];
    jj=[jj;find(temp(:,1)<15)];
    
case 5016
    jj=[jj;find(temp(:,1)<17)];

   
    
case 5015    
    jj=[jj;find(temp(:,1)<11)];
    
case  5103  
    jj=[jj;find(temp(:,4)<9)];
    jj=[jj;find(temp(:,5)<9.5)];
    jj=[jj;find(temp(:,9)<9.5)];
    jj=[jj;find(temp(:,10)<11.5)];
      
case 5108
    jj=[jj;find(temp(:,1)<12)];
    jj=[jj;find(temp(:,4)<9.5)];
    jj=[jj;find(temp(:,1)<4.4)];
    
case 5109
    jj=[jj;find(temp(:,11)>25)];
    jj=[jj;find(temp(:,1)<12)];
    jj=[jj;find(temp(:,1)<3)];
    
case 5113
    jj=[jj;find(temp(:,4)<12)];

case 5115
     jj=[jj;find(temp(:,1)<4)];
  
case 5116    
    jj=[jj;find(temp(:,5)<-2)];

     
case 5117
    jj=[jj;find(temp(:,1)<19)];
    jj=[jj;find(temp(:,3)<12)];
    jj=[jj;find(temp(:,3)<13)];
    
case 5202
    jj=[jj;find(temp(:,5)<7)];
    
case 5208
    jj=[jj;find(temp(:,8)<8.5)];
    jj=[jj;find(temp(:,31)<5.8)];

case 5209    
    jj=[jj;find(temp(:,1)<7)];
    
case 5211
    jj=[jj;find(temp(:,3)<10.5)];

case 5215
     jj=[jj;find(temp(:,1)<7)];
     
case 5216
    jj=[jj;find(temp(:,5)<5.5)];
        
case 5217
     jj=[jj;find(temp(:,7)<5)];
    
case 5308
     jj=[jj;find(temp(:,42)<3)];
     
case 5314
    jj=[jj;find(temp(:,1)<5.5)];
    
case 5315    
    jj=[jj;find(temp(:,2)>31.5)];
    
case 5600
    jj=[jj;find(temp(:,3)<-2.4)];
    
case 7002 
    jj=[jj;find(temp(:,3)<.4)];
    jj=[jj;find(temp(:,5)<9.5)];
    jj=[jj;find(temp(:,2)<3)];
    jj=[jj;find(temp(:,7)<6)];
    jj=[jj;find(temp(:,11)<6)];
    
case 7003
    jj=[jj;find(temp(:,1)<1)];
          
    
case 7005
    jj=[jj;find(temp(:,1)<10)];

case 7008
    jj=[jj;find(temp(:,3)<10.5)];
    jj=[jj;find(temp(:,6)<4)];
   
case 7009
     jj=[jj;find(temp(:,1)<11)];

case 7017
     jj=[jj;find(temp(:,16)>34)];
     
case 7101
    jj=[jj;find(temp(:,76)>13)];
    
case 7104
    jj=[jj;find(temp(:,11)<8.5)];
    jj=[jj;find(temp(:,12)>30)];
    jj=[jj;find(temp(:,3)<11)];
    
case 7105
    jj=[jj;find(temp(:,8)<9)];
    jj=[jj;find(temp(:,2)<22)];
    jj=[jj;find(temp(:,5)<6)];
    jj=[jj;find(temp(:,9)>31)];
    jj=[jj;find(temp(:,1)<7.5)];
    jj=[jj;find(temp(:,8)<2.5)];

case 7108    
     jj=[jj;find(temp(:,1)<12)];
 
case 7114
     jj=[jj;find(temp(:,1)<9)];

case 7115
     jj=[jj;find(temp(:,1)<9)];

case 7201
    jj=[jj;find(temp(:,9)<9)];
    jj=[jj;find(temp(:,3)<13)];
     
     
case 7202
    jj=[jj;find(temp(:,6)<4)];
    jj=[jj;find(temp(:,1)<12)];
    jj=[jj;find(temp(:,10)<3)];
 
    
case 7203
    jj=[jj;find(temp(:,6)<15)];

case 7204
    jj=[jj;find(temp(:,8)>34)];
    
case 7212    
    jj=[jj;find(temp(:,1)<5)];
    
case 7213
    jj=[jj;find(temp(:,1)<13)];

case 7215 
    
    jj=[jj;find(temp(:,10)>31)]; 

case 7217    
    jj=[jj;find(temp(:,5)<12)];
    
case 7302
    jj=[jj;find(temp(:,1)<5.5)];
    jj=[jj;find(temp(:,5)<5)];
    jj=[jj;find(temp(:,1)<11)];

case 7304 
    jj=[jj;find(temp(:,3)<6)];
    jj=[jj;find(temp(:,4)<2)];
  
case 7313
    jj=[jj;find(temp(:,2)<4)];
    jj=[jj;find(temp(:,10)<1)];
    jj=[jj;find(temp(:,27)<3)];
    
case 7317
    jj=[jj;find(temp(:,1)<2)];
    
case 7402
    jj=[jj;find(temp(:,6)<6.4)];
    
case 7413    
    jj=[jj;find(temp(:,12)>22)];
    jj=[jj;find(temp(:,1)<5)]; 
     jj=[jj;find(temp(:,2)<4)];
    
case 7414   
    jj=[jj;find(temp(:,1)<1)];
    
case 7501
    jj=[jj;find(temp(:,1)<6.1)];
    
case 7502
    jj=[jj;find(temp(:,1)>20)];
    
case 7504
    jj=[jj;find(temp(:,1)>25)];
   
case 7513    
    jj=[jj;find(temp(:,10)<2.6)];
    jj=[jj;find(temp(:,1)<.6)];
  
case 7514    
    jj=[jj;find(temp(:,1)<1)];
    
case 7516
    jj=[jj;find(temp(:,1)>34)];
    
case 7517
    jj=[jj;find(temp(:,10)<2.6)];
    jj=[jj;find(temp(:,1)<.6)];
    jj=[jj;find(temp(:,3)>18)];
  
case 7600
    jj=[jj;find(temp(:,1)>24)]; 
    
case 7605
    jj=[jj;find(temp(:,4)>14)];
    
case 7700
     jj=[jj;find(temp(:,3)>32)];
    
case 7800
     jj=[jj;find(temp(:,30)>10)];

  end

  % transform out the subset of only the good times
  
    jj=good_times(jj);
  
    temp=temp2;
    
    clear ind ind2 tmp tmpp ll

  
  qc2stoss(i)=length(jj);
  
  ii=jj; clear jj
  oldlen(i)=size(temp,1);
  qc2toss(i)=length(ii);

  coords(ii,:)=[];dt(ii,:)=[];mdep(ii)=[];qual(ii)=[];
  temp(ii,:)=[];time(ii,:)=[];npts(ii)=[];exterr(ii)=[];
  typ(ii,:)=[];src(ii,:)=[];bath(ii)=[];isunk(ii)=[];

%  save(d(i).name,'coords','dt','depth','mdep','ndups','nkept', ...
%	'npts','ntot','qual','temp','time','src','typ','bath')
%    save(e(i).name,'coords','dt','depth','mdep','nkept', ...
%  	'npts','qual','temp','time','src','typ','bath','isunk')

 save(e(i).name,'bath','blon','blat','coords','dt','depth','exterr',...
	'mdep','nkept','npts','qual','temp','time','src','typ','isunk')


  disp([num2str([i toc],5),'  ',e(i).name(1:5)]);

end
cd '..'

save qc3num oldlen qc2*toss
  
