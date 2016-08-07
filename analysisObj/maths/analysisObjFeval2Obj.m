function fevalObj = analysisObjFEVAL2Obj(type,X,Y)
%analysisObjFEVAL2Obj    - does a function eval on data in two analysisObjects
%function call fevalObj = analysisObjFEVAL2Obj(type,X,Y)
% ----
% input     X, Y analysisObjects 
%           type - feval function to use e.g. 'nansum' ,'.+' etc
% ----
% output    - out   - indecDataObject with .dat fevaled 
% NB does not correlate on valid or run must be done outside. 

% OffTek AS 2010 -
% Programmed by: Karl Christian Strømsem



fevalObj = analysisObjCreate(X(1));

try
        for(ii=1:length(X))
            fevalObj(ii) = X(ii);
            fevalObj(ii).data.dat = feval(type,X(ii).data.dat,Y(ii).data.dat);
            fevalObj(ii).parameter = sprintf('%s & %s combined by # %s #',X(ii).parameter,Y(ii).parameter,type);            
            fevalObj(ii).type = sprintf('Obj %s & %s combined by # %s #',X(ii).type,Y(ii).type,type);
        end
catch
    fevalObj(ii) = analysisObjCreate(X(ii));
    fevalObj(ii).type = 'error during feval';
end



