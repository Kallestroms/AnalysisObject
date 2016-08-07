function [objOut] = analysisObjReadOrcaFlexSimFileInfo(filename)
% function [objOut] = analysisObjReadOrcaFlexSimFileInfo;
% ------------------------
% The purpose of this routine is to extract all time series information 
% the model information from a orcaflex simulation file and hand back a
% series of analysisObj with the time series data. 
%-----
% input 
% filename - orcaflex simulation file name
% output
% objOut    .model          - orcaflex model object
%           .info.objElem   - orcaflex element objects 
%           .info.objName   - name of orcaflex objects
%           .info.objVars   - parameters available for each object.
% Use to extract time series 
% ts = model(info.objName{ii}).TimeHistory(info.objVars{ii}{nn});

% Programmed: Dr.ing Karl C Strømsem OffTek AS
% Rev & date


model = ofxModel;
model.LoadSimulation(filename);

% find the elements in the file with time series

info.objElem = model.objects';
nObj = length(info.objElem);
for ii = 1:nObj;
    info.objName{ii,1} = info.objElem{ii}.GetData('Name');
    try
        info.objVars{ii,1} = [];
        info.objVars{ii,1} = info.objElem{ii}.vars';
    catch
        disp(sprintf('No variables for ## %s ## Object',info.objName{ii,1}))
    end
end

objOut.model = model;
objOut.info  = info;

