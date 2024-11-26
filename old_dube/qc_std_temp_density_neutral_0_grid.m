% the  new qc file qc3 
     
close all


 d=sdir(['den_den_no*.mat']);
 
 density_surface=[18:.02:31];
 n_den=length(density_surface);
 
 
 dd=[ 17 35 41 49 51 56 57 68 70 71 74 75 120 76 85 93 99 101 113 115 116 ...
     120 121 147 148 149 150 157 163 180 182 183 186 187 189 192 196 203 ...
     206 208 209 214 215 217 219 240 243 244 245 264 265 267 274 275 ...
     276 285 290 296 302 313 322 333 335 336 348 349 350 351 352 357 ...
     358 368 369 374 375 376 380 388 390 393];
 
  dd=[1:length(d)];
  
 for iplace=1:length(dd)
%for isquare=302:length(d)
isquare=dd(iplace) 



eval(['load ',d(isquare).name])
%eval(['load den_2000_f',num2str(isquare),'.mat'])

display(d(isquare).name) 

% sorting the data
nd=length(depth);
temp2=temp;

yd=dt(:,1)+(dt(:,2)-1)/12.+(dt(:,3)-1)/365.;
  
  %find the right dates (ie only preform the qc on the times that
  % I cheacked.
  
  good_times=find(yd >= 2002);
  dt=dt(good_times,:);
  temp=temp(good_times,:);
  sal=sal(good_times,:);
  fpress=fpress(good_times,:);22,5,52,5
  mdep=mdep(good_times);
  npts=npts(good_times);
  time=time(good_times);
  temp2=temp;
  sal2=sal;
 theta = sw_ptmp(sal,temp,fpress,0);
 coords=coords(good_times,:);
 % this section looks at the number of bad points in the profile
 
 
 % FIND THE DENISTY GRADIENT
 
 press_ref=(fpress(:,1:nd-1)+fpress(:,2:nd))./2;
% 
 pden_top = sw_pden(sal(:,1:nd-1),temp(:,1:nd-1),fpress(:,1:nd-1),press_ref);
 pden_bot = sw_pden(sal(:,2:nd),temp(:,2:nd),fpress(:,2:nd),press_ref);
%
pden_0 = sw_pden(sal,temp,fpress,0)-1000.;
%pden_top_surface_del = sw_pden(sal(:,1:nd-1),temp(:,1:nd-1),fpress(:,1:nd-1),0);

%count the number ofbad points

del_den=(pden_bot-pden_top)./press_ref;




%

 num_samp=size(temp,2);
 num_profiles=size(temp,1);
 num_good=[1:num_profiles]*NaN;
 num_nans=num_good;
 
 for k=1:num_profiles 
        ii=find(~isnan(temp(k,:)+fpress(k,:)+sal(k,:)));
        length_good=length(ii);
        
        num_good(k)=length_good;
        num_nans(k)=ii(end)-length_good;
        fpress(k,:)=[fpress(k,ii),[1:num_samp-length_good]*NaN];
        temp(k,:)=[temp(k,ii),[1:num_samp-length_good]*NaN];
        sal(k,:)=[sal(k,ii),[1:num_samp-length_good]*NaN];
 end
 
 ratio_bad=  num_nans./num_good;
 
   ii_missing=find(ratio_bad >= .05);
   
% take out all the points that lie 3 std at every depth level
ii=[];

jj=[];



press_ref=(fpress(:,1:nd-1)+fpress(:,2:nd))./2;
% 
 pden_top = sw_pden(sal(:,1:nd-1),temp(:,1:nd-1),fpress(:,1:nd-1),press_ref);
 pden_bot = sw_pden(sal(:,2:nd),temp(:,2:nd),fpress(:,2:nd),press_ref);
%
pden_0 = sw_pden(sal,temp,fpress,0)-1000.;
%pden_top_surface_del = sw_pden(sal(:,1:nd-1),temp(:,1:nd-1),fpress(:,1:nd-1),0);



del_den=(pden_bot-pden_top)./press_ref;

% del_del <-0.001 is about the same as N^2 < -5e6 1/sec^2
%[ibad,jbad]=find(del_den < (-.001/5.));
[ibad,jbad]=find(del_den < (-.001/12));

 jj=unique([ibad']');

pden_0(jj,:)=[];
temp(jj,:)=[];
sal(jj,:)=[];
fpress(jj,:)=[];
coords(jj,:)=[]

dt(jj,:)=[];
time(jj)=[];
id(jj)=[];
mdep(jj)=[];
qual(jj)=[];
npts(jj)=[];


%surface_press(jj)=[];
% [tu,rp,p_ave] = sw_turn(sal',temp',fpress');
% tu=tu';
% rp=rp';
% p_ave=p_ave';


del_den(jj,:)=[];
ratio_bad2=ratio_bad;
ratio_bad(jj)=[];



% % if length (temp) >=1  
% %     fpress(jj,:)=[];id(jj,:)=[];qual(jj)=hold off



alon=coords(:,1);
alat=coords(:,2);



[gam,dg_lo,dg_hi] = gamma_n(sal',temp',fpress',alon,alat);
gam=gam';
missing_gam=find(gam <-90);
if length(missing_gam <=1) 
    gam(missing_gam)=NaN;
end
dg_lo=dg_lo';
dg_hi=dg_hi';


% grid to density referanced to the surface
[sal_0,temp_0,press_0,press_top_0,press_bot_0] = vert_den_grid(sal,temp,fpress,pden_0,density_surface);


[sal_gam,temp_gam,press_gam,press_top_gam,press_bot_gam] = vert_den_grid(sal,temp,fpress,gam,density_surface);


% %     npts(jj)=[];mdep(jj)=[];time(jj,:)=[];
    per_bad_grad=100*length(jj)./length(good_times);
  eval(['save grad_den_0_grid_a',d(isquare).name,' coords dt time ',...
         'temp qual mdep npts id sal fpress per_bad_grad ', ...
         'gam dg_lo dg_hi ratio_bad density_surface ',...
         'sal_gam temp_gam press_gam press_top_gam press_bot_gam ', ...
         'sal_0 temp_0 press_0 press_top_0 press_bot_0'])
 end
% %  end