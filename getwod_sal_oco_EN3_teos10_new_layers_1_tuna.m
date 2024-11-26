% getwod.m - matlab script to load all WOD temp. data into matlab
% format and save it in matlab format in QC squares.
% 6/2/2
% 12/7/03 - modified to keep profile type and source info. and to
%	    read time-sorted data
% 2/25/2011 MUST RUN load_everything_q1_new first to make
%   file_good_oclnums.mat
% cd /Volumes/ThunderBay/Data/Globalhc/WOD05
warning off all

% d=sdir('*_conv4.mat');
% ds=sdir('*_conv_sal.mat');
% 
% %% toss float data out of WOD05 since we get it from Argo
% dn=strvcat(d(:).name);
% ii=find(dn(:,1)=='A'|dn(:,1)=='P'|dn(:,1)=='a');d(ii)=[];
% 
% %% load XBT correction
% load wod_bias_info tg cor code len
% cor(len<200)=NaN;ii=find(~isnan(nanmean(cor,2)));
% cor=cor(ii,:);len=len(ii,:);code=code(ii,:);
% cor(isnan(cor))=0;
% 

%% load 2004 GK salinity 
%[pres_gk,lat_gk,lon_gk,sal_gk]=read_gk;
% load /Volumes/ThunderBay/Data/GK_clim/GK_abs_sal.mat Asal sal pres lon lat
% % % eval(['load ',path_OHCA_data_out,'GK_clim\GK_abs_sal.mat Asal sal pres lon lat'])
% % % sal_gk=Asal;
% % % lat_gk=lat;
% % % lon(lon<0)=lon(lon<0)+360;
% % % lon_gk=lon;
% % % pres_gk=pres;
% % % lon_gk=[lon_gk(end/2+1:end)-360,lon_gk(1:end/2)];
% % % sal_gk=[sal_gk(end/2+1:end,:,:);sal_gk(1:end/2,:,:)];
% % % 
% % % lon_gk=[lon_gk(end-6:end)-360,lon_gk,lon_gk(1:6)+360];
% % % sal_gk=[sal_gk(end-6:end,:,:);sal_gk;sal_gk(1:6,:,:)];
% % % 
% % % 
% % % [lat_gk_l_all,lon_gk_l_all]=meshgrid(lat_gk,lon_gk);
% % % 
% % % nlat_gk=length(lat_gk);
% % % nlon_gk=length(lon_gk);
% % % npres_gk=length(pres_gk);
% % % 
% % % 
% % % max_depth_gk=nans(nlon_gk,nlat_gk);
% % % for ilon_gk=1:nlon_gk
% % %     for ilat_gk=1:nlat_gk
% % %         
% % %         junk_sal_gk=squeeze(sal_gk(ilon_gk,ilat_gk,:));
% % %        mdep_gk=max(pres_gk(squeeze(isfinite(junk_sal_gk(:)))));
% % %         if ~isempty(mdep_gk)
% % %             max_depth_gk(ilon_gk,ilat_gk)=mdep_gk;
% % %         end 
% % %     end
% % % end

% lat_gk_3=reshape(lat_gk,[1,nlat_gk,1]);S
% lon_gk_3=reshape(lon_gk,[nlon_gk,1,1]);
% pres_gk_3=reshape(pres_gk,[1,1,npres_gk]);
% 
% lat_gk_3=repmat(lat_gk_3,[nlon_gk,1,npres_gk]);
% lon_gk_3=repmat(lon_gk_3,[1,nlat_gk,npres_gk]);
% pres_gk_3=repmat(pres_gk_3,[nlon_gk,nlat_gk,1]);
% 
% 
% F_gk=TriScatteredInterp(lon_gk_3(:),lat_gk_3(:),pres_gk_3(:),sal_gk(:));
% 

