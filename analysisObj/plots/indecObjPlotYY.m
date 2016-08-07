function varargout = indecObjPlotYY(obj1,obj2, varargin)
%indecObjPlotYY - plots indecObjects with two separate Y axis
%function call varargout = indecObjPlotYY(obj1,obj2, varargin)
try
    [valid I J ] = intersect([obj1.valid],[obj2.valid]);
    
    obj1 = indecObj2TsObj(obj1(I));
    obj2 = indecObj2TsObj(obj2(J));
catch
    trace('objects not correlated')
end

% obj1 = obj1(I);
% obj2 = obj2(J);

s1 = [obj1.data];
s2 = [obj2.data];


ccode ='bgrcmyk';

if(nargin == 2)
    [AX, H1,H2] = plotyy(s1.valid, s1.dat, s2.valid, s2.dat);   
else
    [AX, H1,H2] = plotyy(s1.valid, s1.dat, s2.valid, s2.dat);   
    trace('No color control implemented in this plot routine yet')
end


if(nargout >0)
    varargout{1} = r;
end

    try
    title(sprintf('valid in the period from %s, to %s',datestr(min(valid),29),datestr(max(valid),29)));
    axes(AX(1));ylabel(obj1(1).parameter);dateaxis('x',1);
    axes(AX(2));ylabel(obj2(1).parameter);dateaxis('x',1);
catch
end


