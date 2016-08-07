function varargout = analysisObjPlot(obj, varargin)
%splot      - plot a ts struct

s = [obj.data];
leg = {obj.parameter};
ccode ='bgrcmyk';

if(length(s)>1)
   hold on
   for(i=1:length(s))
      iind = mod(i, length(ccode))+1;
      if(nargin == 1)
          r = plot(s(i).time, s(i).dat, ccode(iind));   
      else
          r = plot(s(i).time, s(i).dat, varargin{:});   
      end
   end
   hold off
   
else
   r = plot(s.time, s.dat, varargin{:});
end

legend(leg);

if(nargout >0)
    varargout{1} = r;
end

    