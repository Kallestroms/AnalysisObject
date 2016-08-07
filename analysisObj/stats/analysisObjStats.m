function [out] = analysisObjStats(in,type)
%indecObjStats  - calculate the defined statistics type for the data in
%function call [out] = indecObjScale(in,type);
%
% input     - in - analysisDataObject with .run, .time and .dat
%           - type  - 'nanmean', 'std' etc ...
% output    - out   - indecDataObject with .dat scaled and .dt as fixed min date

try
    
    out = in;
    nObj = length(out);
    estr = sprintf('out(ii).data.dat = %s(out(ii).data.dat);',type);
    for ii = 1:nObj;
        eval(estr);
        out(ii).data.time = fix(min(out(ii).data.time));
    end
catch
    return
end






