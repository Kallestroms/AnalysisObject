function ts = indecObjMakeTimeSeries(indecObj);
%indecObjMakeTimeSeries     - rewamps the indec  data object data to a continous time series
%function call ts = indecObjMakeTimeSeries(indecObj);
ts            = indecObj(1);
data          = [indecObj.data];
ts.data.valid =  [data.valid];
ts.data.dat   =  [data.dat];
ts.data.valid =  ts.data.valid(:);
ts.data.dat   =  ts.data.dat(:);