%% load WOCE Climatology so we can interpolate Mooring data
% load ../WOCE/wghc lon lat dpt S T
% [yy,~,zz]=meshgrid(lat,lon,dpt);pp=sw_pres(zz,yy);
% T=sw_temp(S,T,pp,pp*0);clear S pp xx yy zz
% lon=[lon(end/2+1:end)-360,lon(1:end/2)];
% T=[T(end/2+1:end,:,:);T(1:end/2,:,:)];
% lon=[lon(end)-360,lon,lon(1)+360];
% T=[T(end,:,:);T;T(1,:,:)];
% ii=find(dpt<=1000);dpt=dpt(ii);T=T(:,:,ii);





%% load good OCLNUMS


%load '/Users/johnlyman/data/Globalhc/HC/All_Data/file_good_oclnums.mat' good_oclnums
n_good_prof=7000000;


 

 for ilayer=2:length(layer_bounds)

     eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod=ones(n_good_prof,1).*NaN;'])
      eval(['sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod=ones(n_good_prof,1).*NaN;'])
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

sal=[];
iprof=1;
js=1;

file_list_EN3=sdir([path_EN4_in,'*.nc']);

nfile=length(file_list_EN3);

%% loop to load in data
%for i=30:30 % main loop over all WOD files
 tic
 
 cd(path_EN4_in)
 
for ifile=1:nfile
%for i=335:335
%for i=287:287
% 
file_list_EN3(ifile)
%   
%   if exist(sal_file,'file');load(sal_file);oclnum_sal=oclnum;end
  % read_EN3_file changes the path to path_EN3!!! it cd path_EN3

  [coords,dt,time,nprof,qual,fflag,ptype,pinfo,oclnum,temp]=read_EN3_file_1_sal(ifile,path_EN4_in);
  
 
  %if i==61, js=26878; end;

  
  
  npmax=length(time);
 if npmax>0
  
      % only take the good OCLNUM
      %good_pos=find(ismember(oclnum,good_oclnums));
      good_pos=[1:length(time)];
      
      
      if ~isempty(good_pos)
           temp=temp(good_pos);
           coords=coords(good_pos,:);
           dt=dt(good_pos,:);
           oclnum=oclnum(good_pos);
           pinfo=pinfo(good_pos,:);
           fflag=fflag(good_pos);
           ptype=ptype(good_pos);
           qual=qual(good_pos);
           time=time(good_pos);
           npmax=length(good_pos);
            
           % compute WOD number
           
           wnum=nans(length(good_pos),1);
            
           iii=find(coords(:,1)<=0&coords(:,2)>0);
           jjj=find(coords(:,1)>0 &coords(:,2)>0);
           lll=find(coords(:,1)<=0&coords(:,2)<=0);
           nnn=find(coords(:,1)>0 &coords(:,2)<=0);
           wnum(iii)=abs(ceil(coords(iii,1)/10))+100*(ceil(coords(iii,2)/10)-1)+7000;
           wnum(jjj)=ceil(coords(jjj,1)/10)-1+100*(ceil(coords(jjj,2)/10)-1)+1000;
           wnum(lll)=abs(ceil(coords(lll,1)/10))+100*abs(ceil(coords(lll,2)/10))+5000;
           wnum(nnn)=ceil(coords(nnn,1)/10)-1+100*abs(ceil(coords(nnn,2)/10))+3000;
           nprof=length(time);
           
           
          for j=js:nprof
                if ~isempty(temp{j})
                % find appropiate depth correction factor
                mdp=max(temp{j}(:,1));
                pt=0;xcor=0;

