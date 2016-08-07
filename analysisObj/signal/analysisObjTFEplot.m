function Hfig = analysisObjTFEplot(Txy,fc);
%    Hfig = analysisObjTFEplot(Txy,[fc]);
% fdunction call Hfig = analysisObjTFEplot(Txy); 
% --- input
% Txy       - analysis time series data object with complex transfer function 
% --- output
% Hfig      - matrix of figure handles;


% rev 1 & 2010-12-15 
% Programmed by Karl Christian Strømsem, OffTek AS

if nargin == 1
    fc = Txy.data.time(end);
end    

is50 = find(Txy.data.time < fc);
is50(1:2) = [];


try    
    % first determine part of Txy with more than 50 % coherence (if exists)
    if (isfield(Txy.data,'coherence')) 
%        is50 = 3:length(Txy.data.dat);
%        is50 = find(Txy.data.coherence > 0.5 == 1 );
%        %is50 = min(is50):max(is50);
    else 
%        is50 = 3:length(Txy.data.dat);
        Txy.data.coherence = ones(length(Txy.data.dat),1)*NaN;
    end        
        
    H.fig(1) = figure;

    % plot Txy and phase as function of frequency
    subplot(211);plot(Txy.data.time(is50),abs(Txy.data.dat(is50)),'r');grid on;hold on;
    a = axis;
    plot(Txy.data.time(is50),a(4).*Txy.data.coherence(is50),'g+');
    ylabel('Txy and coherence (+) ');title(sprintf('%s %s',Txy.location,Txy.type));

    subplot(212);plot(Txy.data.time(is50),angle(Txy.data.dat(is50))*180/pi,'r');grid on;hold on;
    a = axis;
    plot(Txy.data.time(is50),a(4).*Txy.data.coherence(is50),'g+');
    xlabel('Frequncy (Hz)');ylabel('Phase');

    H.fig(2) = figure;
    
    subplot(211);plot(1../Txy.data.time(is50),abs(Txy.data.dat(is50)),'r');grid on;hold on;
    a = axis;
    plot(1../Txy.data.time(is50),a(4).*Txy.data.coherence(is50),'g+');
    ylabel('Txy and coherence (+)');title(sprintf('%s %s',Txy.location,Txy.type));

    subplot(212);plot(1../Txy.data.time(is50),angle(Txy.data.dat(is50))*180/pi,'r');grid on;hold on;
    a = axis;
    plot(1../Txy.data.time(is50),a(4).*Txy.data.coherence(is50),'g+');
    xlabel('Period (Hz)');ylabel('Phase');
    
    
catch
    warning('#### Problems plotting transfer function ###');
end
