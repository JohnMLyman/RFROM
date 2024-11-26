current=cd('/Users/johnlyman/data/Globalhc/HC/All_Data')

d=sdir('e*.mat');
good_oclnums=[];

for l=1:length(d)
   d(l).name
   eval(['load ',d(l).name,' oclnum'])
   
   good_oclnums=[good_oclnums;oclnum];
   
end




save file_good_oclnums.mat good_oclnums

cd(current)