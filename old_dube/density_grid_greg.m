     
close all

cd /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/argo
 d=sdir(['greg_f*.mat']);
 
 density_surface=[18:.02:31];
 n_den=length(density_surface);
 
 
 
for isquare=1:length(d)



eval(['load ',d(isquare).name])

display(d(isquare).name) 

% sorting the data

yd=dt(:,1)+(dt(:,2)-1)/12.+(dt(:,3)-1)/365.;
  
  %find the right dates (ie only preform the qc on the times that
  % I cheacked.
  
  good_times=find(yd >= 2002);
  dt=dt(good_times,:);
  mdep=mdep(good_times);
  coords=coords(good_times,:);
  npts=npts(good_times);
  qual=qual(good_times);
  time=time(good_times,:);
  id=id(good_times);
  pro_data=pro_data(good_times,:);
  wmo_type=wmo_type(good_times);
  press_miss=press_miss(good_times);
 dac=dac(good_times);



nprofiles=length(id);
ratio_bad=[];
good_grad=[];

% sal_gam=single(ones(nprofiles,n_den)*NaN); 
% temp_gam=sal_gam;
% press_gam=sal_gam; 
% press_top_gam=sal_gam(:,1); 
% press_bot_gam=sal_gam(:,1); 
         
 sal_0 =single(ones(nprofiles,n_den)*NaN);
 temp_0=sal_0;
 press_0 =sal_0;
 press_top_0=sal_0(:,1);
 press_bot_0=sal_0(:,1);

for iprof=1:nprofiles


 sal=double(pro_data{iprof,2});
 temp=double(pro_data{iprof,1});
 fpress=double(pro_data{iprof,3});

alat=coords(iprof,2);
alon=coords(iprof,1);

pos_miss=find(finite(sal)==0 |finite(temp)==0 | finite(fpress)==0);

n_total=length(fpress);
sal(pos_miss)=[];
temp(pos_miss)=[];
fpress(pos_miss)=[];

nd=length(fpress);

ratio_bad(iprof)=nd/n_total;


 theta = sw_ptmp(sal,temp,fpress,0);

 % this section looks at the number of bad points in the profile
 
 
 % FIND THE DENISTY GRADIENT
 
 press_ref=(fpress(1:nd-1)+fpress(2:nd))./2;
% 
 pden_top = sw_pden(sal(1:nd-1),temp(1:nd-1),fpress(1:nd-1),press_ref);
 pden_bot = sw_pden(sal(2:nd),temp(2:nd),fpress(2:nd),press_ref);
%


del_den=(pden_bot-pden_top)./press_ref;






% del_del <-0.001 is about the same as N^2 < -5e6 1/sec^2
%[ibad,jbad]=find(del_den < (-.001/5.));
pos_bad=find(del_den < (-.001/12));



% compute and grid the density

if length(pos_bad)== 0

good_grad=[good_grad,iprof];


pden_0 = sw_pden(sal,temp,fpress,0)-1000.;

% [gam,dg_lo,dg_hi] = gamma_n(sal,temp,fpress,alon,alat);
% 
% missing_gam=find(gam <-90);
% if length(missing_gam <=1) 
%     gam(missing_gam)=NaN;
% end

[sal_0_junk,temp_0_junk,press_0_junk,press_top_0_junk,press_bot_0_junk] = ...
	vert_den_grid_one(sal,temp,fpress,pden_0,density_surface);
%[sal_gam_junk,temp_gam_junk,press_gam_junk,press_top_gam_junk,press_bot_gam_junk] =...
%	 vert_den_grid_one(sal,temp,fpress,gam,density_surface);

% sal_gam(iprof,:)=sal_gam_junk; 
% temp_gam(iprof,:)=temp_gam_junk;
% press_gam(iprof,:)=press_gam_junk; 
% press_top_gam(iprof)=press_top_gam_junk; 
% press_bot_gam(iprof)=press_bot_gam_junk; 
         
sal_0(iprof,:)=sal_0_junk; 
temp_0(iprof,:)=temp_0_junk;
press_0(iprof,:)=press_0_junk; 
press_top_0(iprof)=press_top_0_junk; 
press_bot_0(iprof)=press_bot_0_junk; 
end %if density gradient is bad


end % going through the profiles


% grid to density referanced to the surface


coords=coords(good_grad,:);
  dt=dt(good_grad,:);
  mdep=mdep(good_grad);
  npts=npts(good_grad);
  qual=qual(good_grad);
  time=time(good_grad,:);
  id=id(good_grad);
  pro_data=pro_data(good_grad,:);
  wmo_type=wmo_type(good_grad);
  press_miss=press_miss(good_grad);
 dac=dac(good_grad);
 
% sal_gam=sal_gam(good_grad,:); 
% tmep_gam=temp_gam(good_grad,:);
% press_gam=press_gam(good_grad,:); 
% press_top_gam=press_top_gam(good_grad); 
% press_bot_gam=press_bot_gam(good_grad); 
         
sal_0=sal_0(good_grad,:); 
temp_0=temp_0(good_grad,:);
press_0=press_0(good_grad,:); 
press_top_0=press_top_0(good_grad); 
press_bot_0=press_bot_0(good_grad); 

per_bad_grad=100*length(good_grad)/nprofiles;
  eval(['save den_grid_',d(isquare).name,' coords dt time ',...
         'qual mdep npts id pro_data per_bad_grad ', ...
         'density_surface ',...
         'sal_0 temp_0 press_0 press_top_0 press_bot_0'])


clear dt mdep npts qual time id prof_data wmo_type press_miss dac ...
sal_0 temp_0 ratio_bad press_0 press_top_0 press_bot_0 

end % going through the wmo squares

cd ..
