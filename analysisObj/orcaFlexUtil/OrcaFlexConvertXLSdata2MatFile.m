% set files and sheet to use. 
fname = input('Filename to convert: ','s');
[PATHSTR, NAME, EXT, VRSN] = fileparts(fname);
if(isempty(EXT));fname = [fname,'.xls'];end

% define data sheet in DB
SHEET = 'output';
[dta names] = xlsread(fname,'output');

% set source 
source = names{1,1};
[idum source] = strtok(source,' ');
[source idum] = strtok(source,'.');
source = strrep(source,' ','');

% convert all analysed channels
[nl nc] = size(names);
valid = dta(:,1);
isValid = valid > 0;

% establish data object for conversion
orcaRes(1) = createDataObject([]);
orcaRes(1).data.valid = valid(isValid);
orcaRes(1).data.time = valid(isValid);
orcaRes(1).valid = today;
orcaRes(1).location = 'SeaZephIR @ Block Island';
orcaRes(1).source   = source;
orcaRes(1).type = 'OrcaFlex simulation Results';
orcaRes(1).interpolation = 'NA';

% convert data
for ic = 2:nc;
    orcaRes(ic) = orcaRes(1);
    orcaRes(ic).data.dat = dta(isValid, ic);
    orcaRes(ic).parameter = names{nl(end),ic};
end
orcaRes(1) = [];

save('fdum','source');
save(source,'orcaRes');

clear all
load fdum
load(source);
clear source
