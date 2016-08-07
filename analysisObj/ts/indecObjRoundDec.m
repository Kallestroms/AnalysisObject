function [indObj] = indecObjRoundDec(indObj) ;
% function [indObj] = indecObjRoundDec(indObj) ;
% This function rounds every dat element to the nearest decimal number.

n = length(indObj) ;

for (ii = 1:n)
    indObj(ii).data.dat = round(indObj(ii).data.dat*10)/10 ;
end