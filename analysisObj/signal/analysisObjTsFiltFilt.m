function [out] = analysisObjTsfiltfilt(bl,al,in);
% analysisObjTsfiltfilt  - Zero-phase forward and reverse digital filtering on analysis Object
% function call [out] = analysisObjTsfiltfilt(bl,al,in);
% in     - analysisObject time series data object
% bl,al  - filter coefficients, e.g from butterworth filter
%
%

% rev 1 & 2012-01-19
% Programmed by Karl Christian Strømsem, OffTek AS
out = in;

try
    for its = 1:length(in);
        out(its).data.dat        = filtfilt(bl,al,in(its).data.dat);
        out(its).interpolation   = sprintf('%s filtered',out(its).interpolation);
    end
catch
end
