% makef3f5.m - matlab script to make figures 3 and 5 for the globahc paper
mycor = [

         0.88          0.31             0
         0.60             0             0
         0.30          0.31          0.99
            0          0.60          0.20
         0.28          0.77          0.96
         0.99          0.81             0
         1.00          0.20          0.80
         0.49          0.10          0.34
         0.60          0.60          0.60
         .7             .9             .2
         0             0             0];



%%
% multi_gpra_compute_curve
load '/Volumes/Data/Globalhc/SAL/Floats/gpra_2012.mat'
min_year=1950;
max_year=2012;

%%     
figure(1); clf;orient landscape; wysiwyg

hc_top=zeros(1,length(time_900_1800));
%% bottom 
time=time_900_1800;
xv=[[time;time(end:-1:1)]];


hc_bot=hc_top;
hc_top=hc_top+[hc_whole_bottom hc_whole_bottom(end) hc_whole_bottom(end) hc_whole_bottom(end)]*100;

yv=[hc_top,hc_bot(end:-1:1)];
verts=[xv,yv'];
faces=[1:length(xv)];
p3=patch('Faces',faces,'Vertices',verts,'FaceColor',mycor(6,:));
hold on


%% 900_1800 
time=time_900_1800;
xv=[[time;time(end:-1:1)]];


hc_bot=hc_top;
hc_top=hc_top+hc_whole_900_1800*100;

yv=[hc_top,hc_bot(end:-1:1)];
verts=[xv,yv'];
faces=[1:length(xv)];
p3=patch('Faces',faces,'Vertices',verts,'FaceColor',mycor(1,:));
hold on

% p2=plot(time,hc_top,'color','k');
% 
% 
% set(p2,'linewidth',3);

%% 700_900 
time=time_700_900;
xv=[[time;time(end:-1:1)]];


hc_bot=hc_top;
hc_top=hc_top+hc_whole_700_900*100;

yv=[hc_top,hc_bot(end:-1:1)];
verts=[xv,yv'];
faces=[1:length(xv)];
p3=patch('Faces',faces,'Vertices',verts,'FaceColor',mycor(2,:));
hold on

% p2=plot(time,hc_top,'color','k');
% 
% 
% set(p2,'linewidth',3);
% 
%% 300_700 
time=time_300_700;
xv=[[time;time(end:-1:1)]];


hc_bot=hc_top;
hc_top=hc_top+hc_whole_300_700*100;

yv=[hc_top,hc_bot(end:-1:1)];
verts=[xv,yv'];
faces=[1:length(xv)];
p3=patch('Faces',faces,'Vertices',verts,'FaceColor',mycor(3,:));
hold on

% p2=plot(time,hc_top,'color','k');
% 
% 
% set(p2,'linewidth',3);
%% 100_300 
time=time_100_300;
xv=[[time;time(end:-1:1)]];


hc_bot=hc_top;
hc_top=hc_top+hc_whole_100_300*100;

yv=[hc_top,hc_bot(end:-1:1)];
verts=[xv,yv'];
faces=[1:length(xv)];
p3=patch('Faces',faces,'Vertices',verts,'FaceColor',mycor(4,:));
hold on
% 
% p2=plot(time,hc_top,'color','k');
% 
% 
% set(p2,'linewidth',3);
%% 100_300 
time=time_100;
xv=[[time;time(end:-1:1)]];


hc_bot=hc_top;
hc_top=hc_top+hc_whole_100*100;

yv=[hc_top,hc_bot(end:-1:1)];
verts=[xv,yv'];
faces=[1:length(xv)];
p3=patch('Faces',faces,'Vertices',verts,'FaceColor',mycor(5,:));
hold on

% p2=plot(time,hc_top,'color','k');
% 
% 
% set(p2,'linewidth',3);
%%
ylabel('Percent of Ocean Volume Sampled','fontsize',24);
%set(p2,'linewidth',3)

%set(pt,'linewidth',3)
set(gca,'XTick',[min_year:10:max_year],'tickdir','out', 'XMinorTick','on')


xlabel('Time [years]','fontsize',24);

%title('GPRA','fontsize',24);
axis([min_year max_year 0 100])
set(gca,'fontsize',24)


%e1=errorbar(time_argo,hc_one_argo,error_argo);set(e1,'linewidth',2)
%e2=errorbar(time_no_argo,hc_one_no_argo,error_no_argo,'r');set(e2,'linewidth',2)
%e3=errorbar(time,hc_one,error_all,'k');set(e3,'linewidth',2)

%plot the x-axis

%plot([min_year-.5 max_year+.5],[0 0],'k')





eval(['print -dpng -f1 /Users/johnlyman/figs/greg/gpra_2012_oco'])
eval(['print -dpdf -f1 /Users/johnlyman/figs/greg/gpra_2012_oco'])
%%


%compute the slope of the line

