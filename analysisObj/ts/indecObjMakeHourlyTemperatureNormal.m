function [retCode,out] = indecObjmakeHourlyTemperatureNormal(sy);
% indecObjmakeHourlyTemperatureNormal    - generates an hourly normal for any 
% function [retCode,normal] = indecObjmakeHourlyTemperatureNormal(sy);
% -----
% input standard indecSynop object
% output normal.normal  - normal to use 2004 is referenced year 
%              .normalDay  - daily variations of normal
%              .normalRaw - raw data not smotthed

retCode = 'OK';
out = [];

try
    % rewamp the data to a continous time series remove nans and interpolate to
    ts = indecObj2tsObj(sy);
    is_NaN = isnan(ts.data.dat);
    ts.data.dat(is_NaN)   = [];
    ts.data.valid(is_NaN) = [];
        
    [yr mn dy hr] = datevec(ts.data.valid);
    
    %establish reference year which contains "skuddår
    availYr = fix(unique(yr));
    nYr = length(availYr);

    % find data on years and create a mean over all available years
    dt = 1../24; 
    refYr       = 2004;
    refValid    = datenum(2004,01,01,01,0,0):dt:datenum(2004,12,31,23,0,0);
    
    normal = ts;
    normal.data.valid   = refValid';
    normal.data.dat     = ones(length(refValid),nYr).*NaN;
    normal.type = 'temperatureNormal';
    
    for iYr = 1:nYr;
        I = yr == availYr(iYr);
        valid = datenum(refYr,mn(I),dy(I),hr(I),0,0);
        dat   = ts.data.dat(I); 
        [dum I J] = intersect(refValid,valid);
        normal.data.dat(I,iYr) = dat(J);
    end    
    normal.data.dat = nanmean(normal.data.dat')';
    [normal] = indecObjRemoveNans(normal);
    [normal] = indecObjTsInterpolate(normal,'linear');
    % create smooting vector
    smoothVector.data.part = [ones(size(normal.data.dat'))*0 normal.data.valid' ones(size(normal.data.dat'))*0]';
    smoothVector.data.dat   = [normal.data.dat' normal.data.dat' normal.data.dat']';
    
    % filter in low pass and high pass
    fs = 1; % hour
    [bl al] = butter(5,fs/2/168);
    normalL = normal;
    normalH = normal;
    datLow  = filtfilt(bl,al,smoothVector.data.dat);
    datHigh = smoothVector.data.dat - datLow;
    k = smoothVector.data.part > 0;
    normalL.data.dat =  datLow(k);
    normalH.data.dat = datHigh(k);
    
    % make daily variation from HP data
    
    out.normal    = normalL;
    out.normalDay  = normalH;
    out.normalDay.type = 'temperatureNormalDailyVariation';
    out.normalRaw = normal;
    out.normalRaw.type = 'temperatureNormalUnSmoothedData';
catch
end
