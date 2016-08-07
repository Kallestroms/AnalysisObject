function [out] = analysisObjScale(in,fact,type);
%analysisObjScale  - scale the data in the incecobj by
%function call [out] = analysisObjScale(in,fact,type);
%
% input     - in - analysisObjScale with .run, .valid and .dat
%           - fact  - scale factor
%           - type  - add, multiply
% output    - out   - analysisObjScale with .dat scaled

try
    
    out = in;
    nObj = length(out);
    
    switch type
        
        case 'add'
            for ii = 1:nObj;
                out(ii).data.dat = out(ii).data.dat + fact;
            end
        case 'multiply'
            for ii = 1:nObj;
                out(ii).data.dat = out(ii).data.dat.*fact;
            end
        otherwise
            error('Scaling not defined')
    end
catch
    return
end






