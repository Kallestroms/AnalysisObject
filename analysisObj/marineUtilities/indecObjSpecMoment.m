function out = indecObjSpecMoment(in,N);
%indecObjSpecMoment - calculates spectral moments for use in analysis
%function call out = indecObjSpecMoment(in,N);


out = in;
try
    df = in.data.valid(2)-in.data.valid(1);
    nmom = sum(in.data.dat)*df;
    
    out.data.dat    = nmom;
    out.data.valid  = out.data.valid;
    out.parameter   = sprintf('m%i',N);
    out.type        = sprintf('Spectral Moment');
    out.df          = df;
catch
end