%                 if     ptype(j)==2&&mdp>300&&mdp<430,pt=2.1;
%                     elseif ptype(j)==2&&mdp>=430&&mdp<480;pt=2.2;
%                     elseif ptype(j)==2&&mdp>=480&&mdp<950;pt=2.3;
%                     elseif ptype(j)==2&&mdp>=950&&mdp<2000;pt=2.4;
%                 else
%                     pt=ptype(j);
%                 end
% 
%                 if pinfo(j,1)==2&&(mdp>=2000||mdp<=300),pt=0;end
% 
%                 ii=find(pt==code(:,1)&fflag(j)==code(:,2));
%                 jj=find(dt(j,1)==tg-.5);
% 
%                 if ~isempty(ii)&&~isempty(jj), xcor=cor(ii,jj);end   
% 
%                 % pick out good data points, sort and interpolate
                ii=find( (temp{j}(:,4)==0|temp{j}(:,4)==2) ...
                & temp{j}(:,3)~=1 & temp{j}(:,2)<35 &  ...
                    temp{j}(:,2)>=-3 & ...
                ~isnan(temp{j}(:,1)+temp{j}(:,2)) );

                [poo,ll]=unique(temp{j}(ii,1));ii=ii(ll);
                clear ll poo



                max_depth_junk=max(temp{j}(ii,1));


           if length(ii)>2&&max_depth_junk>=100&&~isnan(xcor)&&coords(j,2)>=-80
                   
                     % correct XBT fall rate with Josh's old correction
                         data=cell(1,3);
                         press_junk=double(sw_pres(temp{j}(ii,1)*(1+xcor),coords(j,2)));
                         temp_junk=temp{j}(ii,2);
                         sal_junk=temp{j}(ii,3);

                         
                         % compute Salinity for GK 2004 where it is missing
                         
                         % find the coresponding salinity profile 
%                         j_sal=find(ismember(oclnum_sal,oclnum(j)));
                         
%                          if ~isempty(j_sal)  
%                              sal_junk=sal{j_sal}(ii,2);
%                             % set missing points 
%                             ii_sal=find( ~((sal{j_sal}(ii,4)==0|sal{j_sal}(ii,4)==2) ...
%                                 & ~isnan(sal{j_sal}(ii,1)+sal{j_sal}(ii,2)) ));
%                              sal_junk(ii_sal)=NaN;
%                             
%                          end
                         
                         
                         %if ~isfinite(sum(sal_junk))
                           % 
                           
                           
                          
                           
% % %                            good_lat_junk=find((lat_gk>=coords(j,2)-2) & (lat_gk<=coords(j,2)+2));
% % %                            
% % %                            
% % %                            
% % %                            good_lon_junk=find((lon_gk>=coords(j,1)-2) & (lon_gk<=coords(j,1)+2));
% % %                            
% % %                            
% % %                            if (~isempty(good_lon_junk) && ~isempty(good_lat_junk))
% % %                                 njunk=length(press_junk);
% % %                                 sal_junk=squeeze(interp3(lat_gk(good_lat_junk),lon_gk(good_lon_junk),pres_gk,sal_gk(good_lon_junk,good_lat_junk,:),repmat(coords(j,2),njunk,1),repmat(coords(j,1),njunk,1),press_junk));
% % %                            else
% % %                                 sal_junk=NaN;
% % %                            end
                         %  sal_junk=squeeze(interp3(lat_gk,lon_gk,pres_gk,sal_gk,coords(j,2),coords(j,1),press_junk));
                           
                           
                           
%                             npress_junk=length(press_junk);
%                             lat_press_junk=coords(j,2).*ones(1,npress_junk);
%                             lon_press_junk=coords(j,1).*ones(1,npress_junk);
%                             sal_junk=F_gk(lon_press_junk(:),lat_press_junk(:),press_junk(:));
                            
