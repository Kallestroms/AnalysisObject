function [obj] = analysisObjCreateDataObject(in);
%analysisObjCreateDataObject - will create the proper structure for the analysisObject
% cuntion call; function [obj] = analysisObjCreateDataObject(in);

if ~exist('in');
    in.source = 'emptyStruct';
end


if isfield(in,'data');
    obj.data = in.data;
else
    obj.data.time = NaN*ones(24,1);
    obj.data.dat   = NaN*ones(24,1);
end

if isfield(in,'run');
    obj.run = in.run;
elseif isfield(in,'time');
    obj.run = in.time;
else
    obj.run = -1;
end

if isfield(in,'iter');
    obj.iter = in.iter;
else
    obj.iter = 0;
end

if isfield(in,'time');
    obj.time = in.time;
elseif isfield(in,'run');
    obj.time = in.run;
else
    obj.time = -1;;
end

if isfield(in,'location');
    obj.location = in.location;
else
    obj.location = 'unknown';
end

if isfield(in,'object');
    obj.object = in.object;
else
    obj.object = 'unknown';
end

if isfield(in,'parameter');
    obj.parameter = in.parameter;
else 
    obj.parameter = 'unknown';
end

if isfield(in,'source');
    obj.source = in.source;
else 
    obj.source = 'unknown';
end

if isfield(in,'type');
    obj.type = in.type;
else
    obj.type = 'unknown';
end

if isfield(in,'unit');
    obj.unit = in.unit;
else
    obj.unit = 'unknown';
end

if isfield(in,'interpolation');
    obj.interpolation = in.interpolation;
else
    obj.interpolation = 'unknown';
end

if isfield(in,'project');
    obj.project = in.project;
else
    obj.project = 'unknown';
end

% assure that incomming data filed is reflected in outgoing to ensure
% correct sequence in struct
if ~isempty(in);
    fnameIn     = fieldnames(in);
    fnameOut    = fieldnames(obj);
    
    if length(fnameIn) ~= length(fnameOut);
        for ifield = 1:length(fnameIn)
            if ~isfield(obj,fnameIn(ifield));
                obj.(fnameIn{ifield}) = in.(fnameIn{ifield});
            end
        end
    end
end
