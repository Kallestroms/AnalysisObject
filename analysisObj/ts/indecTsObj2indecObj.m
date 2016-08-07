function [obj] = indecTsObj2indecObj(tsObj);
% indecObjTimeSeries2Day - takes one indecObject timeseries object at a time interpolates and structures as InDec Object.
%function [obj] = indecObjTimeSeries2Day(objTs,vargin);
%  input    tsObj   indec object time series object 
%
%
try
    run       = tsObj.run;
    data      = tsObj.data;
    
    valid   = unique(fix([data.valid]));
    nValid  = length(valid); 

    if (~isfield(tsObj, 'valid'))
        tsObj.valid = -1 ;
    end
    if (~isfield(tsObj, 'iter'))
        tsObj.iter = -1 ;
    end
    if (~isfield(tsObj, 'run'))
        tsObj.run = -1 ;
    end
    
    tmpobj = tsObj ;
    tmpobj.data.dat = ones(24,1)*NaN ;
    tmpobj.data.valid = ones(24,1)*NaN ;
    obj    = repmat(tmpobj,1, nValid) ;
    
    
    iobj = 1;
    for iV = 1:nValid;
        iValid = valid(iV);
        I      = fix(data.valid) == iValid;
        if sum(I) ~=0;
            obj(iobj)        = tsObj; 
            dataDum.valid    = data.valid(I);
            dataDum.dat      = data.dat(I);
            obj(iobj).data          = indecObjDistributeDataOn24hrs(dataDum);
            obj(iobj).valid         = iValid;
            obj(iobj).iter          = 0;
            obj(iobj).run           = run;
            iobj     = iobj + 1;

        end
    end
    obj = obj(1:iobj-1) ;
catch
end