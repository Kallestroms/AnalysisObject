function [out] = indecObjRemoveNans(in);
% removes nan data before interpolation in inDec data object
out = in;
try
    is_nan = isnan(in.data.dat);
    if isfield(in,'dt')
        out.data.dt(is_nan) = [];
        out.data.dat(is_nan) = [];
    elseif isfield(in,'valid')
        out.data.valid(is_nan) = [];
        out.data.dat(is_nan) = [];
    end
catch
    trace('error for indec dataobject');
end


