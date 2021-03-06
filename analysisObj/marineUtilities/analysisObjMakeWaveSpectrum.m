function waveObj = analysisObjMakeWaveSpectrum(Hs, Tp, f )
%waveObj = analysisObjMakeWaveSpectrum(Hs, Tp, f );
% input -----
% Hs = significatn wave height. 
% Tp = peak period. 
% f  = frequency axis, ideally equally spaced frequencies 
% output ---
% waveObj
%           .data.dat   -  actual wave spectrum m2.s (in Hz);
%           .data.time  -  frequency axis
%           .parameter - [ Hs, Tp, gamma, Hm0 ]
%           .unit       - m2.s
%           .source     - waveSpec (marintek)

% Programmed by Karl C Str�msem
% Version 1.0 & date 2010-06-21

w0  = 2*pi/Tp;
w   = 2*pi.*f;
gamma = 3.3;
dw  = mean(diff(w));
specType = 7;% (Jonwap)
PlotFlag = 0;% No plotting

waveObj = analysisObjCreate([]);
Par = [Hs w0 gamma ];

S = waveSpec(specType,Par,w,PlotFlag);

Hm0 = 4.*sqrt(sum(S*dw));

HsDiff = abs(Hm0/Hs-1);
if HsDiff > 0.05;
    waveObj.warning = warning('Spectrum not precise enough, diff Hs, Hm0 %i%%',HsDiff*100);     
end

waveObj.data.dat    = S'*2*pi;
waveObj.data.time   = f;
waveObj.parameter   = 'WaveSpectrum';
waveObj.type        = 'Jonswap';
waveObj.source      = 'waveSpec routine';
waveObj.unit        = 'm2.s';
waveObj.seastate    = [Hs Tp Hm0];
waveObj.fs          = mean(diff(f));
