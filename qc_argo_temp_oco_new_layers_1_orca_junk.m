

% % file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
% % file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
% % file_name='pfloat_sal_greg_june_2008'




% load([file_path_out,file_name,'_new_layers_temp_oco_100'],...
%     temp_var_name,'coords', 'date','mdep', 'npts','time','fptot', ...
%     'fpkeep','bdt', 'bbas','ind','id','qual','press_mis_flag', ...
%     'dac_centre', 'wmo_inst', 'cycle')

tic
nd=length(dac_centre);
lon=coords(:,1);
lat=coords(:,2);
Re=6371.;
lat2km=Re.*pi/180.;
del_deg=3;
nqual=3;
nlayer=length(layer_bounds);
nlayer_loop=nlayer-1;
% temp_total=cell(1,nlayer-1);
temp_total=nan(nd,nlayer-1);
for ilayer=2:length(layer_bounds)

%              temp_total{ilayer-1}=eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]);
             temp_total(:,ilayer-1)=eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]);
end

% for ilayer=2:length(layer_bounds)
% 
%      eval(['bad_temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=[];'])
% end
 bad_temp_total=zeros(nd,nlayer-1);
 

parfor iprof_ch=1:nd
%          for ilayer=2:length(layer_bounds)
% 
%              eval(['ind_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=[];'])
%          end
       ind_junk=[];
        %find the float casts with in del_deg 
        
        
        isquare=iprof_ch;        
        lon_square=lon(iprof_ch);
        lat_square=lat(iprof_ch);
        
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
         
       

%         for ilayer=2:length(layer_bounds)
% 
%              eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_near=',...
%                  'temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'(good_place_floats);'])
%         end
%   
        
     
     
    
    %only look at temp contents with more than 2 good points
    
    
    
      for iplayer=1:nlayer_loop

          ilayer=iplayer+1;
          % Set temp_junk_name and bad_temp_junk to the layer of interest
%              temp_junk_name=eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_near']);
%              bad_temp_junk=eval(['bad_temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]);
             temp_junk_name=temp_total(:,ilayer-1);
             temp_junk_name=temp_junk_name(good_place_floats);
    
   
    
          if (length(find(isfinite(temp_junk_name) ==1 )) >=2 )



                %find the bad places using all the data
                [ind_junk]=ind_out_qua(temp_junk_name,nqual);

           end % if
           
           % determine if this cast is bad
            if   ~isempty(this_cast) && ~isempty(ind_junk)

                if ~isempty(find(ind_junk == this_cast, 1)) 
%                     bad_temp_junk=[bad_temp_junk',iprof_ch]';
                    bad_temp_total(iprof_ch,iplayer)=iprof_ch;
                    per_done=100.*iprof_ch/nd
%                     ['per_bad_temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer),...
%                     num2str(100.*length(bad_temp_junk)/iprof_ch)]
                    
                end
            end 
           
            
            % set ind_ and bad_temp_ for each layer to the value caluclated
            % above
            
%            eval(['ind_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),...
%                  '=ind_junk;'])
%            eval(['bad_temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),...
%                  '=bad_temp_junk;'])
    
%            ind_junk=[];
           
           
      end
       
      
   
       
      
%     eval(['clear ind_junk ',ind_var_name])
   
end  

for ilayer=2:nlayer
    bad_temp_junk=bad_temp_total(:,ilayer-1);
    bad_temp_junk=bad_temp_junk(bad_temp_junk~=0);
    eval(['bad_temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),...
                 '=bad_temp_junk;'])
end
toc./60

% eval(['save ',file_path_out,file_name,'_bad_oco_100_new_layers_temp.mat ',bad_temp_var_name])


