function     out = indecObjTSPSD(in,modelParam);
%indecObjTSPSD    - calculates PowerSpectral density for time seiries in 
%function     out = indecObjPSD(in,modelParam);
% NFFT        = modelParam.NFFT;
% fs          = modelParam.fs;
% NOVERLAP    = modelParam.NOVERLAP;
% fc          = modelParam.fc;
% p1          = modelParam.param1; 
% p2          = modelParam.param2; 
NFFT        = modelParam.NFFT;
fs          = modelParam.fs;
NOVERLAP    = modelParam.NOVERLAP;
fc          = modelParam.fc;
p1          = modelParam.param1; 
p2          = modelParam.param2; 

out = in(1);
try
    out.data.dat    = spec(in(p1).data.dat,in(p2).data.dat,NFFT,NOVERLAP);
    out.data.valid  = ((0:(NFFT-1))*fs/(2*NFFT))';
    out.parameter    = 'Power Spectral Density using Rick Jefferys Normalized spectral estimate';
    out.type    = sprintf('From %s and %s , N = %i, WINDOW = %i, fs = %f.1',in(p2).parameter,in(p1).parameter,NFFT,NOVERLAP,fs);
catch
end
