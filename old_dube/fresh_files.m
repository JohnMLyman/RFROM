% This code computes the quantity of fresh water in a given year and saves
% it in files based on year.

% the maxium depth of the profiles
max_depth=1000.
d=sdir(['grad_den_0_grid_aden_den_no_*.mat']);
 d=sdir(['wod_den_*.mat']);

% load Levitus high-res climatology so we can subtract it (mean?)
load /home/shoko2/wills/globalhc_dirs/Globalhc/Levitus/slevhr lon lat dep levsal
levsal=[levsal(end-40:end,:,:);levsal;levsal(1:41,:,:)];
lon=[-190.125:.25:190.125];
levsal(:,end+1,:)=levsal(:,end,:);lat(end+1)=lat(end)+mean(diff(lat));


% these are the fields that will be saved in the fresh water file

time_fresh=[];coords_fresh=[];dt_fresh=[];fresh_water_fresh=[];

for i=1:length(d)
    i
    d(i).name
   file_name=d(i).name
     wmo_number=str2num(file_name(21:24));
    
    if (exist([d(i).name]) & exist(['ind_grad_den_0_grid_aden_den_no_f',num2str(wmo_number),'.mat']))
        
    eval(['load ',d(i).name]);
    eval(['load ind_grad_den_0_grid_aden_den_no_f',num2str(wmo_number),'.mat'])
   
            % subsect the good files.
            coords(bad_total,:)=[];
            mdep(bad_total)=[];
            sal(bad_total,:)=[];
            temp(bad_total,:)=[];
            fpress(bad_total,:)=[];
            time(bad_total)=[];
            dt(bad_total,:)=[];
            
            %get rid of the profiles lessthan max_depth
            
            shallow=find(abs(mdep) < max_depth);
            
            coords(shallow,:)=[];
            mdep(shallow)=[];
            sal(shallow,:)=[];
            temp(shallow,:)=[];
            fpress(shallow,:)=[];
            time(shallow)=[];
            dt(shallow,:)=[];
            
            if length(mdep) >=1 

                % compute the depth [this is an ad hoc method but it is widely accepted
                %                   and is not a function of time (ie changing salinity
                %                   and temp so that the only variation is the change
                %                   in Salinity)]

                depth=sw_dpth(fpress',coords(:,2)')';


              % interpolate salinity climatology onto temp profiles
              ii=find(lon<max(coords(:,1))+.3&lon>min(coords(:,1)-.3));
              jj=find(lat<max(coords(:,2))+.3&lat>min(coords(:,2)-.3));
              mean_sal=zeros(size(temp,1),length(dep));

              for l=1:length(dep)
                    mean_sal(:,l)=interp2(lon(ii),lat(jj),levsal(ii,jj,l)',...
                    coords(:,1),coords(:,2));
              end %if

              nprof=length(mdep);
              fresh_water=ones(nprof,1)*NaN;



              for iprof=1:nprof

                junk_depth=depth(iprof,:);
                junk_sal=sal(iprof,:);
                junk_temp=temp(iprof,:);

                junk_mean_sal=interp1(dep,mean_sal(iprof,:)',junk_depth','pchp')';


                [junk_fresh_water]=fresh_water_input(junk_temp,junk_sal,junk_depth,junk_mean_sal,max_depth);

                fresh_water(iprof)=junk_fresh_water;

                clear junk_temp junk_sal junk_depth junk_mean_sal junk_fresh_water
              end %for

          % add the freshwater from the square to our estimate


        time_fresh=[time_fresh',time']';
        coords_fresh=[coords_fresh',coords']';
        dt_fresh=[dt_fresh',dt']';
        fresh_water_fresh=[fresh_water_fresh',fresh_water']'; 

        clear fresh_water coords mdep sal temp time fpress dt bad_total shallow
        end %if
        
    end %if

end %for




save allfresh time_fresh coords_fresh dt_fresh fresh_water_fresh

clear

nc_idl_freshwater
