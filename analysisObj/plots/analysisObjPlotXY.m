function varargout = analysisObjPlotXY(obj1,obj2, varargin)
%splot      - plot two ts struct XY 

% check if time or valid used for time
isTime = isfield(obj1(1).data,'time');

s1 = [obj1.data];
s2 = [obj2.data];
        
ccode ='bgrcmyk';

if isTime
    [vaDum I J ] = intersect(fix([s1.time]*1e5)/1e5,fix([s2.time]*1e5)/1e5);
    r = plot(s1.dat(I), s2.dat(J), varargin{:});
else
    [vaDum I J ] = intersect(fix([s1.valid]*1e5)/1e5,fix([s2.valid]*1e5)/1e5);
    r = plot(s1.dat(I), s2.dat(J), varargin{:});
end

if(nargout >0)
    varargout{1} = r;
end

try
    xlabel(obj1(1).parameter);
    ylabel(obj2(1).parameter);
catch
end



