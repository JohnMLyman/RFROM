

% % file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
% % file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
% % file_name='pfloat_sal_greg_june_2008'




eval(['load ',file_path_out,file_name,'_new_layers_sal_oco_100  ',...
     sal_var_name,...
    ' coords date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])


nd=length(dac_centre);
lon=coords(:,1);
lat=coords(:,2);
Re=6371.;
lat2km=Re.*pi/180.;
del_deg=3;
nqual=3;


for ilayer=2:length(layer_bounds)

     eval(['bad_sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=[];'])
end
 

for i=1:nd
         for ilayer=2:length(layer_bounds)

             eval(['ind_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=[];'])
         end
       ind_junk=[];
        %find the float casts with in del_deg 
        
        
        isquare=i;        
        lon_square=lon(i);
        lat_square=lat(i);
        
        lon2km=lat2km.*cos(lat_square.*pi/180.);
        
        
        junk_lon=lon;
        switch 1
            case lon_square>90   
                bad_lon=find(junk_lon <0);
                junk_lon(bad_lon)=junk_lon(bad_lon)+360; 
            case lon_square< -90
                bad_lon=find(junk_lon >0);
                junk_lon(bad_lon)=junk_lon(bad_lon)-360;
        end
        
        dist=sqrt((lon2km.*(junk_lon-lon_square)).^2+(lat2km.*(lat-lat_square)).^2);
        good_place_floats=find(dist <= (del_deg.*lat2km));
            
        
        %%%%%%%
        
        
        
        this_cast=find(good_place_floats == isquare);
         
      

        for ilayer=2:length(layer_bounds)

             eval(['sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_near=',...
                 'sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'(good_place_floats);'])
        end
  
        
     
     
    
    %only look at temp contents with more than 2 good points
    
    
    
      for ilayer=2:length(layer_bounds)

          
          % Set sal_junk_name and bad_sal_junk to the layer of interest
             eval(['sal_junk_name=',...
                 'sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_near;'])
             eval(['bad_sal_junk=',...
                 'bad_sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),';'])
    
   
    
          if (length(find(isfinite(sal_junk_name) ==1 )) >=2 )



                %find the bad places using all the data
                [ind_junk]=ind_out_qua(sal_junk_name,nqual);

           end % if
           
           % determine if this cast is bad
            if   ~isempty(this_cast) && ~isempty(ind_junk)

                if ~isempty(find(ind_junk == this_cast, 1)) 
                    bad_sal_junk=[bad_sal_junk',i]';
                    per_done=100.*i/nd
                    eval(['per_bad_sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),...
                    '=100.*length(bad_sal_junk)/i'])
                    
                end
            end 
           
            
            % set ind_ and bad_sal_ for each layer to the value caluclated
            % above
            
           eval(['ind_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),...
                 '=ind_junk;'])
           eval(['bad_sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),...
                 '=bad_sal_junk;'])
    
           ind_junk=[];
           
           
      end
       
      
   
       
      
    eval(['clear ind_junk ',ind_var_name])
   
 end  

eval(['save ',file_path_out,file_name,'_bad_oco_100_new_layers_sal.mat ',bad_sal_var_name])


