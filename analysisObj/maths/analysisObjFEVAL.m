function fevalObj = analysisObjFEVAL(type, obj)
%analysisObjFEVAL    - does a function eval on data in an analysis Object 
%function call fevalObj = analysisObjFEVAL(type,obj);
% input     - in    - obj analysis object and type - feval function to use e.g. 'nansum' 
% output    - out   - analysisObject with .dat fevaled 

% Rev& 1.0 
% Programmed:Dr.Ing. Karl Christian Strømsem
% OffTek AS 2011-03-05
%

fevalObj = analysisObjCreate(obj(1));
try
        for ii=1:length(obj);
            fevalObj(ii) = obj(ii);
            fevalObj(ii).data.dat = feval(type,fevalObj(ii).data.dat);
            
            if length(fevalObj(ii).data.dat) == 1;
                fevalObj(ii).data.time = fevalObj(ii).data.time(1);
            end
            fevalObj(ii).type = sprintf('%s fevaled by # %s #',fevalObj(ii).type,type);
        end
catch
    fevalObj(ii) = analysisObjCreate(obj(ii));
    fevalObj(ii).type = 'error during feval';
end




