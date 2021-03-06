function analysisObjPSPC(Pxy,Fm)
%    Hfig = analysisObjPSPC(Pxy,[Fm]);
% fdunction call Hfig = analysisObjTFEplot(Txy); 
% --- input
% Pxy       - analysis time series object with spectral analysis data
%           Pxy(1) - Pxx : Time series X spectral estimate
%           Pxy(2) - Pxx : Time series Y spectral estimate
%           Pxy(3) - Txy : Time series X vs time series Y complex transfer function
%           Pxy(4) - Cxy : Time series X vs time series Y coherence 
% fc        - cut off frequency, if empty nyquist/2 is used
% --- output
% Hfig      - matrix of figure handles;

% rev 1 & 2010-12-15 
% Programmed by Karl Christian Str�msem, OffTek AS

warning('### Consider to reprogram not using PSPC ###')


if nargin == 1
    Fm = Pxy(1).data.time(end);
end

% set plot range
Fs = Pxy(1).data.time;
isRng = 1:length(Fs);
isRng(1) = [];
Fs = diff(Fs);
Fs = mean(Fs)*length(Fs)*2;

ti1 = Pxy(1).parameter;
ti2 = Pxy(2).parameter;

try
    PP(:,1) =       Pxy(1).data.dat(isRng);
    PP(:,2) =       Pxy(2).data.dat(isRng);
    PP(:,3) =   abs(Pxy(3).data.dat(isRng));
    PP(:,4) = angle(Pxy(3).data.dat(isRng));
    PP(:,5) =       Pxy(4).data.dat(isRng);

    inlinepspc(PP,Fs,Fm,ti1,ti2);
    
    
catch
    warning('#### Problems plotting transfer function ###');
end

%
%  inline function 
function inlinepspc(P,Fs,Fm,ti1,ti2,ft,Gt)
%pspc       - plots spectra from Rick Jefferys' modified Spec. function
% pspc plots the output of the SPECTRUM function.
% Fs is the sampling rate
% Fm is the maximum frequency desired
% ti1 and ti2 are the titles of x and y channels
% If provided, ft and Gt are theoretical frequency axis and complex TF
%	pspc(P,Fs), uses P, the output of SPEC, and Fs, the
%	sample frequency, to successively plot:
%
%		Pxx - X Power Spectral Density & confidence.
%		Pyy - Y Power Spectral Density & confidence.
%		abs(Txy) - Transfer Function Magnitude.
%		angle(Txy) - Transfer Function Phase.
%		Cxy - Coherence Function.
%
%	The 95% confidence intervals are ***not*** displayed on the power
%	spectral density curves.
%
%	pspc(P) uses normalized frequency, Fs = 2, so that 1.0 on
%	the frequency axis is half the sample rate (the Nyquist
%	frequency).

%	J.N. Little 7-9-86
%	Revised 4-25-88 C.R. Denham.
%	Copyright (c) 1986 by the MathWorks, Inc.

[n,m] = size(P);

if nargin < 2
   Fs = 1;
end

if nargin >= 3
if Fm <= Fs/2
n=floor(n*Fm*2/Fs);
else
Fm=Fs/2;
end
end

if nargin <4, ti1='X ';ti2='Y ';end
if nargin <5, ti2=' Y';end

f = (1:n-1)/length(P)*Fs/2;

%if m == 2
%   c = [P(2:n,1)+P(2:n,2) P(2:n,1)-P(2:n,2)];
%  else
%   c = [P(2:n,1)+P(2:n,6) P(2:n,1)-P(2:n,6)];
%end
%c = c .* (c > 0);
%
% Pxx plot------------------------------------------------------
%
figure
plot(f,P(2:n,1))
%,f,c(:,1),'--',f,c(:,2),'--'), ...
if nargin<4
title('Pxx - X Power Spectral Density')
else
title([ti1 ' power spectral density'])
end
xlabel('Frequency')
pause

if m == 2
   return
end


%c = [P(2:n,2)+P(2:n,7) P(2:n,2)-P(2:n,7)];
%c = c .* (c > 0);
%
% Pyy plot-------------------------------------------------------

gamma2=P(2:n,5).^2;
plot(f,P(2:n,2),f,P(2:n,2).*gamma2,f,P(2:n,2).*(1.-gamma2))
%,f,c(:,1),'--',f,c(:,2),'--'), ...
if nargin < 5
title('Pyy - Y Power Spectral Density')
else
title([ti2 ' power spectral density'])
end
 xlabel('Frequency'),pause

%
% RAO plot--------------------------------------------------------
%
% get incoherent RAO

c=sqrt(P(2:n,2)./P(2:n,1));
l=P(2:n,5)>0.5;
if any(l);
fl=max(2,min(find(l))):max(find(l));
else
fl=2:n;
end

plot(f(fl-1),P(fl,3),f(fl-1),c(fl-1),'--'), hold on, ...
axis(axis);
v=axis;

plot(f(fl-1),v(3)+P(fl,5)*(v(4)-v(3)),'+'); ...
if exist('ft')==1&exist('Gt')==1
plot(ft,abs(Gt),'c2'),plot(ft,abs(Gt),'x')
end

if nargin <5
 title('Coherence & transfer function ')
 else
title([ti1 ' / ' ti2 ' Coherence & transfer function'])
end
xlabel('Frequency'), hold off,pause;

%
% RAO phase
%

plot(f,180/pi*P(2:n,4),f,-180+360*P(2:n,5),'+')
axis([0 f(n-1) -180 180]);
if exist('ft')==1&exist('Gt')==1
hold on;
plot(ft,180/pi*angle(Gt),'c2');
plot(ft,180/pi*angle(Gt),'x');
hold off;
end

if nargin < 5
 title(' Transfer function phase and coherence')
else
 title([ti1 ' / ' ti2 ' transfer function phase and coherence'])
end

 xlabel('Frequency'), ...
 ylabel('Degrees'), pause
axis('auto');

%
% Coherence
%
plot(f,P(2:n,5)), ...
 title('Cxy - Coherence'), ...
 xlabel('Frequency'), pause