% %          if ~isfinite(sum(sal_junk))&& ~isempty(good_lon_junk) && ~isempty(good_lat_junk)
% %                                 % if near edge find nearest grid point that
% %                                 % goes the deepest
% %                         
% %                                lat_gk_l=lat_gk_l_all(good_lon_junk,good_lat_junk);
% %                                lon_gk_l=lon_gk_l_all(good_lon_junk,good_lat_junk);
% %                                sal_gk_l=sal_gk(good_lon_junk,good_lat_junk,:);
% %                                max_depth_gk_l=max_depth_gk(good_lon_junk,good_lat_junk);
% %                                 dist=sqrt((coords(j,2)-lat_gk_l).^2+(coords(j,1)-lon_gk_l).^2);
% %                                %% 
% %                                 
% %                                     dist(max_depth_gk_l< layer_bounds(2))=NaN;
% %             dist(~isfinite(max_depth_gk_l))=NaN;
% %             % find the deepest depth that is deeper than the showest layer
% %               % find the deepest depth that is deeper than the showest layer
% %             a=find(max_depth_gk_l>=max(press_junk(isfinite(press_junk))));
% %             
% %             if isempty(a)
% %                 
% %                 a=find(max_depth_gk_l>=max(max_depth_gk_l(:)));
% %                 
% %             end
% %             % find the closest of the deepest
% %             [~,b]=min(dist(a));
% %             pos_close=a(b);
% %             
% %             % if there are no 
% %             if length(find(isfinite(dist)==1))==1
% %                 pos_close=[];
% %             end
% %             
% %              if ~isempty(pos_close)
% %             lat_junk=lat_gk_l(pos_close);
% %             lon_junk=lon_gk_l(pos_close);
% %             good_lon_pos= lon_gk(good_lon_junk)==lon_junk;
% %             good_lat_pos= lat_gk(good_lat_junk)==lat_junk;
% %             sal_junk2=squeeze(sal_gk_l(good_lon_pos,good_lat_pos,:));
% %             sal_junk2(~isfinite(sal_junk2))=sal_junk2( find(isfinite(sal_junk2), 1, 'last' ));
% %             sal_junk=squeeze(interp1(pres_gk,sal_junk2,press_junk));
% %             sal_junk2=[];
% %             else
% %                 %% if missing set salininty to 35
% %                 sal_junk=ones(length(press_junk),1).*35.0;
% %             end
% %             
% %            
% %         end

                                
% %                           if isfinite(nansum(sal_junk))
                         
                              
                              
                         good_pos=find(isfinite(temp_junk) & isfinite(sal_junk) & isfinite(press_junk));
                         
                         data{1,1}=temp_junk(good_pos);
                         data{1,2}=sal_junk(good_pos);
                         data{1,3}=press_junk(good_pos);
                         
                         max_depth_junk=max(press_junk(good_pos));
                       
                         
                        for ilayer=2:length(layer_bounds)
                             
                             eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=NaN;'])
