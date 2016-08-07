function [objSTT] = analysisObjCOnvertSttData(FILEPATH,project)
%function [objSTT] = analysisObjCOnvertSttData(FILEPATH,project)
% FILEPATH - full path to where the CSV. file is located relative to parsing directory
% project - project name for struct
%
%
% Programmed by Karl Chr Strømsem , OffTek AS
% 2011-08-10 & vers 2.0
verbose = 0;
fnames = dir(fullfile(FILEPATH,'*.csv'));
nFiles = length(fnames);
colSep = ';';
%colSep = char(9);  % tab separated
TAB = char(9);
mtxLngth = 100000;  % length of pre-allocated matrix
location = 'Stat Towing Tank';
%project  = input('Input test customer project identification: ', 's');

objSTT = analysisObjCreate();
objSTT.date = datestr(today);
objSTT.fs   = []; 

for iFile = 1:nFiles;
    fid = fopen(fullfile(FILEPATH,fnames(iFile).name));
    [pth, nme, ext ]=fileparts(fnames(iFile).name);
    display(sprintf('Running on File: %s',nme));
    source = nme;

    
    % identify number of columns and variable names;
    tline = fgetl(fid);
    nCol = 0;
    while 1
        [R tline] = strtok(tline,colSep);
        if isempty(R);break;end
        nCol = nCol + 1;
        parameter{nCol} = R;
    end
    parameter(1:2) = []; % remove date and time
    nCol = length(parameter);
    
    % read and convert data use first line to set date and t0 for time vector
    tline = fgetl(fid);
    [R tline]   = strtok(tline,colSep);
    run         = datenum(R,'dd.mm.yyyy');
    [R tline]   = strtok(tline,colSep);
    t0 = datenum(R,'HH:MM:SS:FFF');
    
    % create dummy matrix for data to speed up;
    mtx = ones(mtxLngth,nCol)*NaN;
    time = ones(mtxLngth,1)*NaN;
    
    nLine = 0;
    while 1        
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        [R tline]   = strtok(tline,colSep); % drop date
        [R tline]   = strtok(tline,colSep);
        nLine = nLine + 1;
        time(nLine)     = round(1000*(datenum(R,'HH:MM:SS:FFF')-t0)*24*60*60)/1000; % start time = 0 with first sample;
        mtx(nLine,:)    = str2num(strrep(tline,',','.'));
        if verbose 
            if mod(nLine,1000) == 0;display(sprintf('converting line nr: %i',nLine));end
        end
    end
    mtx(nLine+1:end,:) = [];
    time(nLine+1:end,:) = [];
    fclose(fid);
   
    % check and correct time vector for 1000 millisconderror
    % i.e. 1000 ms is interpreted as 100 ms and sec is not updated to next
    % second. 
    dt = median(diff(time));
    is100ms = find(diff(time)<0 == 1);
    time(is100ms+1) = time(is100ms)+dt;
    
    % create a correted time vector using dt as basis to form consisten
    % time vector
    
    time = dt:dt:dt*length(time);
    time = time';

    
    % convert to analysis object format;
    dataObj     = analysisObjCreate([]);
    dataObj.run = date;
    dataObj.location    = location;
    dataObj.project     = project;
    dataObj.date        = date;
    dataObj.source      = source;
    dataObj.fs          = 1../dt;
    
    
    for iCol = 1:nCol;
        analysisObj(iCol)           = dataObj;
        analysisObj(iCol).data.time = time;
        analysisObj(iCol).data.dat  = mtx(:,iCol);
        analysisObj(iCol).parameter = parameter{iCol};
    end
%     outFile = sprintf('Data4%sRun%s',project,nme);
%     save(outFile,'analysisObj');
objSTT = [objSTT analysisObj];
clear dataObj analysisObj  mtx  parameter;
end
objSTT(1) = [];



