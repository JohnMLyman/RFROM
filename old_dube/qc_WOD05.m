d=sdir(['/home/shoko2/wills/globalhc_dirs/Globalhc/SAL/WOD05/junk/w*_1000m.mat']);

% this is the radius that is looked at

del_deg=3;


for i=1:length(d)
    
    %eval(['load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/WOD05/',d(i).name])
    
    %this is a liitle part that I think gets rid of an error in the code
    %that worte the matliab files.
    
%     np=length(mdep);
%     np_npts=length(npts);
%     npts=npts(np_npts-np+1:end);
%     
    file_name=d(i).name
    wmo_number=str2num(file_name(2:5));
    
   [coords_tot,dt_tot,mdep_tot,npts_tot,press_0_tot, ... 
       sal_0_tot,temp_0_tot,time_tot,type_tot,wmo_tot,density_surface]= ...
        load_data_wmo_square(wmo_number,del_deg);
    
    % type == 1:OSD(low res CTD XCTD, ect); 2:CTD (High resolution CTD); 3:PFL(profiling floats)
    %   4:UOR(undulating Oceangraphic Recorder); 5:GLD(Glider)
    
    
    good_locations=find(wmo_tot == wmo_number & type_tot ~= 3);
    
    %this section will do the qc based on nearest naighbor
    
    n_good=length(good_locations);
    
    bad=[];
    s=size(sal_0_tot);
    nd=s(2);
    
    for iqc=1:n_good
       
        isquare=good_locations(iqc);
        
        lon_square=coords_tot(isquare,1);
        lat_square=coords_tot(isquare,2);
        
        del_lon=abs(coords_tot(:,1)-lon_square);
        del_lat=abs(coords_tot(:,2)-lat_square);
        
        big_del_lon=find(del_lon >= 360);
        
        if length(big_del_lon) > 0 
            del_lon(big_del_lon)=abs(del_lon(big_del_lon)-360);
        end
        distance=sqrt((del_lon).^2+(del_lat).^2);
 
 
 
        good_place=find(distance <= 3.);
 
        this_cast=find(good_place == isquare);
 

        coords=coords_tot(good_place,:);
        dt=dt_tot(good_place,:);
        
    
    
        press_0=press_0_tot(good_place,:);
        sal_0=sal_0_tot(good_place,:);
        temp_0=temp_0_tot(good_place,:);
    
    
  
 
        

        ii=[];



    for iden=1:nd
            % use nuetral density when it is aviable.

%         if length(find(finite(temp_gam(:,iden))==1)) >= 2
%             den_temp=temp_gam(:,iden);
%             den_sal=sal_gam(:,iden);
%             den_press=press_gam(:,iden);
%             else
            den_temp=temp_0(:,iden);
            den_sal=sal_0(:,iden); 
            den_press=press_0(:,iden);
%         end
    %only look at profiles where the mean pressure is less then 1000 dbar
        if (length(find(finite(den_temp) ==1 )) >=2 & nanmean(den_press) > 500)
             [ind_temp]=ind_out_qua(den_temp,2);
            [ind_sal]=ind_out_qua(den_sal,2);
            [ind_press]=ind_out_qua(den_press,2);
            ii=[ii,ind_sal',ind_temp',ind_press'];

        end 
    end
clear den_sal den_tem den_press
    % get rid of profiles with more than 5% missing


    




    if length(find(ii == this_cast)) > 0
        bad=[bad',iqc]';
        per_done=100.*iqc/n_good
        per_bad=100.*length(bad)/iqc
    end

clear ii
    end %end of WMO sqruare
    
    
    if (n_good <= 1)
        bad_coords=coords_tot(:,1);
        good_locations=[1:1:length(bad_coords)];
        bad=good_locations;
    end
        
    bad_coords=coords_tot(good_locations,1);
    bad_coords(bad)=NaN;
    
    jj=find( finite(bad_coords) == 0); 
 
 
% scrsz = get(0,'ScreenSize');
% 
% h=figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5]);  
% 
% 
% subsect data

%      temp=temp_tot(good_locations,:);
%      sal=sal_tot(good_locations,:);
%      fpress=fpress_tot(good_locations,:);
    coords=coords_tot(good_locations,:);
    dt=dt_tot(good_locations,:);
    time=time_tot(good_locations);
    type=type_tot(good_locations);
    mdep=mdep_tot(good_locations);
    npts=npts_tot(good_locations);
    
    press_0=press_0_tot(good_locations,:);
    sal_0=sal_0_tot(good_locations,:);
    temp_0=temp_0_tot(good_locations,:);
    
  %find the right dates (ie only preform the qc on the times that
  % I cheacked.

% temp_0_all=temp_0;
% sal_0_all=sal_0;
% press_0_all=press_0;
% type_all=type;
% time_all=time;
% mdep_all=mdep;
% npts_all=npts;
% dt_all=dt;
% coords_all=coords;
% 
% time(jj)=[];
% temp_0(jj,:)=[];
% sal_0(jj,:)=[];
% press_0(jj,:)=[];
% type(jj)=[];
% mdep(jj)=[];
% npts(jj)=[];
% dt(jj,:)=[];
% coords(jj,:)=[];







eval(['save ./WOD05/w',num2str(wmo_number),'_wod_1000m.mat temp_0 sal_0 press_0 type', ... 
    ' mdep npts dt coords time density_surface jj'])


   clear temp_0 sal_0 press_0 type mdep npts dt coords time ...
temp_0_tot sal_0_tot press_0_tot type_tot mdep_tot npts_tot dt_tot coords_tot time_tot ...
good_locations good_place 


  
 
end %end of WMO files




