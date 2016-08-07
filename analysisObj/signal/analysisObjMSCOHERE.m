function [Cxy] =analysisObjMSCOHERE(X,Y,WINDOW,NOVERLAP,NFFT,Fs) 
% fdunction call [Cxy] =analysisObjMSCOHERE(X,Y,WINDOW,[NOVERLAP],[NFFT],[Fs]); 
% --- input
% X    - anaysis time series data object - the input signal
% WINDOW    - size of window for for FFT e.g. 1024, if empty 1024 is used
% NOVERLAP  - size of overlap on the FFT e.g. 512, if empty WINDOW/2 is used
% NFFT      - number of samples used in the FFT e.g. 512, if empty WINDOW/2 is used
% Fs        - sampling frequency if empty, fs is estiamted from time vector
% --- output
% Cxy       - analysis time series data object with Magnitude Squared Coherence Estimate.


% rev 1 & 2010-12-15 
% Programmed by Karl Christian Strømsem, OffTek AS

Cxy = X;

if ~exist('WINDOW','var');
    WINDOW = 1024;
end

if ~exist('NOVERLAP','var');
    NOVERLAP=WINDOW/2;
elseif isempty(NOVERLAP);
    NOVERLAP=WINDOW/2;
end

if ~exist('NFFT','var');
    NFFT=WINDOW;
elseif isempty(NFFT);
    NFFT=WINDOW;
end

if ~exist('Fs','var');
    Fs = 1../mean(diff(X.data.time));
elseif isempty(Fs);
    Fs = 1../mean(diff(X.data.time));
end

try
    [out1, W] = mscohere(X.data.dat,Y.data.dat,WINDOW,NOVERLAP,NFFT,Fs);
    Cxy.data.dat = out1;
    Cxy.data.time = W;
    Cxy.type = sprintf('MSCohere of %s and %s ',X.parameter,Y.parameter);
    
catch
    warning('#### MSCOHERE not estimated ###');
end
