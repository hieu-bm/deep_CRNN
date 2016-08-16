if(strcmp('on', get(0,'Diary')))
    diary off
end
diaryname = ['Log_' strrep(strrep(...
datestr(now),' ','_'),':','-') '.txt'];
diary(diaryname)
t = timer('timerfcn',@updatediary,...
'period',10,...
'ExecutionMode','fixedRate');
start(t)
%put program to run here
runCRNN

stop(t)
diary off

%=============