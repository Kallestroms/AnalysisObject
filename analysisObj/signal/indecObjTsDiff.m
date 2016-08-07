function [out] = indecObjectTimeSeriesIntepolate(in,varargin);
% indecObjectTimeSeriesIntepolate  - interpolates a timeseries object to hourly resolution
% function call [out] = indecObjectTimeSeriesIntepolateTimeSeries(in,[method]);
% in     - inDec time series data object
% method - optional default is set to 'spline'
%
%

% rev 1 & 2004-09-30 
% Programmed by Karl Christian Strømsem, InDec AS
trace('OBSOLETE USE ## indecObjTsInterpolate ## instead');
out = in;
out.interpolation = 'none';
if nargin ==1;
    method = 'spline';
else
    method = varargin{1};
end

try
    % sort 
    [valid I]           = sort(in.data.valid);
    data.valid          = in.data.valid(I);
    in.data.dat         = in.data.dat(I);
    % check and remove NaNs
    is_NaN                  = isnan(in.data.dat);
    in.data.valid(is_NaN)   = [];
    in.data.dat(is_NaN)     = [];
    
    % set Hourly time vector and interpolate with method
    valid               = (min(in.data.valid):1/24:max(in.data.valid))';
    out.data.dat        = interp1(data.valid,data.dat,valid,method);
    out.data.valid     = valid;
    out.interpolation   = method;
catch
end
