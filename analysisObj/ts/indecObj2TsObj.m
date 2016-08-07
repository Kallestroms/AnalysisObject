function ts = indecObj2TsObj(indecObj);
%indecObjMakeTimeSeries     - rewamps the indec  data object data to a continous time series
%function call ts = indecObjMakeTimeSeries(indecObj);
ts            = indecObj(1);
data          = [indecObj.data];
try
    ts.data.valid       =  [data.valid];
    ts.data.dat         =  [data.dat];
    ts.data.valid       =  ts.data.valid(:);
    ts.data.dat         =  ts.data.dat(:);
    [ts.data.valid I]   = sort(ts.data.valid);
    ts.data.dat         = ts.data.dat(I);
catch
    valid = [];
    dat   = [];
    for ii = 1:length(data);
        valid   = [valid' data(ii).valid(:)']';
        dat     = [dat'   data(ii).dat(:)']';
    end
    ts.data.valid =  valid(:);
    ts.data.dat   =  dat(:);
    [ts.data.valid I]   = sort(ts.data.valid);
    ts.data.dat         = ts.data.dat(I);
end
