function [out] = analysisObjPeaks(in)
% analysisObjPeaks  - establices min to max ranges between zero-crossings for an analysis Object
% function call [out] = analysisObjPeaks(in);
% in     - analysis time series data object (object)
%

% rev 1 & 2010-05-26
% Programmed by Karl Christian Strømsem, OffTek AS
%

out = in(1);
try

    nObj = length(in);

    for iObj = 1:nObj;

        % set time series to work on.
        time = in(iObj).data.time;
        time = time(:);
        ts  = in(iObj).data.dat;
        ts  = ts(:);
        TsMean = mean(ts);
        ts = ts-TsMean;

        dts     = diff(ts);
        [nl nc] = size(ts);

        l = 2:nl;
        % find zero crossings
        nz = find(ts(l).*ts(l-1)<0);

        %find up and down crossings and eastblish blocks
        k = find(dts(nz)>0);zup =nz(k);
        k = find(dts(nz)<0);zdo =nz(k);
        
        % ensure that we start the time series with a downcross to get
        % through to peak;
        if(zup(1) < zdo(1));zup(1) = [];end 


        [k idum]    = size(zup);
        [k1 idum]   = size(zdo);

        % identify number of crossings to use and set variables
        np  = min([k k1]);
        pk  = zeros(np-1,1);
        lp  = zeros(np-1,1);
        tr  = zeros(np-1,1);
        lt  = zeros(np-1,1);
        rg  = zeros(np-1,1);
        
        trace('#### REMEMBER TO LOOK INTO USING NANS HERE ####')

        % run through all blocks and identfy peaks and troughs and ranges
        if zup(1) < zdo(1); % if first crossing is up then
            for ii = 1:np-1;
                try
                    k       = zup(ii):zdo(ii);
                    pk(ii)  = max(ts(k));
                    lp(ii)  = k(1)+min(find(ts(k) == pk(ii)));
                    k       = zdo(ii):zup(ii+1);
                    tr(ii)  = min(ts(k));
                    rg(ii)  = pk(ii)-tr(ii);
                catch
                    pk(ii) = [];
                    lp(ii) = [];
                    tr(ii) = [];
                    rg(ii) = [];
                end
            end
        else
            for ii=1:np-1; % if first crossing is down then
                try
                k       = zup(ii):zdo(ii+1);
                pk(ii)  = max(ts(k));
                lp(ii)  = k(1)+min(find(ts(k)==pk(ii)));
                k       = zdo(ii):zup(ii);
                tr(ii)  = min(ts(k));
                rg(ii)  = pk(ii)-tr(ii);
                catch
                    pk(ii) = [];
                    lp(ii) = [];
                    tr(ii) = [];
                    rg(ii) = [];
                end
            end
        end

        
        out(end+1)              = in(iObj);
        out(end).data.dat       = pk(:)+TsMean;;
        out(end).data.time      = time(lp);
        out(end).parameter      = [in(iObj).parameter ,'peaks'];
        out(end).iter           = 'peaks';
        
        out(end+1)              = in(iObj);
        out(end).data.dat       = tr(:)+TsMean;
        out(end).data.time      = time(lp);
        out(end).parameter      = [in(iObj).parameter ,'thoughs'];
        out(end).iter           = 'thoughs';
        
        out(end+1)              = in(iObj);
        out(end).data.dat       = rg(:);
        out(end).data.time      = time(lp);
        out(end).parameter      = [in(iObj).parameter ,'ranges'];
        out(end).iter           = 'ranges';
        
    end
    out(1) = [];
catch
    error(lasterror);    
end