%                              eval(['temp_0_',num2str(layer_bounds(ilayer)),'=NaN;'])
                             eval(['temp_junk=temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),';'])
%                              eval(['temp_junk2=temp_0_',num2str(layer_bounds(ilayer)),';'])

                              eval(['sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=NaN;'])
%                              eval(['sal_0_',num2str(layer_bounds(ilayer)),'=NaN;'])
                             eval(['sal_junk=sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),';'])
%                              eval(['sal_junk2=sal_0_',num2str(layer_bounds(ilayer)),';'])
                             if max_depth_junk >= layer_bounds(ilayer)
                                 
                                [sal_junk,temp_junk]=compute_depth_sal_depth_range_teos10_2016_tuna(data,sal_junk,temp_junk,coords(j,:),layer_bounds(ilayer-1),layer_bounds(ilayer));
%                                 [sal_junk2,temp_junk2]=compute_depth_sal_depth_range_teos10_2016_tuna(data,sal_junk2,temp_junk2,coords(j,:),0,layer_bounds(ilayer));
                                
                            
                             end
                              eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=temp_junk;'])
%                               eval(['temp_0_',num2str(layer_bounds(ilayer)),'=temp_junk2;'])
                              eval(['sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=sal_junk;'])
%                               eval(['sal_0_',num2str(layer_bounds(ilayer)),'=sal_junk2;'])
                         end
                             
                      
                         
                         
% %                           end
                          
                          if_statement_name=[];

                        for ilayer=2:length(layer_bounds)

                            if ilayer~=length(layer_bounds)
                                
                                if_statement_name=[if_statement_name,'isfinite(sal_',num2str(layer_bounds(ilayer-1)),...
                                '_',num2str(layer_bounds(ilayer)),') || '];
                            else
                                if_statement_name=[if_statement_name,'isfinite(sal_',num2str(layer_bounds(ilayer-1)),...
                                '_',num2str(layer_bounds(ilayer)),')'];
                            end
                            

                        end
                       

                          
                        eval(['there_is_a_good_layer=',if_statement_name,';'])
                        if there_is_a_good_layer
%                         if isfinite(temp_0_40) || isfinite(temp_40_90) || isfinite(temp_90_190) || ...
%                                 isfinite(temp_190_290) || isfinite(temp_290_450) || isfinite(temp_450_700) || isfinite(temp_700_950) || ...
%                                 isfinite(temp_950_1450) || isfinite(temp_1450_1950) ||  isfinite(temp_1950_2000) 
                           
                        mdep_wod(iprof)=max_depth_junk;
                        
                        
                        
                         for ilayer=2:length(layer_bounds)

                             eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod(iprof)=',...
                                 'temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),';'])
                             eval(['sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod(iprof)=',...
                                 'sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),';'])
                         end

                      
                       
%                         height_100_wod(iprof)=height_100;
%                         height_100_300_wod(iprof)=height_100_300;
%                         height_300_wod(iprof)=height_300;
%                         height_300_700_wod(iprof)=height_300_700;
%                         height_700_wod(iprof)=height_700;
%                         height_900_wod(iprof)=height_900;
%                         height_1800_wod(iprof)=height_1800;
                        
                        dt_wod(iprof,:)=dt(j,:);
                        oclnum_wod(iprof)=oclnum(j);
                        pinfo_wod(iprof,:)=pinfo(j,:);
                        fflag_wod(iprof)=fflag(j);
                        ptype_wod(iprof)=ptype(j);
                        qual_wod(iprof)=qual(j);
                        time_wod(iprof)=time(j);
                        coords_wod(iprof,:)=coords(j,:);
                        wnum_wod(iprof)=wnum(j);
                     
                        iprof=iprof+1;
                        if mod(iprof,1000)==0 ,disp(num2str([iprof,toc./60,j,nprof])), end
                        end
             %   end

          end        
                end
          end
            js=1;
         
          end
          
 end
      sal=[];
      toc./60
 end
  
%%

% remove profile with missing coords

missing=find(~isfinite(coords_wod(:,2)));

mdep_wod(missing )=[];



for ilayer=2:length(layer_bounds)

     eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod(missing)=[];'])
      eval(['sal_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'_wod(missing)=[];'])
 end

%                         height_100_wod(missing )=[];
%                         height_300_wod(missing )=[];
%                         height_100_300_wod(missing )=[];
%                         height_300_700_wod(missing )=[];
%                         height_700_wod(missing )=[];
%                         height_900_wod(missing )=[];
%           
%                         height_1800_wod(missing )=[];
                        
                        dt_wod(missing ,:)=[];
                        oclnum_wod(missing )=[];
                        pinfo_wod(missing ,:)=[];
                        fflag_wod(missing )=[];
                        ptype_wod(missing )=[];
                        qual_wod(missing )=[];
                        time_wod(missing )=[];
                        coords_wod(missing,:)=[];
                        wnum_wod(missing )=[];

eval(['save ',path_EN4_out,'allsal_wod_new_layers_all_conv4',file_name,file_EN3_type,' mdep_wod ',...
    temp_wod_var_name,sal_wod_var_name,...
    'dt_wod oclnum_wod pinfo_wod ',... 
    'fflag_wod ptype_wod qual_wod time_wod coords_wod wnum_wod'])
% 
% 
% eval(['save allheight_wod_100_300_700_900_1800_march_23_2011_all_conv4',file_EN3_type,' mdep_wod '...
%     'height_100_300_wod height_300_700_wod height_100_wod height_300_wod height_700_wod height_900_wod height_1800_wod dt_wod oclnum_wod pinfo_wod ',... 
%     'fflag_wod ptype_wod qual_wod time_wod coords_wod wnum_wod'])
% 

