var=ones(10000,100000);



parfor ifile=1:44
    file_name=['O:\parfortest\junk_save_test_',num2str(ifile),'.mat'];
   parsavejunk(var,file_name)







end

function parsavejunk(var,file_name)
        OriginalWarning=warning('error','MATLAB:save:sizeTooBigForMATFile');

 
             try 
                 save (file_name,'var','-v7')
             catch
                 save (file_name,'var','-v7.3')
             end

end