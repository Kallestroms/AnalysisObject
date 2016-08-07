function    [valid,I] = indecObjSortOnValid(in);
% sort indec object on valid
% funcitons on two ecual lenght structures also
try
    [valid, I] = sort([in.valid]);    
catch    
    trace('error for indec data object sort');
end



