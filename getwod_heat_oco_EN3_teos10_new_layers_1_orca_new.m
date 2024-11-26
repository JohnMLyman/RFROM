function getwod_heat_oco_EN3_teos10_new_layers_1_orca_new(OcoSetUp)

%%

path_OHCA_data_out=OcoSetUp.path_OHCA_data_out;
file_name=OcoSetUp.file_name;

path_EN4_in=OcoSetUp.path_EN4_in;
path_EN4_out=OcoSetUp.path_EN4_out;

layer_bounds=OcoSetUp.layer_bounds;

file_EN3_type=OcoSetUp.file_EN3_type;

heat_wod_var_name=OcoSetUp.heat_wod_var_name;

%%


warning off all





file_list_EN3=sdir([path_EN4_in,'*.nc']);

nfile=length(file_list_EN3);


%% loop to load in data
%for i=30:30 % main loop over all WOD files
 tic
 
 cd(path_EN4_in)


heat_all=cell(nfile,1);
dt_all=cell(nfile,1);
pinfo_all=cell(nfile,1);
fflag_all=cell(nfile,1);
ptype_all=cell(nfile,1);
qual_all=cell(nfile,1);
time_all=cell(nfile,1);
coords_all=cell(nfile,1);
oclnum_all=cell(nfile,1);
mdep_all=cell(nfile,1);
wnum_all=cell(nfile,1);

np=zeros(nfile,1);
 
% for ifile=1:nfile
for ifile=1:nfile
    tic
    file_list_EN3(ifile)
    
    
    [coords,dt,time,nprof,qual,fflag,ptype,pinfo,oclnum,mdep,wnum,data]=read_EN3_file_1_new_orca(ifile,path_EN4_in);
    
    
    
        [data]=find_woce_abssal_new_layers_1_orca(data,coords,layer_bounds,path_OHCA_data_out);
    
    %  copute heat conetn for the LAYERS !!
   
    n_player=length(layer_bounds)-1;
    
    heat_junk_total=nan(nprof,n_player);
    %%
    ngroup_layer=4;
    if n_player>= 20
        n_sublayer=ceil(n_player./ngroup_layer);
        start_sublayer=1:n_sublayer:n_player;
        end_sublayer=n_sublayer+1:n_sublayer:n_player;
        if end_sublayer(end)~= n_player
            end_sublayer(end+1)=n_player;
        end
    else
        start_sublayer=1;
        end_sublayer=n_player;
        ngroup_layer=1;
    end

    for isublayer=1:ngroup_layer
        
        parfor player=start_sublayer(isublayer):end_sublayer(isublayer)  %change to parfor
           
            heat_junk=nan(nprof,1);
            
            [heat_junk]=compute_depth_heat_depth_range_teos10_2016(data,heat_junk,coords,layer_bounds(player),layer_bounds(player+1));

           heat_junk_total(:,player)=heat_junk;
        end
    end
    heat_all{ifile}=heat_junk_total;
    dt_all{ifile}=dt;
    pinfo_all{ifile}=pinfo;
    fflag_all{ifile}=fflag;
    ptype_all{ifile}=ptype;
    qual_all{ifile}=qual;
    time_all{ifile}=time;
    coords_all{ifile}=coords;
    wnum_all{ifile}=wnum;
    mdep_all{ifile}=mdep;
    oclnum_all{ifile}=oclnum;
    np(ifile)=length(time);



    toc./60
end                 
         
n_good_prof=sum(np);


 

 for ilayer=2:length(layer_bounds)

     eval(['heat_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod=ones(n_good_prof,1).*NaN;'])
 end

dt_wod=ones(n_good_prof,3).*NaN;
oclnum_wod=ones(n_good_prof,1).*NaN;
pinfo_wod=ones(n_good_prof,2).*NaN;
fflag_wod=ones(n_good_prof,1).*NaN;
ptype_wod=ones(n_good_prof,1).*NaN;
qual_wod=ones(n_good_prof,1).*NaN;
time_wod=ones(n_good_prof,1).*NaN;
coords_wod=ones(n_good_prof,2).*NaN;
mdep_wod=ones(n_good_prof,1).*NaN;
wnum_wod=ones(n_good_prof,1).*NaN;
% 
% save -v7.3 'junk_file' heat_all coords_all dt_all time_all wnum_all mdep_all ...
%     qual_all ptype_all np oclnum_all pinfo_all nfile fflag_all layer_bounds
    
sprof=1;
endprof=np(1);
 for ifile=1:nfile

    
    dt_wod(sprof:endprof,:)=dt_all{ifile};
    oclnum_wod(sprof:endprof,:)=oclnum_all{ifile};
    pinfo_wod(sprof:endprof,:)=pinfo_all{ifile};
    fflag_wod(sprof:endprof,:)=fflag_all{ifile};
    ptype_wod(sprof:endprof,:)=ptype_all{ifile};
    qual_wod(sprof:endprof,:)=qual_all{ifile};
    time_wod(sprof:endprof,:)=time_all{ifile};
    coords_wod(sprof:endprof,:)=coords_all{ifile};
    mdep_wod(sprof:endprof,:)=mdep_all{ifile};
    wnum_wod=wnum_all{ifile};
    
                        
                        
                         for ilayer=2:length(layer_bounds)
                             junk_heat=heat_all{ifile}(:,ilayer-1);

                             eval(['heat_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod(sprof:endprof)=',...
                                 'junk_heat;'])
                         end
                        if ifile~=nfile
                         sprof=endprof+1;
                         endprof=sprof+np(ifile+1)-1;
                        end


end
%                       
%            
%                         dt_wod(iprof,:)=dt(j,:);
%                         oclnum_wod(iprof)=oclnum(j);
%                         pinfo_wod(iprof,:)=pinfo(j,:);
%                         fflag_wod(iprof)=fflag(j);
%                         ptype_wod(iprof)=ptype(j);
%                         qual_wod(iprof)=qual(j);
%                         time_wod(iprof)=time(j);
%                         coords_wod(iprof,:)=coords(j,:);
%                         wnum_wod(iprof)=wnum(j);
%                      
%                         iprof=iprof+1;
%                         if mod(iprof,1000)==0 ,disp(num2str([iprof,toc./60,j,nprof])), end
%                         end
%  
%   
% %%

% remove profile with missing coords
% 
% missing=find(~isfinite(coords_wod(:,2)));
% 
% mdep_wod(missing )=[];


% 
% for ilayer=2:length(layer_bounds)
% 
%      eval(['heat_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod(missing)=[];'])
% end

%                         height_100_wod(missing )=[];
%                         height_300_wod(missing )=[];
%                         height_100_300_wod(missing )=[];
%                         height_300_700_wod(missing )=[];
%                         height_700_wod(missing )=[];
%                         height_900_wod(missing )=[];
%           
%                         height_1800_wod(missing )=[];
                        
                   

eval(['save ',path_EN4_out,'allheat_wod_new_layers_all_conv4',file_name,file_EN3_type,' mdep_wod ',...
    heat_wod_var_name,...
    'dt_wod oclnum_wod pinfo_wod ',... 
    'fflag_wod ptype_wod qual_wod time_wod coords_wod wnum_wod'])
% 
% 
% eval(['save allheight_wod_100_300_700_900_1800_march_23_2011_all_conv4',file_EN3_type,' mdep_wod '...
%     'height_100_300_wod height_300_700_wod height_100_wod height_300_wod height_700_wod height_900_wod height_1800_wod dt_wod oclnum_wod pinfo_wod ',... 
%     'fflag_wod ptype_wod qual_wod time_wod coords_wod wnum_wod'])
% 

