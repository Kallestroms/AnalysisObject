function     out = indecObjTSPSD(in,modelParam);
%indecObjTSPSD    - calculates PowerSpectral density for time seiries in 
%function     out = indecObjPSD(in,modelParam);
NFFT        = modelParam.NFFT;
fs          = modelParam.fs;
FFTWINDOW   = modelParam.FFTWINDOW;
fc          = modelParam.fc; 
    
out = in;
try
    [Px, f] = psd(in.data.dat,NFFT,fs,FFTWINDOW);
    I = f > fc;
    out.data.dat    = Px(I);
    out.data.valid  = f(I);
    
    out.parameter    = 'Power Spectral Density';
    out.type    = sprintf('From %s, N = %i, WINDOW = %i, fc = %f.1',in.parameter,NFFT,FFTWINDOW,fc);
catch
end
