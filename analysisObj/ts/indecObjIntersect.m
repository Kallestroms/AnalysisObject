function    [valid,I,J] = indecObjIntersect(in1,in2);
% intersects two indec data objects and returns the common parts of each
% funcitons on two ecual lenght structures also
out1 = in1;
out2 = in2;

try
    if isfield(in1(1),'dt')
        [valid,I,J] = intersect(fixhours([in1.dt]),fixhours([in2.dt]));
    elseif isfield(in1(1),'valid')
        if (length(in1) == 1 & length(in2) == 1 )
            [valid,I,J] = intersect(fixhours(in1.data.valid),fixhours(in2.data.valid));
        else
            [valid,I,J] = intersect(fixhours([in1.valid]),fixhours([in2.valid]));
        end
    else
        trace('missing datetime definition');
    end
    
    % if indecObjectTimeseries object
catch
    trace('error for indec data object intersection');
end



