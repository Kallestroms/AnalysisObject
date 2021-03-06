function [Pxx] =analysisObjPSD(X,WINDOW,NOVERLAP,NFFT,Fs) 
% fdunction call [Pxx] =analysisObjPSD(X,WINDOW,[NOVERLAP],[NFFT],[Fs]); 
% --- input
% X    - anaysis time series data object - the input signal
% WINDOW    - size of window for for FFT e.g. 1024, if empty 1024 is used
% NOVERLAP  - size of overlap on the FFT e.g. 512, if empty WINDOW/2 is used
% NFFT      - number of samples used in the FFT e.g. 512, if empty WINDOW/2 is used
% Fs        - sampling frequency if empty, fs is estiamted from time vector
% --- output
% Pxx       - analysis time series data object with power spectral density estimate 


% rev 1 & 2010-12-15 
% Programmed by Karl Christian Str�msem, OffTek AS

Pxx = X;

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
    [out1,W] = pwelch(X.data.dat,WINDOW,NOVERLAP,NFFT,Fs);
    Pxx.data.dat = out1;
    Pxx.data.time = W;
    Pxx.type = sprintf('PSD of %s',X.parameter);
    
catch
    warning('#### PSD not estimated ###');
end
