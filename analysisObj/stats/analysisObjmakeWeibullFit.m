function [out] = analysisObjmakeWeibullFit(in, varargin)
% function call [out] = analysisObjmakeWeibullFit(in,[lowerCufOff],[binDelta],[returnPeriods],[doPlot]]);
% input
% in            - analysisObj with time series as data.dat and data.time
% lowerCutOff   - uses full time series no cut off if not given, 0 is default
% binDelta      - input of resolution for bin vector, standard is 0.5
% returnPeriods - return periods vector in years 1, 10 25 and 100 is defalut
% doPlot        - if given will plot weibull fit
%
% out           - out fitted data and results for different return periods
%               - out.WBL contains all webill data.

doPlot          = 0;
returnPeriods   = [1 10 25 100];
lowerCutOff     = 0;
binDelta        = 0.5;

if nargin == 2;
    lowerCutOff= varargin{1};
end

if nargin == 3;
    lowerCutOff= varargin{1};
    binDelta = varargin{2};
end


if nargin == 4;
    lowerCutOff= varargin{1};
    binDelta = varargin{2};
    returnPeriods = varargin{3};
end

if nargin == 5;
    lowerCutOff= varargin{1};
    binDelta = varargin{2};
    returnPeriods = varargin{3};
    doPlot = 1;
end

out = in;

% run through all analysisObj sent into the routine.
nFits = length(in);
for iFit = 1:nFits
    try
        % PREPARE
        % prepare time seris for weibull fitting removing nans and ensuring that data is > zero,
        ts = in(iFit).data.dat;
        time = in(iFit).data.time;
        % remove nans
        ts(isnan(ts)) = [];
        % ensure all numbers above 0 or predetermined cut off
        ts = ts(ts>lowerCutOff);
        % block up into a distinct set of blocks for more robust WBL fitting
        [N,bin] = hist(ts,binDelta:binDelta:max(ceil(ts)));
        
        % ESTIMATE PROPER PROBABILITY LEVELS
        % then estimate duration of underalying time seires for statistical fitting assumes that time is
        % given as matalab datevec
        dt = nanmean(diff(time)*24);
        nLength = length(time);
        fractionOfYear = nLength*dt/365/24;
        nSamples4Dist  = length(ts);
        
        WBL.returnPeriods  = returnPeriods;
        WBL.returnProb   = 1 - 1./(nSamples4Dist./fractionOfYear.*returnPeriods);
        
        % ESTIMATE WEIBULL PARAMETERS AND 95 % confidence
        [PARMHAT,PARMCI] = wblfit(bin,0.95,zeros(size(bin)),N);
        WBL.gamma = PARMHAT(2);
        WBL.Hc    = PARMHAT(1);
        WBL.info = sprintf('cdf for %s',in(iFit).location);
        try         % first try with fitting confidence intervals
            [WBL.extremes,WBL.xlo,WBL.xup] = wblinv(WBL.returnProb,PARMHAT(1),PARMHAT(2),PARMCI);
            out(iFit).WBL = WBL;
        catch ME    % use in case error when fitting confidence intervals
            WBL.extremes = wblinv(WBL.returnProb,PARMHAT(1),PARMHAT(2));
            WBL.xlo = NaN;
            WBL.xup = NaN;
            out(iFit).WBL = WBL;
            out(iFit).WBL.ERROR = ME;
        end
        if doPlot
            figure;
            probplot('wbl',bin',zeros(size(N')),N');
            title(sprintf('Weibull Probability Plot, Parameter %s, for Location %s', in(iFit).parameter, in(iFit).location ));
            grid on;
            rp= out(iFit).WBL.returnPeriods;
            ex = out(iFit).WBL.extremes;
            fmt = sprintf('Return Periods %s yrs, with extremes %s ',repmat('%i, ',1,length(rp)),repmat('%.2f ',1,length(rp)));
            xlabel(sprintf(fmt,rp,ex));
        end
    catch ME
        out(iFit).WBL.ERROR = ME;
    end
end
