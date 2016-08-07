function varargout = indecObjPlot(obj, varargin)
%splot      - plot a ts struct

s = [obj.data];

ccode ='bgrcmyk';

if(length(s)>1)
   hold on
   for(i=1:length(s))
      iind = mod(i, length(ccode))+1;
      if(nargin == 1)
          r = bar(s(i).valid, s(i).dat, ccode(iind));   
      else
          r = bar(s(i).valid, s(i).dat, varargin{:});   
      end
   end
   hold off

else
   r = bar(s.valid, s.dat, varargin{:});
end


if(nargout >0)
    varargout{1} = r;
end

    