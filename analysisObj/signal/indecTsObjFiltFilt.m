function [out] = indecTsObjfiltfilt(in,bl,al);
% indecTsObjfiltfilt  - Zero-phase forward and reverse digital filtering on an InDec TS Obj
% function call [out] = indecTsObjfiltfilt(in,[bl,al]);
% in     - inDec time series data object
% bl,al  - filter coefficients, 
%
%

% rev 1 & 2006-09-28
% Programmed by Karl Christian Strømsem, InDec AS
out = in;

try
    for its = 1:length(in);
        out(its).data.dat        = filtfilt(bl,la,in.data.dat);
        out(its).interpolation   = sprintf('%s filtered',out(its).interpolation);
    end
catch
end
