function    [run,I] = indecObjSortOnRun(in);
%indecObjSortOnRun - sort indec object on run
% function  call  [run,I] = indecObjSortOnRun(in1);
% funcitons on two ecual lenght structures also
try
    [run, I] = sort([in.run]);    
catch    
    trace('error for indec data object sort');
end



