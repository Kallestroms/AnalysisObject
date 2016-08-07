function varargout = indecObjPlotXY(obj1,obj2, varargin)
%splot      - plot a ts struct


% several indecObjects (standard with 24 hours pr day)
[valid I J ] = intersect(fix([obj1.valid]*1e5)/1e5,fix([obj2.valid]*1e5)/1e5);

if ~isempty(valid);
    
    obj1 = obj1(I);
    obj2 = obj2(J);
end    
    
    s1 = [obj1.data];
    s2 = [obj2.data];
    
ccode ='bgrcmyk';

if(length(valid)>1)
    % several time structures then plot all where dat is same length in
    % struct s1 and s2
    hold on
    for(i=1:length(valid))
        [vaDum I J ] = intersect(fix([s1(i).valid]*1e5)/1e5,fix([s2(i).valid]*1e5)/1e5)
            iind = mod(i, length(ccode))+1;
            if(nargin == 1)
                r = plot(s1(i).dat(I), s2(i).dat(J), ccode(iind));   
            else
                r = plot(s1(i).dat(I), s2(i).dat(J), varargin{:});   
            end
    end
    hold off
    
else 
    [vaDum I J ] = intersect(fix([s1.valid]*1e5)/1e5,fix([s2.valid]*1e5)/1e5);
    r = plot(s1.dat(I), s2.dat(J), varargin{:});
end


if(nargout >0)
    varargout{1} = r;
end

try
    title(sprintf('valid in the period from %s, to %s',datestr(min(valid),31),datestr(max(valid),31)));
    xlabel(obj1(1).parameter);
    ylabel(obj2(1).parameter);
catch
end


