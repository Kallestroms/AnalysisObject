function [Pxy] =analysisObjSpec(X,Y,WINDOW,NOVERLAP,NFFT,Fs)
% fdunction call [Pxy] =analysisObjSpec(X,[Y],WINDOW,[NOVERLAP],[NFFT],[Fs]);
% --- input
% X    - anaysis time series data object - the input signal
% Y    - anaysis time series data object - the response signal
% WINDOW    - size of window for for FFT e.g. 1024, if empty 1024 is used
% NOVERLAP  - size of overlap on the FFT e.g. 512, if empty WINDOW/2 is used
% NFFT      - number of samples used in the FFT e.g. 512, if empty WINDOW/2 is used
% Fs        - sampling frequency if empty, fs is estiamted from time vector
% --- output
% Pxy       - analysis time series data object with spectral analysis object.
%           - Pxy(1) = Pxx - spectral density of X
%           - Pxy(2) = Pyy - spectral density of Y
%           - Pxy(3) = Txy - Complex transfer function X - Y
%           - Pxy(4) = Cxy - Transfer Function Magnitude Squared Coherence

% rev 1 & 2010-12-15
% Programmed by Karl Christian Strømsem, OffTek AS

Pxy = X;

if ~isstruct(Y);
    error('requires two structs as input to run');
    return
end

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
    Pxy(1) = analysisObjPSD(X,WINDOW,NOVERLAP,NFFT,Fs);
    Pxy(2) = analysisObjPSD(Y,WINDOW,NOVERLAP,NFFT,Fs);
    Pxy(3) = analysisObjTFEstimate(X,Y,WINDOW,NOVERLAP,NFFT,Fs);
    Pxy(4) = analysisObjMSCOHERE(X,Y,WINDOW,NOVERLAP,NFFT,Fs);
    
catch
    warning('#### Error during spectral estimates ###');
end
